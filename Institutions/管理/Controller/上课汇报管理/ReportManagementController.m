//
//  ReportManagementController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/12.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ReportManagementController.h"
#import "ReportingCell.h"
#import "NavigationView.h"
#import "ReportDetailController.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>

#import "ManagementModel.h"
//新增
#import "DYTPopupManager.h"
#import "Change_Search.h"


static NSString *identify = @"ReportingCell";
@interface ReportManagementController ()<UITableViewDataSource ,UITableViewDelegate,DYTPopupManagerDelegate,Change_SearchProtocol>{
    NSArray *dataSource;
}
@property (nonatomic, strong)UITableView *rManagementTab;
@property (nonatomic, strong) ManagementModel *management;
//新增
@property (nonatomic,strong) DYTPopupManager *popupManager;

@end

@implementation ReportManagementController
//查询结果
-(void)check:(NSString *)startTime endtime:(NSString *)endTime className:(NSString *)className teacherName:(NSString *)teacherName state:(NSString *)state{
    //获取传值进行查询
    [self.popupManager hiddenPopupViewWithAnimation:NO];
    NSLog(@"开始时间:%@ 结束时间:%@ 课程名:%@ 老师名:%@ 状态:%@",startTime,endTime,className,teacherName,state);
    NSString*stateIndex=nil;
    if([state isEqualToString:@"未审核"]){
        stateIndex=@"0";
    }else if([state isEqualToString:@"通过"]){
        stateIndex=@"1";
    }else if([state isEqualToString:@"拒绝"]){
        stateIndex=@"2";
    }
    startTime = [startTime stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    endTime = [endTime stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    className = [className stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    teacherName = [teacherName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    state = [state stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [_management manageCheckInfoList:@"9" typeId:_groupId status:stateIndex courseName:className teacher:teacherName startDate:startTime endDate:endTime];
    
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(manage:) name:@"manageInfoList" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(manageCheck:) name:@"manageCheckInfoList" object:nil];
    [self.rManagementTab.mj_header beginRefreshing];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.843 alpha:1.000];
    
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"上课记录审核" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"] rightButtonImage:[UIImage imageNamed:@"icon_search_white.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    //查询
    self.popupManager = [[DYTPopupManager alloc] init];
    self.popupManager.delegate = self;
    navigationView.rightButtonAction=^(){
        Change_Search *viewController = [[Change_Search alloc] init];
        viewController.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 190);
        viewController.theDelegate=self;
        [self.popupManager showPopupViewWithViewController:viewController style:DYTPopupStyleNone maskStyle:DYTPopupMaskStyleGray position:DYTPopupPositionCenter animation:YES];
    };
    [self.view addSubview:self.rManagementTab];
    
    _management = [[ManagementModel alloc] init];
    
    _rManagementTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_management manageInfoList:@"9" typeId:_groupId];
        });
    }];
    
}

- (void)manage:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        [_rManagementTab reloadData];
    }
    [_rManagementTab.mj_header endRefreshing];//结束刷新
}

//查询
-(void)manageCheck:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        [MBProgressHUD showError:@"查询成功"];
        dataSource = bitice.userInfo[@"data"];
        [_rManagementTab reloadData];
        
    }else{
        NSString*error=[NSString stringWithFormat:@"查询失败%@",bitice.userInfo[@"msg"]];
        
        [MBProgressHUD showError:error];
    }
    [_rManagementTab.mj_header endRefreshing];//结束刷新
}

#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReportingCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReportingCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic = dataSource[indexPath.row];
    NSString *str = dic[@"status"];
    if ([str isEqualToString:@"0"]) {
        cell.backPic.image = [UIImage imageNamed:@"reportwait.png"];
        cell.tickPic.image = [UIImage imageNamed:@"ic_gougou_gray.png"];
    }else{
        cell.backPic.image = [UIImage imageNamed:@"reportRed.png"];
        cell.tickPic.image = [UIImage imageNamed:@"ic_gougou_green.png"];
    }
    NSString *img = dic[@"img"];
    [cell.headerPic sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"default_load_img.png"]];
    cell.titel.text = dic[@"name"];
    cell.name.text = dic[@"teacher"];
    cell.timer.text = dic[@"class_time"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    ReportDetailController *reporVc = [[ReportDetailController alloc] init];
    reporVc.dataId = dataSource[indexPath.row][@"id"];
    [self.navigationController pushViewController:reporVc animated:YES];
}
/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
#pragma mark--getter
- (UITableView *)rManagementTab{
    if (!_rManagementTab) {
        _rManagementTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - 64)];
        _rManagementTab.tableFooterView = [[UIView alloc] init];
        _rManagementTab.backgroundColor = [UIColor colorWithWhite:0.843 alpha:1.000];
        _rManagementTab.dataSource = self;
        _rManagementTab.delegate = self;
    }
    return _rManagementTab;
}
@end
