//
//  ForgetController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/5/31.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ForgetController.h"
#import "LoginModel.h"

@interface ForgetController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;
@property (nonatomic, assign)CGFloat lin;

@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;

@property (weak, nonatomic) IBOutlet UIButton *eye;
@property (nonatomic, copy) NSString *log_id;

@property (nonatomic, strong)LoginModel *log;
@end

@implementation ForgetController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(smsCode:) name:@"smsCodeInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editPwd:) name:@"editPwdInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _codeButton.layer.cornerRadius = 5;
    _codeButton.layer.masksToBounds = YES;
    _codeButton.layer.borderWidth = 1;
    _codeButton.layer.borderColor = XN_COLOR_RED_MINT.CGColor;
    _password.delegate = self;
    _password.tag = 10;
    _code.delegate = self;
    _phone.delegate = self;
    _log = [[LoginModel alloc] init];
    _lin = _line.constant;
}
//刷新用户信息
- (void)smsCode:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        NSNumber *_id = bitice.userInfo[@"log_id"];
        _log_id = _id.description;
    }
}
- (void)editPwd:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        [MBProgressHUD showSuccess:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark--UITextFieldDelegate

//开始编辑输入框的时候，软键盘出现，执行此事件
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 40 - (self.view.frame.size.height - 216.0);//键盘高度216
    if (textField.tag == 10) {
        offset += 25;
    }
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
- (void)textFieldDidEndEditing:(UITextField *)textField{
    double duration = 0.30f;
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        _line.constant = _lin;
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

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)determine:(UIButton *)sender {
    if (_password.text.length == 0) {
        [MBProgressHUD showSuccess:@"密码不能为空"];
    }else if (_password.text.length < 6 || _password.text.length > 20){
        [MBProgressHUD showSuccess:@"密码必须大于6位小于20位"];
    }else if (_code.text.length == 0){
        [MBProgressHUD showSuccess:@"验证码不能为空"];
    }else if (_phone.text.length == 0){
        [MBProgressHUD showSuccess:@"手机号码不能为空"];
    }else if (_log_id.length == 0){
        [MBProgressHUD showSuccess:@"请获取验证码"];
    }else{
        [_log editPwdInfoList:_phone.text pass:_password.text code:_code.text log_id:_log_id];
    }
}
- (IBAction)code:(UIButton *)sender {
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

//点击空白处回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    double duration = 0.30f;
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        _line.constant = _lin;
    }];
    [self.view endEditing:YES];
}
@end
