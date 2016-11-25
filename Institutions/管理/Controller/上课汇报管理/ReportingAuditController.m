//
//  ReportingAuditController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/1.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ReportingAuditController.h"
#import "NavigationView.h"
#import "ReuseCell.h"
#import "ReportManagementController.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>

#import "ManagementModel.h"

static NSString *identify = @"ReuseCell";
@interface ReportingAuditController ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray *dataSource;
}
@property (nonatomic, strong)UITableView *reportingTab;

@property (nonatomic, strong) ManagementModel *management;
@end
@implementation ReportingAuditController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reportGroup:) name:@"reportGroupInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"上课记录审核" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        ShareS.isOpen = NO;
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:self.reportingTab];
    
    _management = [[ManagementModel alloc] init];
    
    _reportingTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_management reportGroupInfoList];
        });
    }];
    [self.reportingTab.mj_header beginRefreshing];
}

- (void)reportGroup:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        [_reportingTab reloadData];
    }
    [_reportingTab.mj_header endRefreshing];//结束刷新
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
    cell.title.text = dic[@"name"];
    cell.backView.layer.shadowOffset = CGSizeMake(1, 1);
    cell.backView.layer.shadowColor = [UIColor grayColor].CGColor;
    cell.backView.layer.shadowOpacity = .5f;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(XN_WIDTH - 50, CGRectGetHeight(cell.backView.frame)/2 - 6, 20, 20)];
    label.backgroundColor = XN_COLOR_RED_MINT;
    label.textColor = [UIColor whiteColor];
    label.layer.cornerRadius = 10;
    label.layer.masksToBounds = YES;
    label.text = dic[@"reportNum"];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:label];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    ReportManagementController *reporVC = [[ReportManagementController alloc] init];
    reporVC.groupId = dataSource[indexPath.row][@"id"];
    [self.navigationController pushViewController:reporVC animated:YES];
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
#pragma mark--getter
- (UITableView *)reportingTab{
    if (!_reportingTab) {
        _reportingTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - 64)];
        _reportingTab.tableFooterView = [[UIView alloc] init];
        _reportingTab.dataSource = self;
        _reportingTab.delegate = self;
        _reportingTab.separatorStyle = NO;
    }
    return _reportingTab;
}

@end
