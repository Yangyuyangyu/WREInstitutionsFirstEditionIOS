//
//  AddSystemController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/8.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "AddSystemController.h"
#import "NavigationView.h"
#import "CZCover.h"
#import "ManagementModel.h"
#import "HomeModel.h"
#import <UIImageView+WebCache.h>

static NSString *identify = @"CELL";
@interface AddSystemController ()<UITextViewDelegate,UITableViewDelegate, UITableViewDataSource, CZCoverDelegate>{
    NSArray *dataSource;
}
@property (weak, nonatomic) IBOutlet UITextField *name;
//科目
@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (nonatomic, copy) NSString *subjectId;
//课程
@property (weak, nonatomic) IBOutlet UILabel *course;
@property (nonatomic, copy) NSString *courseId;
//器材
@property (weak, nonatomic) IBOutlet UITextField *equipment;
//选择社团按钮
@property (weak, nonatomic) IBOutlet UIButton *community;
//说明
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *label;
//拒绝
@property (weak, nonatomic) IBOutlet UIButton *refused;
//确定
@property (weak, nonatomic) IBOutlet UIButton *determine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;
@property (nonatomic, assign)CGFloat lin;

@property (nonatomic, strong)CZCover *cover;
@property (nonatomic, strong)UITableView *czTabel;

@property (nonatomic, strong) ManagementModel *management;
@property (nonatomic, strong) HomeModel *home;

@property (nonatomic, assign) NSInteger number;
@end

@implementation AddSystemController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(subjectList:) name:@"subjectListInfoList" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addRepair:) name:@"addRepairInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(courses:) name:@"coursesInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(studentOfCourse:) name:@"studentOfCourseInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"乐器维修" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    _refused.layer.borderWidth = 1;
    _refused.layer.borderColor = [UIColor grayColor].CGColor;
    _refused.layer.cornerRadius = 5;
    _refused.layer.masksToBounds = YES;
    
    _determine.layer.borderWidth = 1;
    _determine.layer.borderColor = [UIColor grayColor].CGColor;
    _determine.layer.cornerRadius = 5;
    _determine.layer.masksToBounds = YES;
    
    //设置UITextView提示语
    _label.enabled = NO;//lable必须设置为不可用
    _label.backgroundColor = [UIColor clearColor];
    _contentTextView.delegate = self;
    
    _lin = _line.constant;
    
    _number = 100;
    
    //    让分割线顶头
    if ([self.czTabel respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.czTabel setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.czTabel respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.czTabel setLayoutMargins:UIEdgeInsetsZero];
        
    }
    _management = [[ManagementModel alloc] init];
    _home = [[HomeModel alloc] init];
    
}

//选择社团后查询科目
- (void)subjectList:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        _number = 10;
        // 弹出蒙板
        _cover = [CZCover show];
        _cover.delegate = self;
        [self.view addSubview:_cover];
        [_cover addSubview:self.czTabel];
        dataSource = bitice.userInfo[@"data"];
        [_czTabel reloadData];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
}
//查询课程
- (void)courses:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        _number = 11;
        dataSource = bitice.userInfo[@"data"];
        // 弹出蒙板
        _cover = [CZCover show];
        _cover.delegate = self;
        self.czTabel.frame = CGRectMake(XN_WIDTH - 200, 156, 180, 120);
        [self.view addSubview:_cover];
        [_cover addSubview:self.czTabel];
        [_czTabel reloadData];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
}
//查询课程下的学生
- (void)studentOfCourse:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        _number = 12;
        dataSource = bitice.userInfo[@"data"];
        // 弹出蒙板
        _cover = [CZCover show];
        _cover.delegate = self;
        self.czTabel.frame = CGRectMake(XN_WIDTH - 125, 196, 120, 120);
        [self.view addSubview:_cover];
        [_cover addSubview:self.czTabel];
        [_czTabel reloadData];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
}
//添加维修
- (void)addRepair:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        [self.navigationController popViewControllerAnimated:YES];
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
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_number == 10) {
        _subject.text = dataSource[indexPath.row][@"name"];
        _subjectId = dataSource[indexPath.row][@"id"];
        _courseId = @"";
        _course.text = @"";
        _name.text = @"";
    }else if (_number == 11){
        _course.text = dataSource[indexPath.row][@"name"];
        _courseId = dataSource[indexPath.row][@"id"];
        _name.text = @"";
    }else{
        _name.text = dataSource[indexPath.row][@"name"];
    }
    
    [_cover remove];
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*设置cell 的宽度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
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

#pragma mark--UITextViewDelegate

//开始编辑输入框的时候，软键盘出现，执行此事件
- (void)textViewDidBeginEditing:(UITextView *)textView{
        CGRect frame = textView.frame;
        int offset = frame.origin.y + 130 - (self.view.frame.size.height - 216.0);//键盘高度216
        
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
        if(offset > 0){
            _line.constant = -offset;
        }
        [UIView commitAnimations];

}

//输入框编辑完成以后，将视图恢复到原始状态
- (void)textViewDidEndEditing:(UITextView *)textView{
    double duration = 0.30f;
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        _line.constant = _lin;
    }];
}

-(void)textViewDidChange:(UITextView *)textView
{
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];//当前的输入模式
    if ([lang isEqualToString:@"zh-Hans"])
    {
        _label.text = @"";
        //        如果输入有中文，且没有出现文字备选框就对字数统计和限制
        //        出现了备选框就暂不统计
        UITextRange *range = [textView markedTextRange];
        
        UITextPosition *position = [textView positionFromPosition:range.start offset:0];
        if (!position)
        {
            
            [self checkText:textView];
            
        }
    }
    else
    {
        [self checkText:textView];
    }
}
- (void)checkText:(UITextView *)textView{
    self.contentTextView.text =  textView.text;
    if (textView.text.length == 0) {
        _label.text = @"原因...";
    }else{
        _label.text = @"";
    }
}

//选择按钮
- (IBAction)community:(UIButton *)sender {
    
    [_home subjectListInfoList:_communityId];
}
//课程
- (IBAction)course:(UIButton *)sender {
    if (_subjectId.length == 0) {
        [MBProgressHUD showError:@"请先选择科目"];
    }else{
        [_home coursesInfoList:_subjectId];
    }
}
//报修人
- (IBAction)user_name:(UIButton *)sender {
    if (_courseId.length == 0) {
        [MBProgressHUD showError:@"请先选择课程"];
    }else{
        [_management studentOfCourseInfoList:_courseId];
    }
}

- (IBAction)determine:(UIButton *)sender {
    if (sender.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if (_name.text.length == 0) {
            [MBProgressHUD showError:@"请输入报修人"];
        }else if (_subject.text.length == 0){
            [MBProgressHUD showError:@"请选择报修科目"];
        }else if (_equipment.text.length == 0){
            [MBProgressHUD showError:@"请输入报修器材"];
        }else if (_contentTextView.text.length == 0){
            [MBProgressHUD showError:@"请输入报修说明"];
        }else if (_courseId.length == 0){
            [MBProgressHUD showError:@"请选择报修课程"];
        }else{
            [_management addRepairInfoList:_name.text subject:_subjectId course:_courseId group:_communityId instrument:_equipment.text remark:_contentTextView.text];
        }
    }
}

//点击空白处回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark--getter
- (UITableView *)czTabel{
    if (!_czTabel) {
        _czTabel = [[UITableView alloc]initWithFrame:CGRectMake(XN_WIDTH - 125, 116, 120, 90)];
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
