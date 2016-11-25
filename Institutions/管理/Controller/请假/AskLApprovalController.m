//
//  AskLApprovalController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/1.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "AskLApprovalController.h"
#import "NavigationView.h"
#import "AskCell.h"
#import "ExaminationController.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>

#import "ManagementModel.h"

static NSString *identify = @"AskCell";
@interface AskLApprovalController ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray *studentArray;
    NSArray *teacherArray;
    NSArray *dataSource;
}
@property (weak, nonatomic) IBOutlet UIButton *teacher;
@property (weak, nonatomic) IBOutlet UIButton *student;
@property (weak, nonatomic) IBOutlet UITableView *AskTab;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, assign) BOOL isTeacher;

@property (nonatomic, strong) ManagementModel *management;
@end

@implementation AskLApprovalController
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
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"请假审批" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        ShareS.isOpen = NO;
        [self.navigationController popViewControllerAnimated:YES];
    };
    _AskTab.dataSource = self;
    _AskTab.delegate = self;
    _AskTab.tableFooterView = [[UIView alloc] init];
    _backView.layer.cornerRadius = 5;
    _backView.layer.masksToBounds = YES;
    _backView.layer.borderWidth = 1;
    _backView.layer.borderColor = XN_COLOR_RED_MINT.CGColor;
    _teacher.selected = !_teacher.selected;
    
    _management = [[ManagementModel alloc] init];
    dataSource = [NSArray array];
    _isTeacher = YES;
    
    _AskTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
            [_management manageInfoList:@"3" typeId:uid];
        });
    }];
    [self.AskTab.mj_header beginRefreshing];
}

- (void)manage:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        studentArray = bitice.userInfo[@"data"][@"student"];
        teacherArray = bitice.userInfo[@"data"][@"teacher"];
        NSLog(@"老师数据%@,学生数据%@",teacherArray,studentArray);
        if (_isTeacher == YES) {
            dataSource = teacherArray;
        }else{
            dataSource = studentArray;
        }
        [_AskTab reloadData];
    }
    [_AskTab.mj_header endRefreshing];//结束刷新
}
#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AskCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AskCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic = dataSource[indexPath.row];
    NSString *pic = dic[@"img"];
    cell.pic.layer.cornerRadius = 25;
    cell.pic.layer.masksToBounds = YES;
    [cell.pic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"icon_addteacher_head.png"]];
    cell.name.text = dic[@"name"];
    cell.typo.text = dic[@"reason"];
    cell.content.text = dic[@"course"];
    if (_isTeacher == NO) {
        cell.course.hidden = YES;
        cell.line.constant = 10;
    }
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
    appendVC.isAsk = YES;
    appendVC.status = dataSource[indexPath.row][@"status"];
    appendVC.askId = dataSource[indexPath.row][@"id"];
    [self.navigationController pushViewController:appendVC animated:YES];
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (IBAction)content:(UIButton *)sender {
    if (sender.tag == 0) {
        if (!_teacher.selected) {
            _teacher.selected = !_teacher.selected;
            _student.selected = !_student.selected;
            _isTeacher = YES;
        }
    }else{
        if (!_student.selected) {
            _teacher.selected = !_teacher.selected;
            _student.selected = !_student.selected;
            _isTeacher = NO;
        }
    }
    if (_isTeacher == YES) {
        dataSource = teacherArray;
    }else{
        dataSource = studentArray;
    }
    [_AskTab reloadData];
}



@end
