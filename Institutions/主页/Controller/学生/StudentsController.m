//
//  StudentsController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/5/31.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//  学生

#import "StudentsController.h"
#import "NavigationView.h"
#import "StudentCell.h"
#import "CZCover.h"
#import "ExistingController.h"
#import "AddStudentController.h"
#import "HomeModel.h"
#import "StudentDetailController.h"

#import <MJRefresh.h>
#import <UIImageView+WebCache.h>

static NSString *identify = @"StudentCell";
@interface StudentsController ()<UITableViewDelegate, UITableViewDataSource, CZCoverDelegate, UITextFieldDelegate>{
    NSArray *czArray;
    NSArray *dataSource;
}

@property (weak, nonatomic) IBOutlet UITableView *studentTab;
@property (nonatomic, strong)CZCover *cover;
@property (nonatomic, strong)UITableView *czTabel;
//注册时间
@property (weak, nonatomic) IBOutlet UITextField *time1;
@property (weak, nonatomic) IBOutlet UITextField *time2;
@property (nonatomic, copy) NSString *time;
//姓名
@property (weak, nonatomic) IBOutlet UITextField *name;
//电话
@property (weak, nonatomic) IBOutlet UITextField *phone;
//科目
@property (weak, nonatomic) IBOutlet UILabel *subjects;
@property (nonatomic, copy) NSString *subjectId;
//课程
@property (weak, nonatomic) IBOutlet UILabel *course;
@property (nonatomic, copy) NSString *courseId;

@property (nonatomic, strong) HomeModel *home;
@property (nonatomic, strong)UIDatePicker *datepickView;

@property (nonatomic, assign) BOOL isgroup;
@property (nonatomic, assign) BOOL isSubject;
@end

@implementation StudentsController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(myStudent:) name:@"myStudentInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(courses:) name:@"coursesInfoList" object:nil];
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
    __weak typeof(self) weakSelf = self;
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"全部学生" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"] rightButtonImage:[UIImage imageNamed:@"icon_add.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        ShareS.isOpen = NO;
        [self.navigationController popViewControllerAnimated:YES];
    };
    navigationView.rightButtonAction = ^(){
        _isgroup = NO;
        czArray = @[@"选择已有",@"直接新增"];
        weakSelf.czTabel.frame = CGRectMake(XN_WIDTH - 120, 64, 100, 60);
        // 弹出蒙板
        weakSelf.cover = [CZCover show];
        weakSelf.cover.delegate = weakSelf;
        [weakSelf.view addSubview:_cover];
        [weakSelf.cover addSubview:weakSelf.czTabel];
        [weakSelf.czTabel reloadData];
    };
    _isgroup = NO;
    _home = [[HomeModel alloc] init];
    
    _studentTab.dataSource = self;
    _studentTab.delegate = self;
    _studentTab.tableFooterView = [[UIView alloc] init];
    //    让分割线顶头
    if ([self.czTabel respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.czTabel setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.czTabel respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.czTabel setLayoutMargins:UIEdgeInsetsZero];
        
    }
    _time1.text = @"";
    _time2.text = @"";
    _name.text = @"";
    _phone.text = @"";
    _courseId = @"";
    _subjectId = @"";
    _phone.delegate = self;
    _studentTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _time1.text = @"";
            _time2.text = @"";
            _name.text = @"";
            _phone.text = @"";
            _courseId = @"";
            _subjectId = @"";
            _course.text = @"课程:";
            _subjects.text = @"科目:";
            [_home myStudentInfoList];
        });
    }];
    [self.studentTab.mj_header beginRefreshing];
}

- (void)myStudent:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        [_studentTab reloadData];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
    [_studentTab.mj_header endRefreshing];//结束刷新
}
//查询课程
- (void)courses:(NSNotification *)bitice{
    _isgroup = YES;
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        czArray = bitice.userInfo[@"data"];
        _isSubject = NO;
        // 弹出蒙板
        _cover = [CZCover show];
        _cover.delegate = self;
        self.czTabel.frame = CGRectMake(XN_WIDTH - 200, 135, 180, 120);
        [self.view addSubview:_cover];
        [_cover addSubview:self.czTabel];
        [_czTabel reloadData];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
}
//查询科目
- (void)mySubject:(NSNotification *)bitice{
    _isgroup = YES;
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        czArray = bitice.userInfo[@"data"];
        _isSubject = YES;
        // 弹出蒙板
        _cover = [CZCover show];
        _cover.delegate = self;
        self.czTabel.frame = CGRectMake(20, 135, 120, 120);
        [self.view addSubview:_cover];
        [_cover addSubview:self.czTabel];
        [_czTabel reloadData];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
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
        if (_isgroup == NO) {
            cell.textLabel.text = czArray[indexPath.row];
        }else{
            cell.textLabel.text = czArray[indexPath.row][@"name"];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }else{
        StudentCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"StudentCell" owner:self options:nil]lastObject];
        }
        NSDictionary *dic = dataSource[indexPath.row];
        cell.pic.layer.cornerRadius = 25;
        cell.pic.layer.masksToBounds = YES;
        [cell.pic sd_setImageWithURL:dic[@"head"] placeholderImage:[UIImage imageNamed:@"icon_addteacher_head.png"]];
        cell.studentName.text = dic[@"name"];
        cell.phone.tag = indexPath.row;
        [cell.phone addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
        cell.content.text = dic[@"group_name"];
        cell.age.text = dic[@"age"];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        if (_isgroup == NO) {
            if (indexPath.row == 0) {
                self.hidesBottomBarWhenPushed = YES;
                UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ExistingController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"ExistingController"];
                appendVC.isTeacher = NO;
                [self.navigationController pushViewController:appendVC animated:YES];
            }else{
                self.hidesBottomBarWhenPushed = YES;
                UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                AddStudentController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"AddStudentController"];
                appendVC.isDirectly = YES;
                [self.navigationController pushViewController:appendVC animated:YES];
            }
        }else{
            
            if (_isSubject == YES) {
                _subjects.text = czArray[indexPath.row][@"name"];
                _subjectId = czArray[indexPath.row][@"id"];
                _courseId = @"";
                _course.text = @"课程:";
            }else{
                _course.text = czArray[indexPath.row][@"name"];
                _courseId = czArray[indexPath.row][@"id"];
            }
            [_cover remove];
        }
    }else{
        self.hidesBottomBarWhenPushed = YES;
        UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        StudentDetailController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"StudentDetailController"];
        appendVC.studentId = dataSource[indexPath.row][@"id"];
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
//限制输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phone) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }
    
    return YES;
}
#pragma mark--按钮点击
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
//选择时间
- (IBAction)time1:(UIButton *)sender {
    [self masking:sender.tag];
}
- (IBAction)time2:(UIButton *)sender {
    [self masking:sender.tag];
}
//课程
- (IBAction)course:(UIButton *)sender {
    if (_subjectId.length != 0) {
        [_home coursesInfoList:_subjectId];
    }else{
        [MBProgressHUD showError:@"请先选择科目"];
    }
    
}
//选择科目
- (IBAction)subjects:(UIButton *)sender {
    [_home mySubjectInfoList];
}
//查询
- (IBAction)query:(UIButton *)sender {
    [self.view endEditing:YES];
    if (_time1.text.length != 0 && _time2.text.length != 0) {
        int c = 10;
        c = [self compareDate:_time1.text withDate:_time2.text];
        if (c == 1) {
            [_home myStudentInfoList:_subjectId course_id:_courseId start_time:_time1.text end_time:_time2.text name:_name.text mobile:_phone.text];
        }else{
            [MBProgressHUD showError:@"结束时间必须大于开始时间"];
        }
    }else{
        [_home myStudentInfoList:_subjectId course_id:_courseId start_time:_time1.text end_time:_time2.text name:_name.text mobile:_phone.text];
    }
}

- (void)confirm:(UIButton *)sender{
    NSDate *textmydate = [self.datepickView date];
    NSDateFormatter *dateformate = [[NSDateFormatter alloc] init];
    [dateformate setDateFormat:@"yyyy-MM-dd"];
    NSString *showdate =[dateformate stringFromDate:textmydate];
    if (sender.tag == 0) {
        _time1.text = showdate;
    }else{
        _time2.text = showdate;
    }
    [_cover remove];
}
- (int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=0; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}

- (void)masking:(NSInteger)number{
    [self.view endEditing:YES];
    // 弹出蒙板
    _cover = [CZCover show];
    _cover.delegate = self;
    [self.view addSubview:_cover];
    // 弹出pop菜单
    CGFloat popW = XN_WIDTH - 20;
    CGFloat popX = 10;
    CGFloat popH = XN_HEIGHT/3;
    CGFloat popY = XN_HEIGHT/3;
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(popX, popY, popW, popH)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
    [_cover addSubview:view];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, CGRectGetMaxY(self.datepickView.frame)+3, XN_WIDTH - 30, 35);
    button.backgroundColor = XN_COLOR_RED_MINT;
    button.layer.cornerRadius = 5;
    button.tag = number;
    button.layer.masksToBounds = YES;
    [button setTintColor:[UIColor whiteColor]];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.datepickView];
    [view addSubview:button];
}
//点击空白处回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark--getter
- (UIDatePicker *)datepickView{
    if (!_datepickView) {
        CGFloat popW = XN_WIDTH - 20;
        CGFloat popH = XN_HEIGHT/3 - 45;
        _datepickView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, popW, popH)];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
        _datepickView.locale = locale;
        _datepickView.datePickerMode = UIDatePickerModeDate;
        //        _datepickView.minuteInterval = 5;
    }
    return _datepickView;
}
- (UITableView *)czTabel{
    if (!_czTabel) {
        _czTabel = [[UITableView alloc]initWithFrame:CGRectMake(XN_WIDTH - 120, 64, 100, 60)];
        _czTabel.tableFooterView = [[UIView alloc] init];
        _czTabel.dataSource = self;
        _czTabel.delegate = self;
        _czTabel.tag = 100;
        _czTabel.layer.cornerRadius = 5;
        _czTabel.layer.masksToBounds = YES;
        _czTabel.layer.borderWidth = 1;
        _czTabel.layer.borderColor = XN_COLOR_RED_MINT.CGColor;
    }
    return _czTabel;
}
@end
