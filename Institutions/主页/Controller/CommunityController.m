//
//  CommunityController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/5/31.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//  社团

#import "CommunityController.h"
#import "NavigationView.h"
#import "communtityCell.h"
#import "SubjectsController.h"
#import "CZCover.h"
#import "CommCell.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>

#import "HomeModel.h"

static NSString *identify = @"communtityCell";
static NSString *identify1 = @"CommCell";
@interface CommunityController ()<UITableViewDelegate, UITableViewDataSource, CZCoverDelegate>{
    NSArray *dataSource;
    NSArray *dataArray;
}
@property (nonatomic, strong)UITableView *communityTab;
@property (nonatomic, strong)CZCover *cover;
@property (nonatomic, strong)UITableView *czTabel;

@property (nonatomic, strong) HomeModel *home;

@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger adminNumber;
@end

@implementation CommunityController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getGroups:) name:@"getGroupsInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(myAdmin:) name:@"myAdminInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(saveAdmin:) name:@"saveAdminInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"社团" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        ShareS.isOpen = NO;
        [self.navigationController popViewControllerAnimated:YES];
    };
    _home = [[HomeModel alloc] init];
    dataSource = [NSArray array];
    dataArray= [NSArray array];
    _number = -1;
    
    [self.view addSubview:self.communityTab];
    //    让分割线顶头
    if ([self.czTabel respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.czTabel setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.czTabel respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.czTabel setLayoutMargins:UIEdgeInsetsZero];
        
    }
    _communityTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_home getGroupsInfoList];
        });
    }];
    [self.communityTab.mj_header beginRefreshing];
}

- (void)getGroups:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        [_communityTab reloadData];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
    [_communityTab.mj_header endRefreshing];//结束刷新
}

- (void)myAdmin:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataArray = bitice.userInfo[@"data"];
        [_czTabel reloadData];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
}

- (void)saveAdmin:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        [self.communityTab.mj_header beginRefreshing];
        [_cover remove];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
}
#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        return dataArray.count;
    }else{
        return dataSource.count;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        CommCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CommCell" owner:self options:nil]lastObject];
        }
        NSDictionary *dic = dataArray[indexPath.row];
        cell.name.text = dic[@"name"];
        return cell;
    }else{
        communtityCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"communtityCell" owner:self options:nil]lastObject];
        }
        NSDictionary *dic = dataSource[indexPath.row];
        cell.amend.layer.borderWidth = 1;
        cell.amend.layer.borderColor = XN_COLOR_RED_MINT.CGColor;
        cell.amend.layer.cornerRadius = 5;
        cell.amend.layer.masksToBounds = YES;
        cell.amend.tag = indexPath.row;
        [cell.amend addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
        [cell.check addTarget:self action:@selector(handleEventCh:) forControlEvents:UIControlEventTouchUpInside];
        cell.check.tag = indexPath.row;
        [cell.pic sd_setImageWithURL:dic[@"img"]placeholderImage:[UIImage imageNamed:@"default_load_img.png"]];
        cell.title.text = dic[@"name"];
        cell.subject.text = [NSString stringWithFormat:@"%@个科目",dic[@"subjectNum"]];
        cell.name.text = [NSString stringWithFormat:@"管理员:%@",dic[@"admins"]];
        cell.content.text = dic[@"brief"];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        NSArray *array = [tableView visibleCells];
        for (UITableViewCell *cell in array) {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.textLabel.textColor=[UIColor blackColor];
        }
        UITableViewCell *cell=[self.czTabel cellForRowAtIndexPath:indexPath];
        _number = indexPath.row;
        cell.textLabel.textColor=[UIColor blueColor];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*设置cell 的宽度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100) {
        return 40;
    }else{
        return 110;
    }
}
//让分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}
#pragma mark--按钮点击
- (void)handleEvent:(UIButton *)sender{
    _adminNumber = sender.tag;
    [_home myAdminInfoList];
    // 弹出蒙板
    _cover = [CZCover show];
    _cover.delegate = self;
    [self.view addSubview:_cover];
    [_cover addSubview:self.czTabel];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_czTabel.frame), XN_WIDTH, 40)];
    for (int i = 0; i < 2; i ++) {
        if (i == 0) {
            [self draw:@"取消" cgrect:CGRectMake(15, 5, XN_WIDTH / 2 - 30, 30) view:view number:i];
        }else{
            [self draw:@"确定" cgrect:CGRectMake(XN_WIDTH / 2 + 15, 5, XN_WIDTH / 2 - 30, 30) view:view number:i];
        }
    }
    [_cover addSubview:view];
}

- (void)draw:(NSString *)title cgrect:(CGRect)cgrect view:(UIView *)view number:(NSInteger)number{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"white.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = cgrect;
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.tag = number;
    [view addSubview:button];
}


- (void)cancel:(UIButton *)sender{
    if (sender.tag == 0) {
        [_cover remove];
    }else{
        if (_number == (-1)) {
            [MBProgressHUD showError:@"请选择你要更改的管理员"];
        }else{
            [_home saveAdminInfoList:dataSource[_adminNumber][@"id"] adminId:dataArray[_number][@"id"]];
        }
    }
}

- (void)handleEventCh:(UIButton *)sender{
    self.hidesBottomBarWhenPushed = YES;
    SubjectsController *teaVc = [[SubjectsController alloc] init];
    teaVc.communityId = dataSource[sender.tag][@"id"];
    teaVc.isInstitutions = NO;
    [self.navigationController pushViewController:teaVc animated:YES];
}
#pragma mark--getter
- (UITableView *)communityTab{
    if (!_communityTab) {
        _communityTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - 64)];
        _communityTab.tableFooterView = [[UIView alloc] init];
        _communityTab.dataSource = self;
        _communityTab.delegate = self;
    }
    return _communityTab;
}
- (UITableView *)czTabel{
    if (!_czTabel) {
        _czTabel = [[UITableView alloc]initWithFrame:CGRectMake(0, XN_HEIGHT - 120, XN_WIDTH, 80)];
        _czTabel.tableFooterView = [[UIView alloc] init];
        _czTabel.dataSource = self;
        _czTabel.delegate = self;
        _czTabel.tag = 100;
    }
    return _czTabel;
}
@end
