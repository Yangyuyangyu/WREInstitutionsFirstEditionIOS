//
//  SubjectsController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/5/31.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "SubjectsController.h"
#import "NavigationView.h"
#import "SubjectsCell.h"
#import "HomeModel.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>

static NSString *identify = @"SubjectsCell";
@interface SubjectsController ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray *dataSource;
}
@property (nonatomic, strong)UITableView *subjectsTab;

@property (nonatomic, strong) HomeModel *home;
@end

@implementation SubjectsController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(subjectOfGroup:) name:@"subjectOfGroupInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mySubject:) name:@"mySubjectInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"科目" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        ShareS.isOpen = NO;
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:self.subjectsTab];
    
    _home = [[HomeModel alloc] init];
    
    _subjectsTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_isInstitutions == YES) {
                [_home mySubjectInfoList];
            }else{
                [_home subjectOfGroupInfoList:_communityId];
            }
        });
    }];
    [self.subjectsTab.mj_header beginRefreshing];
    
}

- (void)subjectOfGroup:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        [_subjectsTab reloadData];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
    [_subjectsTab.mj_header endRefreshing];//结束刷新
}
- (void)mySubject:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        [_subjectsTab reloadData];
    }
    [_subjectsTab.mj_header endRefreshing];//结束刷新
}
#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SubjectsCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SubjectsCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic = dataSource[indexPath.row];
    [cell.pic sd_setImageWithURL:dic[@"img"] placeholderImage:[UIImage imageNamed:@"default_load_img.png"]];
    cell.title1.text = dic[@"name"];
    cell.title.text = [NSString stringWithFormat:@"管理员:%@",dic[@"admin"]];
    cell.name.text = dic[@"group"];
    cell.content.text = dic[@"brief"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*设置cell 的宽度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
#pragma mark--getter
- (UITableView *)subjectsTab{
    if (!_subjectsTab) {
        _subjectsTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - 64)];
        _subjectsTab.tableFooterView = [[UIView alloc] init];
        _subjectsTab.dataSource = self;
        _subjectsTab.delegate = self;
    }
    return _subjectsTab;
}

@end
