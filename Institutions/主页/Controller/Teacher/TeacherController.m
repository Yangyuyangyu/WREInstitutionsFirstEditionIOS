//
//  TeacherController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/5/31.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//  老师

#import "TeacherController.h"
#import "TeacherCell.h"
#import "NavigationView.h"
#import "CZCover.h"
#import "ExistingController.h"
#import "AddTeacherController.h"
#import "TeacherDetailsController.h"

#import <MJRefresh.h>
#import <UIImageView+WebCache.h>

#import "HomeModel.h"

static NSString *identify = @"TeacherCell";
@interface TeacherController ()<UITableViewDelegate, UITableViewDataSource,CZCoverDelegate>{
    NSArray *czArray;
    NSArray *dataSource;
}
@property (nonatomic, strong)UITableView *teacherTab;
@property (nonatomic, strong)CZCover *cover;
@property (nonatomic, strong)UITableView *czTabel;

@property (nonatomic, strong) HomeModel *home;
@end

@implementation TeacherController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(myTeacher:) name:@"myTeacherInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof(self) weakSelf = self;
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"全部老师" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"] rightButtonImage:[UIImage imageNamed:@"icon_add.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        ShareS.isOpen = NO;
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    navigationView.rightButtonAction = ^(){
        // 弹出蒙板
        _cover = [CZCover show];
        _cover.delegate = weakSelf;
        [weakSelf.view addSubview:_cover];
        [_cover addSubview:weakSelf.czTabel];
    };
    
    [self.view addSubview:self.teacherTab];
    _home = [[HomeModel alloc] init];
    
    dataSource = [NSArray array];
    czArray = @[@"选择已有",@"直接新增"];
    //    让分割线顶头
    if ([self.czTabel respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.czTabel setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.czTabel respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.czTabel setLayoutMargins:UIEdgeInsetsZero];
        
    }
    _teacherTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_home myTeacherInfoList];
        });
    }];
    [self.teacherTab.mj_header beginRefreshing];
}

- (void)myTeacher:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        [_teacherTab reloadData];
    }
    [_teacherTab.mj_header endRefreshing];//结束刷新
}
#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        return czArray.count;
    }else{
        return dataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        static NSString *identify = @"CELL";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        cell.textLabel.text = czArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }else{
        TeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TeacherCell" owner:self options:nil]lastObject];
        }
        NSDictionary *dic = dataSource[indexPath.row];
        cell.pic.layer.cornerRadius = 25;
        cell.pic.layer.masksToBounds = YES;
        [cell.pic sd_setImageWithURL:dic[@"head"] placeholderImage:[UIImage imageNamed:@"default_load_img.png"]];
        cell.titel.text = dic[@"name"];
        cell.content.text = [NSString stringWithFormat:@"授课:%@",dic[@"courseNum"]];
        cell.phone.tag = indexPath.row;
        [cell.phone addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        if (indexPath.row == 0) {
            self.hidesBottomBarWhenPushed = YES;
            UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ExistingController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"ExistingController"];
            appendVC.isTeacher = YES;
            [self.navigationController pushViewController:appendVC animated:YES];
        }else{
            self.hidesBottomBarWhenPushed = YES;
            UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            AddTeacherController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"AddTeacherController"];
            [self.navigationController pushViewController:appendVC animated:YES];
        }
    }else{
        self.hidesBottomBarWhenPushed = YES;
        UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TeacherDetailsController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"TeacherDetailsController"];
        appendVC.teacherId = dataSource[indexPath.row][@"id"];
        [self.navigationController pushViewController:appendVC animated:YES];
    }
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*设置cell 的宽度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100) {
        return 30;
    }else{
        return 75;
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

- (void)handleEvent:(UIButton *)sender{
    NSString *phone = dataSource[sender.tag][@"phone"];
    if (phone.length != 0) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }else{
        [MBProgressHUD showError:@"电话号码为空"];
    }
}

#pragma mark--getter
- (UITableView *)teacherTab{
    if (!_teacherTab) {
        _teacherTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - 64)];
        _teacherTab.tableFooterView = [[UIView alloc] init];
        _teacherTab.dataSource = self;
        _teacherTab.delegate = self;
    }
    return _teacherTab;
}

- (UITableView *)czTabel{
    if (!_czTabel) {
        _czTabel = [[UITableView alloc]initWithFrame:CGRectMake(XN_WIDTH - 120, 64, 100, 60)];
        _czTabel.tableFooterView = [[UIView alloc] init];
        _czTabel.dataSource = self;
        _czTabel.delegate = self;
        _czTabel.scrollEnabled = NO;
        _czTabel.tag = 100;
        _czTabel.layer.cornerRadius = 5;
        _czTabel.layer.masksToBounds = YES;
        _czTabel.layer.borderWidth = 1;
        _czTabel.layer.borderColor = XN_COLOR_RED_MINT.CGColor;
    }
    return _czTabel;
}
@end
