//
//  RightViewController.m
//  UI_深呼吸
//
//  Created by rimi on 15/12/24.
//  Copyright © 2015年 肖恩. All rights reserved.
//

#import "RightViewController.h"
#import "ControllerManager.h"
#import "HomeModel.h"
#import "ManagementModel.h"

static NSString *identify = @"CELL";
@interface RightViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *dataSource;
}
@property (nonatomic, strong)UITableView *rightTab;

@property (nonatomic, strong) HomeModel *home;
@property (nonatomic, strong) ManagementModel *management;

@property (nonatomic, copy) NSString *number;

@end

@implementation RightViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openRigthDrawer:) name:@"openRigthDrawerInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getGroups:) name:@"getGroupsInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(examList:) name:@"examListInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    [self.view addSubview:self.rightTab];
    
    _home = [[HomeModel alloc] init];
    _management = [[ManagementModel alloc] init];
    
}
//传值控制右抽屉
- (void)openRigthDrawer:(NSNotification *)bitice{
    if ([bitice.userInfo[@"number"] isEqualToString:@"0"]){
        _number = @"0";
        [_home getGroupsInfoList];
    }else{
        _number = @"1";
        [_management examListInfoList];
    }
}

//机构下的社团
- (void)getGroups:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        [_rightTab reloadData];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
}
//考试列表
- (void)examList:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        [_rightTab reloadData];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
}
#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    NSDictionary *dic = dataSource[indexPath.row];
    cell.textLabel.text = dic[@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = dataSource[indexPath.row];
    NSString *enId = @"";
    if ([_number isEqualToString:@"0"]) {
        enId = dic[@"id"];
    }else{
        enId = dic[@"course"];
    }
    dic = [NSDictionary dictionary];
    if ([_number isEqualToString:@"0"]) {
        dic = @{@"enId":enId,@"number":@"0"};
    }else{
        dic = @{@"enId":enId,@"number":@"1"};
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"rightDraweInfoList" object:nil userInfo:dic];
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
#pragma mark--getter
- (UITableView *)rightTab{
    if (!_rightTab) {
        _rightTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, XN_WIDTH, XN_HEIGHT)];
        _rightTab.tableFooterView = [[UIView alloc] init];
        _rightTab.dataSource = self;
        _rightTab.delegate = self;
    }
    return _rightTab;
}
@end
