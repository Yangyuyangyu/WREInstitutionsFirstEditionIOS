//
//  MoneyController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/5/31.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "MoneyController.h"
#import "MoneyCell.h"
#import "NavigationView.h"
#import "WithdrawalController.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>

#import "HomeModel.h"

static NSString *identify = @"MoneyCell";
@interface MoneyController ()<UITableViewDelegate, UITableViewDataSource>{
    NSDictionary *dataSourceDic;
}
@property (weak, nonatomic) IBOutlet UIView *backView;
//总收入
@property (weak, nonatomic) IBOutlet UILabel *total;
//当前余额
@property (weak, nonatomic) IBOutlet UILabel *current;
//可提现
@property (weak, nonatomic) IBOutlet UILabel *withdrawal;
//累计
@property (weak, nonatomic) IBOutlet UILabel *cumulative;

@property (weak, nonatomic) IBOutlet UITableView *moneyTab;

@property (nonatomic, strong)HomeModel *home;
@end

@implementation MoneyController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finance:) name:@"financeInfoList" object:nil];
    [_home financeInfoList];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"资金管理" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        self.tabBarController.tabBar.translucent = true;
        ShareS.isOpen = NO;
        [self.navigationController popViewControllerAnimated:YES];
    };
    _home = [[HomeModel alloc] init];
    self.tabBarController.tabBar.translucent = false;
    _moneyTab.dataSource = self;
    _moneyTab.delegate = self;
    _moneyTab.tableHeaderView = _backView;
    
    dataSourceDic = [NSDictionary dictionary];
    
}
- (void)finance:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSourceDic = [self deleteAllNullValue:bitice.userInfo[@"data"]];
        _total.text = dataSourceDic[@"income"];
        _current.text = dataSourceDic[@"balance"];
        _withdrawal.text = dataSourceDic[@"income"];
        _cumulative.text = dataSourceDic[@"expense"];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
}
#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MoneyCell" owner:self options:nil]lastObject];
    }
    _moneyTab.contentSize = CGSizeMake(0, 65 * 3 + _backView.bounds.size.height);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*设置cell 的宽度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
//提现按钮
- (IBAction)withdrawal:(UIButton *)sender {
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.hidesBottomBarWhenPushed = YES;
    WithdrawalController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"WithdrawalController"];
    [self.navigationController pushViewController:appendVC animated:YES];
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
@end
