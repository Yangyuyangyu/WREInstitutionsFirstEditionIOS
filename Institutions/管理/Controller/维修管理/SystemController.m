//
//  SystemController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/8.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "SystemController.h"
#import "NavigationView.h"
#import "OtherCell.h"
#import "DetailsController.h"
#import "AddSystemController.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>
#import "ManagementModel.h"
#import "CZCover.h"
#import "HomeModel.h"

static NSString *identify = @"OtherCell";
@interface SystemController ()<UITableViewDelegate ,UITableViewDataSource,CZCoverDelegate>{
    NSArray *dataSource;
    NSArray *dataArray;
}
//@property (nonatomic, strong)UITableView *systemTab;
@property (weak, nonatomic) IBOutlet UITableView *systemTab;

@property (nonatomic, strong) ManagementModel *management;
@property (nonatomic, strong) HomeModel *home;

@property (weak, nonatomic) IBOutlet UIView *bankView;
@property (weak, nonatomic) IBOutlet UITextField *start_date;
@property (weak, nonatomic) IBOutlet UITextField *end_date;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (nonatomic, copy) NSString *subjectId;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (nonatomic, copy) NSString *courseId;
@property (weak, nonatomic) IBOutlet UITextField *user_name;
@property (nonatomic, strong)CZCover *cover;

@property (nonatomic, strong)UIDatePicker *datepickView;
@property (nonatomic, strong)UITableView *czTabel;

@property (nonatomic, assign) BOOL isSubject;
@end

@implementation SystemController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(manage:) name:@"manageInfoList" object:nil];
    [self.systemTab.mj_header beginRefreshing];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(subjectList:) name:@"subjectListInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(courses:) name:@"coursesInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(manageInfo:) name:@"manageInfoListMore" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"维修管理" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"] rightButtonImage:[UIImage imageNamed:@"icon_add.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    navigationView.rightButtonAction = ^(){
        UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AddSystemController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"AddSystemController"];
        appendVC.communityId = _communityId;
        [self.navigationController pushViewController:appendVC animated:YES];
    };
    _systemTab.dataSource = self;
    _systemTab.delegate = self;
    _systemTab.separatorStyle = NO;
    [self.view addSubview:self.systemTab];
    
    _home = [[HomeModel alloc] init];
    _management = [[ManagementModel alloc] init];
    
    _systemTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_management manageInfoList:@"5" typeId:_communityId];
            _start_date.text = @"";
            _end_date.text = @"";
            _user_name.text = @"";
            _courseId = @"";
            _subjectId = @"";
            _courseLabel.text = @"课程:";
            _subjectLabel.text = @"科目:";
        });
    }];
    
    //    让分割线顶头
    if ([self.czTabel respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.czTabel setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.czTabel respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.czTabel setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    _start_date.text = @"";
    _end_date.text = @"";
    _user_name.text = @"";
    _courseId = @"";
    _subjectId = @"";
    
}

//搜索机构下的社团
- (void)manageInfo:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        [_systemTab reloadData];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
}
//机构下的社团
- (void)manage:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        [_systemTab reloadData];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
    [_systemTab.mj_header endRefreshing];//结束刷新
}
//查询科目
- (void)subjectList:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataArray = bitice.userInfo[@"data"];
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

//查询课程
- (void)courses:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataArray = bitice.userInfo[@"data"];
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        NSDictionary *dic = dataArray[indexPath.row];
        cell.textLabel.text = dic[@"name"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        OtherCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"OtherCell" owner:self options:nil]lastObject];
        }
        NSDictionary *dic = [self deleteAllNullValue:dataSource[indexPath.row]];
        cell.backView.layer.shadowOffset = CGSizeMake(1, 1);
        cell.backView.layer.shadowColor = [UIColor grayColor].CGColor;
        cell.backView.layer.shadowOpacity = .5f;
        cell.backView.layer.cornerRadius = 2;
        cell.rest.textColor = [UIColor blackColor];
        cell.rest.text = dic[@"time"];
        cell.tatle1.text = @"报修人:";
        cell.tatle.text = dic[@"user_name"];
        cell.name1.text = @"器材:";
        cell.name.text = dic[@"instrument"];
        cell.time1.text = @"科目:";
        cell.time.text = dic[@"subject"];
        cell.state.text = @"课程:";
        cell.state1.text = dic[@"course"];
        cell.more.tag = indexPath.row;
        [cell.more addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        if (_isSubject == YES) {
             _subjectLabel.text = dataArray[indexPath.row][@"name"];
            _subjectId = dataArray[indexPath.row][@"id"];
            _courseId = @"";
            _courseLabel.text = @"课程:";
        }else{
            _courseLabel.text = dataArray[indexPath.row][@"name"];
            _courseId = dataArray[indexPath.row][@"id"];
        }
    }
    [_cover remove];
}
/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100) {
        return 30;
    }else{
        return 211;
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
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailsController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"DetailsController"];
    appendVC.dic = [self deleteAllNullValue:dataSource[sender.tag]];
    [self.navigationController pushViewController:appendVC animated:YES];
}

- (IBAction)start_date:(UIButton *)sender {
    [self masking:sender.tag];
}
- (IBAction)end_date:(UIButton *)sender {
    [self masking:sender.tag];
}
- (IBAction)subject_id:(UIButton *)sender {
    [_home subjectListInfoList:_communityId];
}
- (IBAction)course_id:(UIButton *)sender {
    if (_subjectId.length != 0) {
        [_home coursesInfoList:_subjectId];
    }else{
        [MBProgressHUD showError:@"请先选择科目"];
    }
}
- (IBAction)determine:(UIButton *)sender {
    [self.view endEditing:YES];
    if (_start_date.text.length != 0 && _end_date.text.length != 0) {
        int c = 10;
        c = [self compareDate:_start_date.text withDate:_end_date.text];
        if (c == 1) {
            [_management manageInfoListMore:_communityId start_date:_start_date.text end_date:_end_date.text subject_id:_subjectId course_id:_courseId user:_user_name.text];
        }else{
            [MBProgressHUD showError:@"结束时间必须大于开始时间"];
        }
    }else{
        [_management manageInfoListMore:_communityId start_date:_start_date.text end_date:_end_date.text subject_id:_subjectId course_id:_courseId user:_user_name.text];
    }
}

- (void)confirm:(UIButton *)sender{
    NSDate *textmydate = [self.datepickView date];
    NSDateFormatter *dateformate = [[NSDateFormatter alloc] init];
    [dateformate setDateFormat:@"yyyy-MM-dd"];
    NSString *showdate =[dateformate stringFromDate:textmydate];
    if (sender.tag == 0) {
        _start_date.text = showdate;
    }else{
        _end_date.text = showdate;
    }
    [_cover remove];
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

#pragma mark--getter
- (UITableView *)czTabel{
    if (!_czTabel) {
        _czTabel = [[UITableView alloc]initWithFrame:CGRectMake(20, 135, 120, 120)];
        _czTabel.tableFooterView = [[UIView alloc] init];
        _czTabel.dataSource = self;
        _czTabel.delegate = self;
        _czTabel.layer.cornerRadius = 5;
        _czTabel.layer.masksToBounds = YES;
        _czTabel.layer.borderWidth = 1;
        _czTabel.layer.borderColor = XN_COLOR_RED_MINT.CGColor;
        _czTabel.tag = 100;
    }
    return _czTabel;
}
@end
