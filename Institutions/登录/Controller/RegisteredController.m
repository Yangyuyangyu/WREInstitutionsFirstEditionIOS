//
//  RegisteredController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/5/31.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "RegisteredController.h"
#import "LoginModel.h"

@interface RegisteredController ()<UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *registTab;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UIImageView *register1;
@property (weak, nonatomic) IBOutlet UIImageView *register2;
//名称
@property (weak, nonatomic) IBOutlet UITextField *name;
//帐号
@property (weak, nonatomic) IBOutlet UITextField *account;

@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *code;

@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *password1;
//验证码
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
//机构
@property (weak, nonatomic) IBOutlet UIButton *institutions;
//学校
@property (weak, nonatomic) IBOutlet UIButton *school;

@property (weak, nonatomic) IBOutlet UIButton *eye1;
@property (weak, nonatomic) IBOutlet UIButton *eye2;
@property (nonatomic, copy)NSString *log_id;
@property (nonatomic, copy)NSString *type;

@property (nonatomic, strong)LoginModel *log;
@end

@implementation RegisteredController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(smsCode:) name:@"smsCodeInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh:) name:@"registerInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _log = [[LoginModel alloc] init];
    
    _registTab.delegate = self;
    _type = @"1";
    
    _codeButton.layer.cornerRadius = 5;
    _codeButton.layer.masksToBounds = YES;
    _codeButton.layer.borderWidth = 1;
    _codeButton.layer.borderColor = XN_COLOR_RED_MINT.CGColor;
    
    _name.delegate = self;
    _name.tag = 9;
    _account.delegate = self;
    _phone.delegate = self;
    _code.delegate = self;
    _password.delegate = self;
    _password.tag = 10;
    _password1.delegate = self;
    _password1.tag = 11;
    _password.secureTextEntry = YES;
    _password1.secureTextEntry = YES;
    
    _register2.hidden = YES;
    _institutions.selected = !_institutions.selected;
}
//刷新用户信息
- (void)smsCode:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        NSNumber *_id = bitice.userInfo[@"log_id"];
        _log_id = _id.description;
    }
}
- (void)refresh:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@(-1)]) {
        [MBProgressHUD showError:@"用户已经存在"];
    }else if ([bitice.userInfo[@"code"] isEqualToNumber:@(-2)]){
        [MBProgressHUD showError:@"验证码错误"];
    }else if ([bitice.userInfo[@"code"] isEqualToNumber:@(-3)]){
        [MBProgressHUD showError:@"注册失败请重新注册"];
    }else if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        [MBProgressHUD showSuccess:@"注册成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//确定
- (IBAction)determine:(UIButton *)sender {
    if (_password.text.length == 0 || _password1.text.length == 0) {
        [MBProgressHUD showError:@"密码不能为空"];
    }else if (_password.text.length < 6 || _password.text.length > 20){
        [MBProgressHUD showError:@"密码必须大于6位小于20位"];
    }else if (![_password1.text isEqualToString:_password.text]){
        [MBProgressHUD showError:@"两次密码不相同"];
    }else if (_code.text.length == 0){
        [MBProgressHUD showError:@"验证码不能为空"];
    }else if (_phone.text.length == 0){
        [MBProgressHUD showError:@"手机号码不能为空"];
    }else if (_name.text.length == 0){
        [MBProgressHUD showError:@"名称不能为空"];
    }else if (_account.text.length == 0){
        [MBProgressHUD showError:@"帐号不能为空"];
    }else if (_log_id.length == 0){
        [MBProgressHUD showError:@"请获取验证码"];
    }else {
        [_log registerInfoList:_account.text name:_name.text mobile:_phone.text pass:_password.text code:_code.text log_id:_log_id type:_type];
    }
}
//机构
- (IBAction)institutions:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = !sender.selected;
        _register1.hidden = NO;
        _register2.hidden = YES;
        _school.selected = !_school.selected;
        _type = @"1";
    }
}
- (IBAction)school:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = !sender.selected;
        _register2.hidden = NO;
        _register1.hidden = YES;
        _institutions.selected = !_institutions.selected;
        _type = @"2";
    }
    
}
- (IBAction)eye:(UIButton *)sender {
    if (sender.tag == 0) {
        if (!_eye1.selected) {
            _password.secureTextEntry = NO;
        }else{
            _password.secureTextEntry = YES;
        }
        _eye1.selected = !_eye1.selected;
    }else{
        if (!_eye2.selected) {
            _password1.secureTextEntry = NO;
        }else{
            _password1.secureTextEntry = YES;
        }
        _eye2.selected = !_eye2.selected;
    }
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)authCode:(UIButton *)sender {
    if ([CManager validateMobile:_phone.text]) {
        [_log smsCodeInfoList:_phone.text];
        __block int timeout = 59;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
                    sender.enabled = YES;
                });
            }else{
                //            int minutes = timeout / 60;
                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:1];
                    sender.titleLabel.font = [UIFont systemFontOfSize:14];
                    [sender setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                    [UIView commitAnimations];
                    sender.enabled = NO;
                    
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
        
        
        sender.enabled = NO;
        
    }else if (_phone.text.length == 0){
        [MBProgressHUD showError:@"手机号码不能为空"];
    }else {
        [MBProgressHUD showError:@"手机号码格式不正确"];
    }

}

#pragma mark--UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 235, 0.0);
    if (textField.tag == 10 || textField.tag == 11 || textField.tag == 9) {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, 265, 0.0);
    }
    
    _registTab.contentInset = contentInsets;
    _registTab.scrollIndicatorInsets = contentInsets;
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    double duration = 0.30f;
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        _registTab.contentInset = contentInsets;
        _registTab.scrollIndicatorInsets = contentInsets;
    }];
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
//回收键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    double duration = 0.30f;
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        _registTab.contentInset = contentInsets;
        _registTab.scrollIndicatorInsets = contentInsets;
    }];
    [self.view endEditing:YES];
}

//点击空白处回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    double duration = 0.30f;
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        _registTab.contentInset = contentInsets;
        _registTab.scrollIndicatorInsets = contentInsets;
    }];
    [self.view endEditing:YES];
}
@end
