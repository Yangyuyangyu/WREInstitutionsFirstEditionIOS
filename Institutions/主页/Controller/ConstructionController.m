//
//  ConstructionController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/5/31.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//  社团建设表

#import "ConstructionController.h"
#import "NavigationView.h"
#import "ConstructionCell.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>

#import "HomeModel.h"

static NSString *identify = @"ConstructionCell";
@interface ConstructionController ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray *dataSource;
}
@property (nonatomic, strong)UITableView *contructionTab;

@property (nonatomic, strong) HomeModel *home;
@end

@implementation ConstructionController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(groupBuild:) name:@"groupBuildInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"社团建设表" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        ShareS.isOpen = NO;
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:self.contructionTab];
    
    _home = [[HomeModel alloc] init];
    
    _contructionTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_home groupBuildInfoList];
        });
    }];
    [self.contructionTab.mj_header beginRefreshing];
}

- (void)groupBuild:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        [_contructionTab reloadData];
    }
    [_contructionTab.mj_header endRefreshing];//结束刷新
}
#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConstructionCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ConstructionCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic = dataSource[indexPath.row];
    cell.titel.text = dic[@"name"];
    cell.name.text = [NSString stringWithFormat:@"管理员:%@",dic[@"admins"]];
    cell.time.text = dic[@"ctime"];
    cell.student.text = [NSString stringWithFormat:@"%@学生",dic[@"studentNum"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*设置cell 的宽度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
#pragma mark--getter
- (UITableView *)contructionTab{
    if (!_contructionTab) {
        _contructionTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - 64)];
        _contructionTab.tableFooterView = [[UIView alloc] init];
        _contructionTab.dataSource = self;
        _contructionTab.delegate = self;
    }
    return _contructionTab;
}

@end
