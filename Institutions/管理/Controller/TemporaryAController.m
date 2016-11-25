//
//  TemporaryAController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/1.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "TemporaryAController.h"
#import "NavigationView.h"
#import "TemporaryCell.h"
#import "ExaminationController.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>

#import "ManagementModel.h"

static NSString *identify = @"TemporaryCell";
@interface TemporaryAController ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *dataSource;
}
@property (nonatomic, strong)UITableView *temporaryTab;

@property (nonatomic, strong) ManagementModel *management;
@end

@implementation TemporaryAController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(manage:) name:@"manageInfoList" object:nil];
    [self.temporaryTab.mj_header beginRefreshing];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"临时帐号审批" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        ShareS.isOpen = NO;
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:self.temporaryTab];
    
    _management = [[ManagementModel alloc] init];
    
    _temporaryTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
            [_management manageInfoList:@"4" typeId:uid];
        });
    }];
}

- (void)manage:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        [_temporaryTab reloadData];
    }
    [_temporaryTab.mj_header endRefreshing];//结束刷新
}
#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TemporaryCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TemporaryCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic = dataSource[indexPath.row];
    NSString *pic = dic[@"head"];
    cell.img.layer.cornerRadius = 20;
    cell.img.layer.masksToBounds = YES;
    [cell.img sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"icon_addteacher_head.png"]];
    cell.name.text = dic[@"name"];
    cell.content.text = dic[@"remark"];
    cell.type.text = dic[@"reason"];
    NSString *status = dic[@"status"];
    if ([status isEqualToString:@"0"]) {
        cell.status.textColor = [UIColor colorWithRed:0.094 green:0.063 blue:1.000 alpha:1.000];
        cell.status.text = @"未审批";
    }else if ([status isEqualToString:@"2"]){
        cell.status.textColor = [UIColor colorWithRed:1.000 green:0.868 blue:0.327 alpha:1.000];
        cell.status.text = @"已拒绝";
    }else {
        cell.status.textColor = XN_COLOR_RED_MINT;
        cell.status.text = @"已通过";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ExaminationController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"ExaminationController"];
    appendVC.isAsk = NO;
    appendVC.status = dataSource[indexPath.row][@"status"];
    appendVC.askId = dataSource[indexPath.row][@"id"];
    [self.navigationController pushViewController:appendVC animated:YES];
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
#pragma mark--getter
- (UITableView *)temporaryTab{
    if (!_temporaryTab) {
        _temporaryTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - 64)];
        _temporaryTab.tableFooterView = [[UIView alloc] init];
        _temporaryTab.dataSource = self;
        _temporaryTab.delegate = self;
    }
    return _temporaryTab;
}

@end
