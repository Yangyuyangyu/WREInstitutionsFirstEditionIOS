//
//  loginController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/5/31.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "loginController.h"
#import "ForgetController.h"
#import "RegisteredController.h"
#import "ControllerManager.h"
#import "LoginModel.h"

@interface loginController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;
@property (nonatomic, assign) CGFloat lin;

@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *password;
//打开网页
@property (weak, nonatomic) IBOutlet UIButton *webPage;

@property (nonatomic, strong)LoginModel *log;
@end

@implementation loginController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginList:) name:@"loginInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _webPage.layer.cornerRadius = 5;
    _webPage.layer.masksToBounds = YES;
    _phone.delegate = self;
    _password.delegate = self;
    _password.tag = 10;
    _lin = _line.constant;
    _password.secureTextEntry = YES;
    
    _log = [[LoginModel alloc] init];
}

- (void)loginList:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        NSUserDefaults *defailts = [NSUserDefaults standardUserDefaults];
        [defailts setObject:bitice.userInfo[@"data"][@"id"] forKey:@"uId"];
        [defailts setObject:bitice.userInfo[@"data"][@"location"] forKey:@"location"];
        [defailts setObject:bitice.userInfo[@"data"][@"brief"] forKey:@"brief"];
        [defailts setObject:bitice.userInfo[@"data"][@"feature"] forKey:@"feature"];
        [UIApplication sharedApplication].keyWindow.rootViewController = [ControllerManager sharedManager].rootViewContorller;
        [MBProgressHUD showSuccess:@"登录成功"];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
}
#pragma mark--UITextFieldDelegate

//开始编辑输入框的时候，软键盘出现，执行此事件
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 45 - (self.view.frame.size.height - 216.0);//键盘高度216
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

#pragma mark--按钮事件

//登录
- (IBAction)login:(UIButton *)sender {
    if (_phone.text.length == 0) {
        [MBProgressHUD showError:@"帐号不能为空"];
    }else if (_password.text.length == 0){
        [MBProgressHUD showError:@"密码不能为空"];
    }else{
        [_log loginInfoList:_phone.text pass:_password.text];
    }
}
//注册
- (IBAction)registered:(UIButton *)sender {
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegisteredController * forgetVC = [mainSB instantiateViewControllerWithIdentifier:@"RegisteredController"];
    [self.navigationController pushViewController:forgetVC animated:YES];
}
//忘记密码
- (IBAction)Forgot:(UIButton *)sender {
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ForgetController * forgetVC = [mainSB instantiateViewControllerWithIdentifier:@"ForgetController"];
    [self.navigationController pushViewController:forgetVC animated:YES];
}
//打开网页版
- (IBAction)webPage:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.weiraoedu.com/Admin/Account/login.html"]];
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
