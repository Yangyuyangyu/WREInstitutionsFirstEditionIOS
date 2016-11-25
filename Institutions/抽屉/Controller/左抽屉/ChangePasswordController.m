//
//  ChangePasswordController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/5.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ChangePasswordController.h"
#import "NavigationView.h"
#import "DrawerModel.h"

@interface ChangePasswordController ()
@property (weak, nonatomic) IBOutlet UITextField *oldTextfield;

@property (weak, nonatomic) IBOutlet UITextField *newlyTextfield;
@property (weak, nonatomic) IBOutlet UIButton *eyeButton;

@property (weak, nonatomic) IBOutlet UIButton *eyesButton;

@property (nonatomic, strong) DrawerModel *drawer;


@end

@implementation ChangePasswordController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editPass:) name:@"editPassInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"修改密码" leftButtonImage:[UIImage imageNamed:@"back-left.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    _oldTextfield.secureTextEntry = YES;
    _newlyTextfield.secureTextEntry = YES;
    _oldTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
    _newlyTextfield.autocorrectionType = UITextAutocorrectionTypeNo;

    _drawer = [[DrawerModel alloc] init];
}

- (void)editPass:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        [MBProgressHUD showSuccess:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
}
//可见不可见
- (IBAction)eye:(UIButton *)sender {
    if (sender.tag == 0) {
        if (sender.selected) {
            _oldTextfield.secureTextEntry = YES;
        }else{
            _oldTextfield.secureTextEntry = NO;
        }
        _eyeButton.selected = !_eyeButton.selected;
    }else{
        if (sender.selected) {
            _newlyTextfield.secureTextEntry = YES;
        }else{
            _newlyTextfield.secureTextEntry = NO;
        }
        _eyesButton.selected = !_eyesButton.selected;
    }
    
}

//确定
- (IBAction)confirm:(UIButton *)sender {
    if (_oldTextfield.text.length == 0) {
        [MBProgressHUD showError:@"旧密码不能为空"];
    }else if (_newlyTextfield.text.length == 0){
        [MBProgressHUD showError:@"新密码不能为空"];
    }else if (![CManager validatePassword:_newlyTextfield.text]){
        [MBProgressHUD showError:@"密码必须大于6位小于20位必须由数字和字母组成"];
    }else{
        [_drawer editPassInfoList:_oldTextfield.text newPass:_newlyTextfield.text];
    }
}

@end
