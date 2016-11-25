//
//  AddPhoneToController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/8.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "AddPhoneToController.h"
#import "NavigationView.h"
#import "CZCover.h"
#import "ManagementModel.h"
#import "HomeModel.h"

static NSString *identify = @"CELL";
@interface AddPhoneToController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, CZCoverDelegate>{
    NSArray *dataSource;
}
@property (weak, nonatomic) IBOutlet UITextField *studentName;
@property (weak, nonatomic) IBOutlet UITextField *teacherName;
//部门按钮
@property (weak, nonatomic) IBOutlet UIButton *department;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
//追访内容
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UILabel *label1;
//反馈
@property (weak, nonatomic) IBOutlet UITextView *feedback;
@property (weak, nonatomic) IBOutlet UILabel *label2;
//解决办法
@property (weak, nonatomic) IBOutlet UITextView *wayTo;
@property (weak, nonatomic) IBOutlet UILabel *label3;
//原因
@property (weak, nonatomic) IBOutlet UITextView *why;
@property (weak, nonatomic) IBOutlet UILabel *label4;
//是按钮
@property (weak, nonatomic) IBOutlet UIButton *isSolve;
@property (weak, nonatomic) IBOutlet UIButton *noSolve;
//拒绝
@property (weak, nonatomic) IBOutlet UIButton *refused;
@property (weak, nonatomic) IBOutlet UIButton *through;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;
@property (nonatomic, assign)CGFloat lin;

@property (nonatomic, strong)UITableView *czTabel;

@property (nonatomic, strong)CZCover *cover;
@property (nonatomic, strong) ManagementModel *management;
@property (nonatomic, strong) HomeModel *home;
//社团id
@property (nonatomic, copy) NSString *institutionsId;

@property (nonatomic, assign) BOOL isYES;
@end

@implementation AddPhoneToController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addFollow:) name:@"addFollowInfoList" object:nil];
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
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"电话追访" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    _refused.layer.borderWidth = 1;
    _refused.layer.borderColor = [UIColor grayColor].CGColor;
    _refused.layer.cornerRadius = 5;
    _refused.layer.masksToBounds = YES;
    
    _through.layer.borderWidth = 1;
    _through.layer.borderColor = [UIColor grayColor].CGColor;
    _through.layer.cornerRadius = 5;
    _through.layer.masksToBounds = YES;
    
    //设置UITextView提示语
    _label1.enabled = NO;//lable必须设置为不可用
    _label1.backgroundColor = [UIColor clearColor];
    _label2.enabled = NO;//lable必须设置为不可用
    _label2.backgroundColor = [UIColor clearColor];
    _label3.enabled = NO;//lable必须设置为不可用
    _label3.backgroundColor = [UIColor clearColor];
    _label4.enabled = NO;//lable必须设置为不可用
    _label4.backgroundColor = [UIColor clearColor];
    _content.delegate = self;
    _feedback.delegate = self;
    _wayTo.delegate = self;
    _why.delegate = self;
    
    _isSolve.selected = !_isSolve.selected;
    _lin = _line.constant;
    _isYES = YES;
    
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

- (void)addFollow:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        [MBProgressHUD showSuccess:@"添加成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
}

- (void)getGroups:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        // 弹出蒙板
        _cover = [CZCover show];
        _cover.delegate = self;
        [self.view addSubview:_cover];
        [_cover addSubview:self.czTabel];
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
    cell.textLabel.text = dataSource[indexPath.row][@"name"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _departmentLabel.text = dataSource[indexPath.row][@"name"];
    _institutionsId = dataSource[indexPath.row][@"id"];
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
    int offset = frame.origin.y + 250 - (self.view.frame.size.height - 216.0);//键盘高度216
    
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
        switch (textView.tag) {
            case 10:
                _label1.text = @"";
                break;
            case 11:
                _label2.text = @"";
                break;
            case 12:
                _label3.text = @"";
                break;
            case 13:
                _label4.text = @"";
                break;
            default:
                break;
        }
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
    switch (textView.tag) {
        case 10:
            self.content.text =  textView.text;
            break;
        case 11:
            self.feedback.text =  textView.text;
            break;
        case 12:
            self.wayTo.text =  textView.text;
            break;
        case 13:
            self.why.text =  textView.text;
            break;
        default:
            break;
    }
    if (textView.text.length == 0) {
        switch (textView.tag) {
            case 10:
                _label1.text = @"说点什么吧...";
                break;
            case 11:
                _label2.text = @"说点什么吧...";
                break;
            case 12:
                _label3.text = @"说点什么吧...";
                break;
            case 13:
                _label4.text = @"说点什么吧...";
                break;
            default:
                break;
        }
    }else{
        switch (textView.tag) {
            case 10:
                _label1.text = @"";
                break;
            case 11:
                _label2.text = @"";
                break;
            case 12:
                _label3.text = @"";
                break;
            case 13:
                _label4.text = @"";
                break;
            default:
                break;
        }
    }
}
//选择按钮
- (IBAction)department:(UIButton *)sender {
    [self.view endEditing:YES];
    [_home getGroupsInfoList];
    
}

//是否按钮
- (IBAction)solve:(UIButton *)sender {
    if (sender.tag == 1) {
        if (_isSolve.selected) {
            _isSolve.selected = !_isSolve.selected;
            _noSolve.selected = !_noSolve.selected;
            _isYES = NO;
        }
    }else{
        if (_noSolve.selected) {
            _isSolve.selected = !_isSolve.selected;
            _noSolve.selected = !_noSolve.selected;
            _isYES = YES;
        }
    }
}

//拒绝或通过按钮
- (IBAction)through:(UIButton *)sender {
    if (sender.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSString *str = @"";
        if (_isYES == YES) {
            str = @"1";
        }else{
            str = @"2";
        }
        if (_studentName.text.length == 0) {
            [MBProgressHUD showError:@"请填写学生姓名"];
        }else if (_teacherName.text.length == 0){
            [MBProgressHUD showError:@"请填写指导老师姓名"];
        }else if (_institutionsId.length == 0){
            [MBProgressHUD showError:@"请选择社团"];
        }else if (_content.text.length == 0){
            [MBProgressHUD showError:@"请填写追访内容"];
        }else if (_feedback.text.length == 0){
            [MBProgressHUD showError:@"请填写反馈情况"];
        }else if (_wayTo.text.length == 0){
            [MBProgressHUD showError:@"请填写解决办法"];
        }else if (_why.text.length == 0){
            [MBProgressHUD showError:@"请填写原因"];
        }else{
            [_management addFollowInfoList:_studentName.text teacher:_teacherName.text groupId:_institutionsId content:_content.text feedback:_feedback.text solution:_wayTo.text reason:_why.text solved:str];
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
        _czTabel = [[UITableView alloc]initWithFrame:CGRectMake(XN_WIDTH - 115, 171, 100, 90)];
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
