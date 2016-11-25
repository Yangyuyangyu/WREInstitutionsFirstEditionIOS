//
//  LocationController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/13.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "LocationController.h"
#import "NavigationView.h"
#import "DrawerModel.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface LocationController ()<UIPickerViewDataSource, UIPickerViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>{
    BMKLocationService *_locService;
    BMKMapView* _mapView;
}
//当前位置
@property (weak, nonatomic) IBOutlet UIButton *location;
//省市
@property (weak, nonatomic) IBOutlet UIButton *cities;
@property (nonatomic, strong, readonly)BMKGeoCodeSearch* geocodesearch;//地图编码

@property (nonatomic, strong) UIView *pickerBgView;
@property (nonatomic, strong) UIPickerView *myPicker;
@property (strong, nonatomic) UIView *maskView;

//data
@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) NSArray *selectedArray;

@property (nonatomic, strong) DrawerModel *drawer;
//当前位置
@property (weak, nonatomic) IBOutlet UILabel *current;
//选择的省市区
@property (nonatomic, copy) NSString *citi;
//用户纬度
@property (nonatomic, copy, readonly) NSString *locaLatitude;

//用户经度
@property (nonatomic, copy, readonly) NSString *locaLongitude;
//判断是否是选择的当前位置
@property (nonatomic, assign) BOOL isLocation;
@end

@implementation LocationController
- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [_mapView viewWillAppear];
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        NSLog(@"请打开您的位置服务!");
    }
    self.navigationController.navigationBarHidden = YES;
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _mapView.centerCoordinate = (CLLocationCoordinate2D){30.663479,104.072292};
    _locService.delegate = self;
    _geocodesearch.delegate = self;
    [_locService startUserLocationService];
    _locService.distanceFilter = 200.0f;
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    [self onClickReverseGeocode];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(edit:) name:@"editInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _geocodesearch.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"位置" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    _locService = [[BMKLocationService alloc]init];
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    _mapView = [[BMKMapView alloc]init];
    
    _drawer = [[DrawerModel alloc] init];
    
    _isLocation = NO;
    [self getPickerData];
    [self initView];
}

- (void)edit:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        NSUserDefaults *defailts = [NSUserDefaults standardUserDefaults];
        if (_isLocation == YES) {
            [defailts setObject:_current.text forKey:@"location"];
        }else{
            [defailts setObject:_citi forKey:@"location"];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
    }
}
#pragma mark - init view
- (void)initView {
    self.maskView = [[UIView alloc] initWithFrame:XN_kScreen_Frame];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];
}
#pragma mark - get data
- (void)getPickerData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    self.pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.provinceArray = [self.pickerDic allKeys];
    
    self.selectedArray = [self.pickerDic objectForKey:[[self.pickerDic allKeys] objectAtIndex:0]];
    if (self.selectedArray.count > 0) {
        self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
    }
    
    if (self.cityArray.count > 0) {
        self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
    }
    
}

#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.townArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.provinceArray objectAtIndex:row];
    } else if (component == 1) {
        return [self.cityArray objectAtIndex:row];
    } else {
        return [self.townArray objectAtIndex:row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 110;
    } else if (component == 1) {
        return 100;
    } else {
        return 110;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedArray = [self.pickerDic objectForKey:[self.provinceArray objectAtIndex:row]];
        if (self.selectedArray.count > 0) {
            self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
        } else {
            self.cityArray = nil;
        }
        if (self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
        } else {
            self.townArray = nil;
        }
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    
    if (component == 1) {
        if (self.selectedArray.count > 0 && self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:row]];
        } else {
            self.townArray = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    
    [pickerView reloadComponent:2];
}
//当前位置
- (IBAction)location:(UIButton *)sender {
    if (_current.text.length == 0) {
        [MBProgressHUD showError:@"定位失败"];
    }else{
        _isLocation = YES;
        [_drawer editInfoList:@"1" content:_current.text];
    }
}
//省市
- (IBAction)cities:(UIButton *)sender {
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.pickerBgView];
    self.maskView.alpha = 0;
    self.pickerBgView.top = self.view.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.3;
        self.pickerBgView.bottom = self.view.height;
    }];
}

- (void)hideMyPicker {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.pickerBgView.top = self.view.height;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];
}

- (void)cancel:(UIButton *)sender{
    [self hideMyPicker];
}

- (void)ensure:(UIButton *)sender{
    _isLocation = NO;
    NSString *location = [NSString stringWithFormat:@"%@-%@-%@",[self.provinceArray objectAtIndex:[self.myPicker selectedRowInComponent:0]],[self.cityArray objectAtIndex:[self.myPicker selectedRowInComponent:1]],[self.townArray objectAtIndex:[self.myPicker selectedRowInComponent:2]]];
    _citi = location;
    [self.cities setTitle:location forState:UIControlStateNormal];
    [_drawer editInfoList:@"1" content:location];
    [self hideMyPicker];
}
#pragma mark --getter
- (UIView *)pickerBgView{
    if (!_pickerBgView) {
        _pickerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, XN_HEIGHT - 255, XN_WIDTH, 255)];
        _pickerBgView.backgroundColor = [UIColor whiteColor];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 45, XN_WIDTH, 1)];
        view.backgroundColor = [UIColor lightGrayColor];
        [_pickerBgView addSubview:view];
        
        _myPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 35 , XN_WIDTH, _pickerBgView.height - 40)];
        _myPicker.delegate = self;
        _myPicker.dataSource = self;
        [_pickerBgView addSubview:_myPicker];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeSystem];
        cancel.frame = CGRectMake(8, 5, 80, 39);
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTintColor:[UIColor whiteColor]];
        cancel.layer.cornerRadius = 5;
        cancel.layer.masksToBounds = YES;
        cancel.backgroundColor = XN_COLOR_RED_MINT;
        [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [_pickerBgView addSubview:cancel];
        
        UIButton *ensure = [UIButton buttonWithType:UIButtonTypeSystem];
        ensure.frame = CGRectMake(_pickerBgView.right - 88, 5, 80, 39);
        [ensure setTitle:@"确定" forState:UIControlStateNormal];
        [ensure setTintColor:[UIColor whiteColor]];
        ensure.layer.cornerRadius = 5;
        ensure.layer.masksToBounds = YES;
        ensure.backgroundColor = XN_COLOR_RED_MINT;
        [ensure addTarget:self action:@selector(ensure:) forControlEvents:UIControlEventTouchUpInside];
        [_pickerBgView addSubview:ensure];
    }
    return _pickerBgView;
}

//反向地理编码
- (void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        _current.text = [NSString stringWithFormat:@"%@",item.title];
        _mapView.centerCoordinate = result.location;
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}
//获取我的地址
- (void)onClickReverseGeocode
{
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    _locaLatitude = [NSString stringWithFormat:@"%f",_locService.userLocation.location.coordinate.latitude];
    _locaLongitude = [NSString stringWithFormat:@"%f",_locService.userLocation.location.coordinate.longitude];
    if (_locaLongitude != nil && _locaLatitude != nil) {
        pt = (CLLocationCoordinate2D){[_locaLatitude floatValue], [_locaLongitude floatValue]};
    }
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

//用户位置更新后，会调用此函数
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    [self onClickReverseGeocode];
}
@end
