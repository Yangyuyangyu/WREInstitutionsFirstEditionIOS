//
//  CorporateTPlanController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/1.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "CorporateTPlanController.h"
#import "NavigationView.h"
#import "ReuseCell.h"
#import "AddDynamicController.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>

#import "ManagementModel.h"

static NSString *identify = @"ReuseCell";
@interface CorporateTPlanController ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *dataSource;
}
@property (nonatomic, strong)UITableView *corporateTab;

@property (nonatomic, strong) ManagementModel *management;
@end

@implementation CorporateTPlanController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(manage:) name:@"manageInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"社团训练规划" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"] rightButtonImage:[UIImage imageNamed:@"icon_add.png"]];
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
    [self.view addSubview:self.corporateTab];
    
    _management = [[ManagementModel alloc] init];
    
    _corporateTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
            [_management manageInfoList:@"1" typeId:uid];
        });
    }];
    [self.corporateTab.mj_header beginRefreshing];
}
- (void)manage:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        [_corporateTab reloadData];
    }
    [_corporateTab.mj_header endRefreshing];//结束刷新
}


#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReuseCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReuseCell" owner:self options:nil]lastObject];
    }
    cell.backView.layer.shadowOffset = CGSizeMake(1, 1);
    cell.backView.layer.shadowColor = [UIColor grayColor].CGColor;
    cell.backView.layer.shadowOpacity = .5f;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
#pragma mark--getter
- (UITableView *)corporateTab{
    if (!_corporateTab) {
        _corporateTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - 64)];
        _corporateTab.tableFooterView = [[UIView alloc] init];
        _corporateTab.dataSource = self;
        _corporateTab.delegate = self;
        _corporateTab.separatorStyle = NO;
    }
    return _corporateTab;
}

@end
