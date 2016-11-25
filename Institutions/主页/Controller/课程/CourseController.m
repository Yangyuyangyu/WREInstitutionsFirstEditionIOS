//
//  CourseController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/5/31.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//  课程

#import "CourseController.h"
#import "NavigationView.h"
#import "CourseCell.h"
#import "CourseDetailsController.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>
#import "HomeModel.h"

static NSString *identify = @"CourseCell";
@interface CourseController ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray *dataSource;
}
@property (nonatomic, strong)UITableView *courseTab;

@property (nonatomic, strong) HomeModel *home;

@end

@implementation CourseController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(myCourse:) name:@"myCourseInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"全部课程" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        ShareS.isOpen = NO;
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:self.courseTab];
    dataSource = [NSArray array];
    _home = [[HomeModel alloc] init];
    
    self.courseTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_home myCourseInfoList];
        });
    }];
    [self.courseTab.mj_header beginRefreshing];
}
#pragma mark --通知方法
- (void)myCourse:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        [self.courseTab reloadData];
    }
    [self.courseTab.mj_header endRefreshing];//结束刷新
}
#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CourseCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic = dataSource[indexPath.row];
    NSString *pic = dic[@"img"];
    [cell.pic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"icon_addteacher_head"]];
    cell.title.text = dic[@"name"];
    cell.content.text = dic[@"brief"];
    cell.teacherName.text = [NSString stringWithFormat:@"老师:%@",dic[@"teacher"]];
    cell.time.text = dic[@"class_time"];
    NSString *type = dic[@"type"];
    if ([type isEqualToString:@"1"]) {
        cell.lesson.text = @"【一对多】";
    }else{
        cell.lesson.text = @"【一对一】";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.hidesBottomBarWhenPushed = YES;
    CourseDetailsController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"CourseDetailsController"];
    appendVC.courseId = dataSource[indexPath.row][@"id"];
    appendVC.courseName = dataSource[indexPath.row][@"name"];
    [self.navigationController pushViewController:appendVC animated:YES];
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*设置cell 的宽度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

//- (void)updateViewConstraints{
//
//    [super updateViewConstraints];
//}
#pragma mark--getter
- (UITableView *)courseTab{
    if (!_courseTab) {
        _courseTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - 64)];
        _courseTab.tableFooterView = [[UIView alloc] init];
        _courseTab.dataSource = self;
        _courseTab.delegate = self;
    }
    return _courseTab;
}
@end
