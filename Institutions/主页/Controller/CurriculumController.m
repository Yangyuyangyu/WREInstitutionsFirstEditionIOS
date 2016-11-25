//
//  CurriculumController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/5/31.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "CurriculumController.h"
#import "NavigationView.h"
#import "CourseCell.h"
#import "CourseDetailsController.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>

#import "HomeModel.h"

static NSString *identify = @"CourseCell";
@interface CurriculumController ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray *dataSouce;
    NSArray *weekArray1;
    NSArray *weekArray2;
    NSArray *weekArray3;
    NSArray *weekArray4;
    NSArray *weekArray5;
    NSArray *weekArray6;
    NSArray *weekArray7;
    NSArray *weekArray;
}
@property (weak, nonatomic) IBOutlet UIButton *week1;
@property (weak, nonatomic) IBOutlet UIButton *week2;
@property (weak, nonatomic) IBOutlet UIButton *week3;
@property (weak, nonatomic) IBOutlet UIButton *week4;
@property (weak, nonatomic) IBOutlet UIButton *week5;
@property (weak, nonatomic) IBOutlet UIButton *week6;
@property (weak, nonatomic) IBOutlet UIButton *week7;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;
@property (weak, nonatomic) IBOutlet UIView *view7;
@property (weak, nonatomic) IBOutlet UITableView *scheduleTab;
@property (nonatomic, assign)NSInteger date;

@property (nonatomic, assign)BOOL isDropDown;//判断是否是下拉刷新
@property (nonatomic, assign)NSInteger subscript;//判断在星期几下拉刷新

@property (nonatomic, strong) HomeModel *home;
@property (nonatomic, strong) NavigationView *navigationView;

@property (nonatomic, assign) NSInteger weekdate;//判断是第几周
@property (nonatomic, assign) NSInteger number;//记录第几周的星期几
@end

@implementation CurriculumController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(courseList:) name:@"courseListInfoList" object:nil];
    [_home courseListInfoList:[NSString stringWithFormat:@"%ld",(long)_weekdate]];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _view1.backgroundColor = [UIColor whiteColor];
    _view2.backgroundColor = [UIColor whiteColor];
    _view3.backgroundColor = [UIColor whiteColor];
    _view4.backgroundColor = [UIColor whiteColor];
    _view5.backgroundColor = [UIColor whiteColor];
    _view6.backgroundColor = [UIColor whiteColor];
    _view7.backgroundColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    _navigationView = [[NavigationView alloc] initWithTitle:@"课程表(本周)" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:_navigationView];
    _navigationView.leftButtonAction = ^(){
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    _scheduleTab.dataSource = self;
    _scheduleTab.delegate = self;
    _scheduleTab.tableFooterView = [[UIView alloc] init];
    _isDropDown = NO;
    
    _number = 0;
    _weekdate = 0;
    
    CGRect frame1 = CGRectMake(XN_WIDTH - 90, 32.5, 50, 25);
    [self addButton:frame1 number:100 titel:@"下一周"];
    CGRect frame2 = CGRectMake(40, 32.5, 50, 25);
    [self addButton:frame2 number:101 titel:@"上一周"];
    
    _scheduleTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _isDropDown = YES;
            [_home courseListInfoList:[NSString stringWithFormat:@"%ld",(long)_weekdate]];
            [_scheduleTab.mj_header endRefreshing];//结束刷新
        });
    }];
    
    _home = [[HomeModel alloc] init];
    
    dataSouce = [NSArray array];
    weekArray1 = [NSArray array];
    weekArray2 = [NSArray array];
    weekArray3 = [NSArray array];
    weekArray4 = [NSArray array];
    weekArray5 = [NSArray array];
    weekArray6 = [NSArray array];
    weekArray7 = [NSArray array];
    
}

- (void)courseList:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        weekArray = nil;
        if (_isDropDown == NO || _subscript == 0) {
            _date = [self getNowWeekday];
        }else{
            _date = _subscript;
        }
        dataSouce = bitice.userInfo[@"data"];
        for (int i = 0; i < dataSouce.count; i ++) {
            NSInteger week = [dataSouce[i][@"week"]integerValue];
            NSArray *array = dataSouce[i][@"course"];
            switch (week) {
                case 1:
                    weekArray1 = array;
                    break;
                case 2:
                    weekArray2 = array;
                    break;
                case 3:
                    weekArray3 = array;
                    break;
                case 4:
                    weekArray4 = array;
                    break;
                case 5:
                    weekArray5 = array;
                    break;
                case 6:
                    weekArray6 = array;
                    break;
                case 7:
                    weekArray7 = array;
                    break;
                default:
                    break;
            }
        }
        if (_weekdate == 0) {
            switch (_date) {
                case 1:
                    _view7.backgroundColor = XN_COLOR_RED_MINT;
                    weekArray = weekArray7;
                    if (_isDropDown == NO) {
                        [_week7 setTitleColor:XN_COLOR_RED_MINT forState:UIControlStateNormal];
                        _number = 7;
                    }
                    break;
                case 2:
                    _view1.backgroundColor = XN_COLOR_RED_MINT;
                    weekArray = weekArray1;
                    if (_isDropDown == NO) {
                        [_week1 setTitleColor:XN_COLOR_RED_MINT forState:UIControlStateNormal];
                        _number = 1;
                    }
                    break;
                case 3:
                    _view2.backgroundColor = XN_COLOR_RED_MINT;
                    weekArray = weekArray2;
                    if (_isDropDown == NO) {
                        [_week2 setTitleColor:XN_COLOR_RED_MINT forState:UIControlStateNormal];
                        _number = 2;
                    }
                    break;
                case 4:
                    _view3.backgroundColor = XN_COLOR_RED_MINT;
                    weekArray = weekArray3;
                    if (_isDropDown == NO) {
                        [_week3 setTitleColor:XN_COLOR_RED_MINT forState:UIControlStateNormal];
                        _number = 3;
                    }
                    break;
                case 5:
                    _view4.backgroundColor = XN_COLOR_RED_MINT;
                    weekArray = weekArray4;
                    if (_isDropDown == NO) {
                        [_week4 setTitleColor:XN_COLOR_RED_MINT forState:UIControlStateNormal];
                        _number = 4;
                    }
                    break;
                case 6:
                    _view5.backgroundColor = XN_COLOR_RED_MINT;
                    weekArray = weekArray5;
                    if (_isDropDown == NO) {
                        [_week5 setTitleColor:XN_COLOR_RED_MINT forState:UIControlStateNormal];
                        _number = 5;
                    }
                    break;
                case 7:
                    _view6.backgroundColor = XN_COLOR_RED_MINT;
                    weekArray = weekArray6;
                    if (_isDropDown == NO) {
                        [_week6 setTitleColor:XN_COLOR_RED_MINT forState:UIControlStateNormal];
                        _number = 6;
                    }
                    break;
                default:
                    break;
            }
        }else{
            switch (_date) {
                case 1:
                    _view7.backgroundColor = XN_COLOR_RED_MINT;
                    weekArray = weekArray7;
                    break;
                case 2:
                    _view1.backgroundColor = XN_COLOR_RED_MINT;
                    weekArray = weekArray1;
                    break;
                case 3:
                    _view2.backgroundColor = XN_COLOR_RED_MINT;
                    weekArray = weekArray2;
                    break;
                case 4:
                    _view3.backgroundColor = XN_COLOR_RED_MINT;
                    weekArray = weekArray3;
                    break;
                case 5:
                    _view4.backgroundColor = XN_COLOR_RED_MINT;
                    weekArray = weekArray4;
                    break;
                case 6:
                    _view5.backgroundColor = XN_COLOR_RED_MINT;
                    weekArray = weekArray5;
                    break;
                case 7:
                    _view6.backgroundColor = XN_COLOR_RED_MINT;
                    weekArray = weekArray6;
                    break;
                default:
                    break;
            }
        }
        if (weekArray.count == 0) {
            [MBProgressHUD showError:@"暂无数据"];
        }
        [_scheduleTab reloadData];
    }else if ([bitice.userInfo[@"code"] isEqualToNumber:@(-1)]){
        [MBProgressHUD showError:@"暂无数据"];
        weekArray = nil;
        weekArray1 = nil;
        weekArray2 = nil;
        weekArray3 = nil;
        weekArray4 = nil;
        weekArray5 = nil;
        weekArray6 = nil;
        weekArray7 = nil;
        [_scheduleTab reloadData];
    }
}

#pragma mark--UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return weekArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CourseCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic = weekArray[indexPath.row];
    [cell.pic sd_setImageWithURL:dic[@"img"] placeholderImage:[UIImage imageNamed:@"default_load_img.png"]];
    cell.title.text = dic[@"name"];
    cell.content.text = dic[@"brief"];
    NSString *type = dic[@"type"];
    if ([type isEqualToString:@"1"]) {
        cell.lesson.text = @"【一对多】";
    }else{
        cell.lesson.text = @"【一对一】";
    }
    cell.time.text = dic[@"class_time"];
    cell.teacherName.text = dic[@"teacher_name"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _isDropDown = YES;
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.hidesBottomBarWhenPushed = YES;
    CourseDetailsController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"CourseDetailsController"];
    appendVC.courseId = weekArray[indexPath.row][@"cid"];
    appendVC.courseName = weekArray[indexPath.row][@"name"];
    [self.navigationController pushViewController:appendVC animated:YES];
}

#pragma mark--按钮的点击事件

//上下一周
- (void)handleEvent:(UIButton *)sender{
    _isDropDown = YES;
    NSArray *array = @[_week1,_week2,_week3,_week4,_week5,_week6,_week7];
    NSArray *nameArray  = @[@"课程表(前三周)",@"课程表(前两周)",@"课程表(前一周)",@"课程表(本周)",@"课程表(后一周)",@"课程表(后两周)",@"课程表(后三周)"];
    if (sender.tag == 100) {
        _weekdate ++;
        if (_weekdate > 3) {
            [MBProgressHUD showError:@"只能查看后三周的课"];
            _weekdate = 3;
        }else{
            for (int i = 0; i < nameArray.count; i ++) {
                _navigationView.titleLabel.text = nameArray[_weekdate + 3];
                [_navigationView.titleLabel sizeToFit];
                _navigationView.titleLabel.center = CGPointMake(XN_WIDTH/2, 45);
            }
        }
        if (_weekdate == 0) {
            for (int i = 0; i < array.count; i ++) {
                [array[_number - 1] setTitleColor:XN_COLOR_RED_MINT forState:UIControlStateNormal];
            }
        }else{
            for (int i = 0; i < array.count; i ++) {
                [array[i] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
        [_home courseListInfoList:[NSString stringWithFormat:@"%ld",(long)_weekdate]];
    }else{
        _weekdate --;
        if (_weekdate < -3) {
            [MBProgressHUD showError:@"只能查看前三周的课"];
            _weekdate = -3;
        }else{
            for (int i = 0; i < nameArray.count; i ++) {
                _navigationView.titleLabel.text = nameArray[_weekdate + 3];
                [_navigationView.titleLabel sizeToFit];
                _navigationView.titleLabel.center = CGPointMake(XN_WIDTH/2, 45);
            }
        }
        if (_weekdate == 0) {
            for (int i = 0; i < array.count; i ++) {
                [array[_number - 1] setTitleColor:XN_COLOR_RED_MINT forState:UIControlStateNormal];
            }
        }else{
            for (int i = 0; i < array.count; i ++) {
                [array[i] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
        [_home courseListInfoList:[NSString stringWithFormat:@"%ld",(long)_weekdate]];
    }
    _view1.backgroundColor = [UIColor whiteColor];
    _view2.backgroundColor = [UIColor whiteColor];
    _view3.backgroundColor = [UIColor whiteColor];
    _view4.backgroundColor = [UIColor whiteColor];
    _view5.backgroundColor = [UIColor whiteColor];
    _view6.backgroundColor = [UIColor whiteColor];
    _view7.backgroundColor = [UIColor whiteColor];
}


- (IBAction)week:(UIButton *)sender {
    switch (sender.tag) {
        case 2:
            _view1.backgroundColor = XN_COLOR_RED_MINT;
            _view2.backgroundColor = [UIColor whiteColor];
            _view3.backgroundColor = [UIColor whiteColor];
            _view4.backgroundColor = [UIColor whiteColor];
            _view5.backgroundColor = [UIColor whiteColor];
            _view6.backgroundColor = [UIColor whiteColor];
            _view7.backgroundColor = [UIColor whiteColor];
            weekArray = weekArray1;
            break;
        case 3:
            _view2.backgroundColor = XN_COLOR_RED_MINT;
            _view1.backgroundColor = [UIColor whiteColor];
            _view3.backgroundColor = [UIColor whiteColor];
            _view4.backgroundColor = [UIColor whiteColor];
            _view5.backgroundColor = [UIColor whiteColor];
            _view6.backgroundColor = [UIColor whiteColor];
            _view7.backgroundColor = [UIColor whiteColor];
            weekArray = weekArray2;
            break;
        case 4:
            _view3.backgroundColor = XN_COLOR_RED_MINT;
            _view1.backgroundColor = [UIColor whiteColor];
            _view2.backgroundColor = [UIColor whiteColor];
            _view4.backgroundColor = [UIColor whiteColor];
            _view5.backgroundColor = [UIColor whiteColor];
            _view6.backgroundColor = [UIColor whiteColor];
            _view7.backgroundColor = [UIColor whiteColor];
            weekArray = weekArray3;
            break;
        case 5:
            _view4.backgroundColor = XN_COLOR_RED_MINT;
            _view1.backgroundColor = [UIColor whiteColor];
            _view2.backgroundColor = [UIColor whiteColor];
            _view3.backgroundColor = [UIColor whiteColor];
            _view5.backgroundColor = [UIColor whiteColor];
            _view6.backgroundColor = [UIColor whiteColor];
            _view7.backgroundColor = [UIColor whiteColor];
            weekArray = weekArray4;
            break;
        case 6:
            _view5.backgroundColor = XN_COLOR_RED_MINT;
            _view1.backgroundColor = [UIColor whiteColor];
            _view2.backgroundColor = [UIColor whiteColor];
            _view4.backgroundColor = [UIColor whiteColor];
            _view3.backgroundColor = [UIColor whiteColor];
            _view6.backgroundColor = [UIColor whiteColor];
            _view7.backgroundColor = [UIColor whiteColor];
            weekArray = weekArray5;
            break;
        case 7:
            _view6.backgroundColor = XN_COLOR_RED_MINT;
            _view1.backgroundColor = [UIColor whiteColor];
            _view2.backgroundColor = [UIColor whiteColor];
            _view4.backgroundColor = [UIColor whiteColor];
            _view5.backgroundColor = [UIColor whiteColor];
            _view3.backgroundColor = [UIColor whiteColor];
            _view7.backgroundColor = [UIColor whiteColor];
            weekArray = weekArray6;
            break;
        case 1:
            _view7.backgroundColor = XN_COLOR_RED_MINT;
            _view1.backgroundColor = [UIColor whiteColor];
            _view2.backgroundColor = [UIColor whiteColor];
            _view4.backgroundColor = [UIColor whiteColor];
            _view5.backgroundColor = [UIColor whiteColor];
            _view6.backgroundColor = [UIColor whiteColor];
            _view3.backgroundColor = [UIColor whiteColor];
            weekArray = weekArray7;
            break;
        default:
            break;
    }
    _subscript = sender.tag;
    if (weekArray.count == 0) {
        [MBProgressHUD showError:@"暂无数据"];
    }
    [_scheduleTab reloadData];
}
/*!
 *  @brief 去除字典空值
 */
- (NSDictionary *)deleteAllNullValue:(NSDictionary *)dic
{
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    for (NSString *keyStr in dic.allKeys) {
        if ([[dic  objectForKey:keyStr] isEqual:[NSNull null]]) {
            [mutableDic setObject:@"" forKey:keyStr];
        }
        else{
            [mutableDic setObject:[dic objectForKey:keyStr] forKey:keyStr];
        }
    }
    return mutableDic;
}

// 获取当前是星期几
- (NSInteger)getNowWeekday {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate *now = [NSDate date];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:now];
    return [comps weekday];
}

- (void)addButton:(CGRect)frame number:(NSInteger)number titel:(NSString *)titel{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    [button setTitle:titel forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor grayColor].CGColor;
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.tag = number;
    [button addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
@end
