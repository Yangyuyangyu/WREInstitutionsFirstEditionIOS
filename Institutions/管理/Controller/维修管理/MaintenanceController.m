//
//  MaintenanceController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/1.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "MaintenanceController.h"
#import "NavigationView.h"
#import "ReuseCell.h"
#import "SystemController.h"
#import "HomeModel.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>


static NSString *identify = @"ReuseCell";
@interface MaintenanceController ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray *dataSource;
}
@property (nonatomic, strong)UITableView *maintenanceTab;

@property (nonatomic, strong) HomeModel *home;
@end

@implementation MaintenanceController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getGroups:) name:@"getGroupsInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"维修管理" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        ShareS.isOpen = NO;
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:self.maintenanceTab];
    _home = [[HomeModel alloc] init];
    _maintenanceTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_home getGroupsInfoList];
        });
    }];
    [self.maintenanceTab.mj_header beginRefreshing];
}
//机构下的社团
- (void)getGroups:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        [_maintenanceTab reloadData];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
    [_maintenanceTab.mj_header endRefreshing];//结束刷新
}
#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReuseCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReuseCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic = dataSource[indexPath.row];
    cell.backView.layer.shadowOffset = CGSizeMake(1, 1);
    cell.backView.layer.shadowColor = [UIColor grayColor].CGColor;
    cell.backView.layer.shadowOpacity = .5f;
    cell.title.text = dic[@"name"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SystemController * sysVC = [mainSB instantiateViewControllerWithIdentifier:@"SystemController"];
    sysVC.communityId = dataSource[indexPath.row][@"id"];
    [self.navigationController pushViewController:sysVC animated:YES];
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
#pragma mark--getter
- (UITableView *)maintenanceTab{
    if (!_maintenanceTab) {
        _maintenanceTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - 64)];
        _maintenanceTab.tableFooterView = [[UIView alloc] init];
        _maintenanceTab.dataSource = self;
        _maintenanceTab.delegate = self;
        _maintenanceTab.separatorStyle = NO;
    }
    return _maintenanceTab;
}

@end
