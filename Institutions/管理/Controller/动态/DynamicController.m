//
//  DynamicController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/1.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "DynamicController.h"
#import "NavigationView.h"
#import "DynamicCell.h"
#import "AddDynamicController.h"
#import "MassController.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>

#import "ManagementModel.h"

static NSString *identify = @"DynamicCell";
@interface DynamicController ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray *dataSource;
}
@property (nonatomic, strong)UITableView *dynamicTab;

@property (nonatomic, strong) ManagementModel *management;
@end

@implementation DynamicController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(manage:) name:@"manageInfoList" object:nil];
    [self.dynamicTab.mj_header beginRefreshing];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"动态" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"] rightButtonImage:[UIImage imageNamed:@"icon_add.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        ShareS.isOpen = NO;
        [self.navigationController popViewControllerAnimated:YES];
    };
    navigationView.rightButtonAction = ^(){
        self.hidesBottomBarWhenPushed = YES;
        UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AddDynamicController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"AddDynamicController"];
        [self.navigationController pushViewController:appendVC animated:YES];
    };
    [self.view addSubview:self.dynamicTab];
    
    _management = [[ManagementModel alloc] init];
    
    _dynamicTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
            [_management manageInfoList:@"1" typeId:uid];
        });
    }];
    
}
- (void)manage:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        [_dynamicTab reloadData];
    }
    [_dynamicTab.mj_header endRefreshing];//结束刷新
}

#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DynamicCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic = dataSource[indexPath.row];
    NSString *pic = dic[@"img"];
    [cell.pic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"default_load_img.png"]];
    cell.title.text = dic[@"title"];
    cell.content.text = dic[@"brief"];
    cell.time.text = dic[@"time"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MassController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"MassController"];
    appendVC.ID = dataSource[indexPath.row][@"id"];
    [self.navigationController pushViewController:appendVC animated:YES];
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
#pragma mark--getter
- (UITableView *)dynamicTab{
    if (!_dynamicTab) {
        _dynamicTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - 64)];
        _dynamicTab.tableFooterView = [[UIView alloc] init];
        _dynamicTab.dataSource = self;
        _dynamicTab.delegate = self;
    }
    return _dynamicTab;
}

@end
