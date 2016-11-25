//
//  AddStudentController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/6.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "AddStudentController.h"
#import "NavigationView.h"
#import "HomeModel.h"
#import "CZCover.h"

@interface AddStudentController ()<UITableViewDelegate, UITableViewDataSource, CZCoverDelegate, UITextFieldDelegate>{
    NSDictionary *dataSourceDic;
    NSArray *czArray;
}
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIButton *eyes;
//社团
@property (weak, nonatomic) IBOutlet UIButton *community;
@property (nonatomic, strong) NSString *communityId;
//科目
@property (weak, nonatomic) IBOutlet UIButton *subjects;
@property (nonatomic, strong) NSString *subjectsId;

@property (weak, nonatomic) IBOutlet UIView *subjectsView;

@property (nonatomic, strong)HomeModel *home;

@property (nonatomic, strong)CZCover *cover;
@property (nonatomic, strong)UITableView *czTabel;

@property (nonatomic, assign) BOOL isSubject;
@property (nonatomic, assign) BOOL isCommunity;

@end

@implementation AddStudentController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(studentSelected:) name:@"studentSelectedInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getGroups:) name:@"getGroupsInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(subjectList:) name:@"subjectListInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addStudent:) name:@"addStudentInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"新增学生" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(XN_WIDTH - 60, 30, 50, 30);
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    _home = [[HomeModel alloc] init];
    _password.secureTextEntry = YES;
    _password.autocorrectionType = UITextAutocorrectionTypeNo;
    _subjectsView.hidden = YES;
    _phone.delegate = self;
    
    if (_isDirectly != YES) {
        [_home studentSelectedInfoList:_studentId];
    }
}

- (void)studentSelected:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSourceDic = bitice.userInfo[@"data"];
        _name.text = dataSourceDic[@"name"];
        _phone.text = dataSourceDic[@"phone"];
        _password.text = @"******";
        _eyes.hidden = YES;
        _name.enabled = NO;
        _password.enabled = NO;
        _phone.enabled = NO;
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }

}
- (void)getGroups:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        czArray = bitice.userInfo[@"data"];
        [_czTabel reloadData];
        // 弹出蒙板
        _cover = [CZCover show];
        _cover.delegate = self;
        [self.view addSubview:_cover];
        [_cover addSubview:self.czTabel];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
    
}

- (void)subjectList:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        czArray = bitice.userInfo[@"data"];
        [_czTabel reloadData];
        // 弹出蒙板
        _cover = [CZCover show];
        _cover.delegate = self;
        [self.view addSubview:_cover];
        [_cover addSubview:self.czTabel];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
    
}

- (void)addStudent:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
    
}
#pragma mark--UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return czArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString *identify = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.text = czArray[indexPath.row][@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isCommunity == YES) {
        [_community setTitle:czArray[indexPath.row][@"name"] forState:UIControlStateNormal];
        [_subjects setTitle:@"" forState:UIControlStateNormal];
        _communityId = czArray[indexPath.row][@"id"];
        _subjectsView.hidden = NO;
    }else{
        [_subjects setTitle:czArray[indexPath.row][@"name"] forState:UIControlStateNormal];
        _subjectsId = czArray[indexPath.row][@"id"];
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
//科目
- (IBAction)subjects:(UIButton *)sender {
    _isCommunity = NO;
    [_home subjectListInfoList:_communityId];
}

//选择社团
- (IBAction)community:(UIButton *)sender {
    _isCommunity = YES;
    [_home getGroupsInfoList];
    
}
- (IBAction)eyes:(UIButton *)sender {
    if (_eyes.selected) {
        _password.secureTextEntry = YES;
        _eyes.selected = !_eyes.selected;
    }else{
        _password.secureTextEntry = NO;
        _eyes.selected = !_eyes.selected;
    }
}

- (void)handleEvent:(UIButton *)sender{
    if (_name.text.length == 0) {
        [MBProgressHUD showError:@"姓名不能为空"];
    }else if (_phone.text.length == 0){
        [MBProgressHUD showError:@"电话不能为空"];
    }else if (![CManager validateMobile:_phone.text]){
        [MBProgressHUD showError:@"电话号码不正确"];
    }else if (_password.text.length < 6 || _password.text.length > 20){
         [MBProgressHUD showError:@"密码必须大于6位小于20位"];
    }else if (_communityId.length == 0){
        [MBProgressHUD showError:@"请选择社团"];
    }else if (_subjectsId.length == 0){
        [MBProgressHUD showError:@"请选择科目"];
    }else{
        if (_email.text.length == 0) {
            _email.text = @"";
        }
        if (_isDirectly == YES) {
            [_home addStudentInfoList:_communityId sid:_studentId subject:_subjectsId name:_name.text mobile:_phone.text pass:_password.text email:_email.text];
        }else{
            [_home addStudentInfoList:_communityId sid:_studentId subject:_subjectsId name:_name.text mobile:_phone.text pass:dataSourceDic[@"pwd"] email:_email.text];
        }
        
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

//点击空白处回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark--getter

- (UITableView *)czTabel{
    if (!_czTabel) {
        _czTabel = [[UITableView alloc]initWithFrame:CGRectMake(0, XN_HEIGHT - 90, XN_WIDTH, 90)];
        _czTabel.tableFooterView = [[UIView alloc] init];
        _czTabel.dataSource = self;
        _czTabel.delegate = self;
        _czTabel.tag = 100;
    }
    return _czTabel;
}
@end
