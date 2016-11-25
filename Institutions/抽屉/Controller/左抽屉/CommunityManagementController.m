//
//  CommunityManagementController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/15.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "CommunityManagementController.h"
#import "NavigationView.h"
#import "ReuseCell.h"
#import "AddDynamicController.h"
#import "HomeModel.h"
#import "ProjectController.h"

static NSString *identify = @"ReuseCell";
@interface CommunityManagementController ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *dataSource;
}
@property (nonatomic, strong)UITableView *corporateTab;

@property (nonatomic, strong) HomeModel *home;
@end

@implementation CommunityManagementController
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
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"社团管理制度" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"] rightButtonImage:[UIImage imageNamed:@"icon_add.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    navigationView.rightButtonAction = ^(){
        self.hidesBottomBarWhenPushed = YES;
        UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AddDynamicController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"AddDynamicController"];
        [self.navigationController pushViewController:appendVC animated:YES];
    };
    [self.view addSubview:self.corporateTab];
    
    _home = [[HomeModel alloc] init];
    [_home getGroupsInfoList];
}

//查询社团
- (void)getGroups:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        [_corporateTab reloadData];
    }else{
        [MBProgressHUD showError:@"获取信息失败"];
    }
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
    cell.backView.layer.shadowOffset = CGSizeMake(1, 1);
    cell.backView.layer.shadowColor = [UIColor grayColor].CGColor;
    cell.backView.layer.shadowOpacity = .5f;
    NSDictionary *dic = dataSource[indexPath.row];
    cell.title.text = [NSString stringWithFormat:@"%@管理制度",dic[@"name"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProjectController * projectVC = [mainSB instantiateViewControllerWithIdentifier:@"ProjectController"];
    projectVC.gid = dataSource[indexPath.row][@"id"];
    projectVC.gname = dataSource[indexPath.row][@"name"];
    [self.navigationController pushViewController:projectVC animated:YES];
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
