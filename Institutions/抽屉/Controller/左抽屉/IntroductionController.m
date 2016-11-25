//
//  IntroductionController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/14.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "IntroductionController.h"
#import "NavigationView.h"
#import "ManagementModel.h"
#import "DrawerModel.h"

@interface IntroductionController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (nonatomic, assign) BOOL isOk;
@property (nonatomic, assign) CGFloat Y;

@property (nonatomic, strong) ManagementModel *management;
@property (nonatomic, strong) DrawerModel *drawer;

@end

@implementation IntroductionController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(leaveAuth:) name:@"leaveAuthInfoList" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tmpAuth:) name:@"tmpAuthInfoList" object:nil];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(edit:) name:@"editInfoList" object:nil];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reportAuth:) name:@"reportAuthInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *str = @"";
    if (_isAsk == 1) {
        str = @"请假审批";
    }else if (_isAsk == 2){
        str = @"临时帐号审批";
    }else if (_isAsk == 3){
        str = @"上课记录审核";
    }
    else{
        str = @"修改简介";
    }
    
    _management = [[ManagementModel alloc] init];
    _drawer = [[DrawerModel alloc] init];
    
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:str leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
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
    
    _label.enabled = NO;
    if (_isAsk == 1 || _isAsk == 2 || _isAsk == 3) {
        _label.text = @"请说明拒绝的原因...";
    }else{
        _label.text = @"给孩子终身受用的能力...";
    }
    
    _label.backgroundColor = [UIColor clearColor];
    _content.delegate = self;
    
    _isOk = NO;
    _Y = 0;
}
//修改简介
- (void)edit:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        NSUserDefaults *defailts = [NSUserDefaults standardUserDefaults];
        [defailts setObject:_content.text forKey:@"brief"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showError:@"修改简介失败"];
    }
}
//请假审批
- (void)leaveAuth:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
      [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showError:@"请假审批失败"];
    }
}

//临时帐号审批
- (void)tmpAuth:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showError:@"临时帐号审批失败"];
    }
}

//上课记录审核
- (void)reportAuth:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showError:@"上课记录审失败"];
    }
}
#pragma mark--UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.content.text = textView.text;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    
    CGRect rect = [_content.text boundingRectWithSize:CGSizeMake(XN_WIDTH - 16, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    
    CGFloat _editMaxY = CGRectGetMaxY(rect) + 64;
    CGFloat _keyBoardMinY = 216;//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if (_keyBoardMinY < _editMaxY) {
        CGFloat moveDistance = _editMaxY - _keyBoardMinY;
        self.content.transform = CGAffineTransformMakeTranslation(rect.origin.x, -moveDistance);
    }
    
    [UIView commitAnimations];

}
//输入框编辑完成以后，将视图恢复到原始状态
- (void)textViewDidEndEditing:(UITextView *)textView{
    self.content.transform = CGAffineTransformIdentity;
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
    self.content.text =  textView.text;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    
    CGRect rect = [_content.text boundingRectWithSize:CGSizeMake(XN_WIDTH - 16, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    CGFloat Y = CGRectGetMaxY(rect);
    if (Y != _Y) {
        _Y = Y;
        CGFloat _editMaxY = CGRectGetMaxY(rect) + 64;
        CGFloat _keyBoardMinY = XN_HEIGHT - 64 - 218;//键盘高度216
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
        if (_keyBoardMinY < _editMaxY) {
            CGFloat moveDistance = _editMaxY - _keyBoardMinY;
            self.content.transform = CGAffineTransformMakeTranslation(rect.origin.x, -moveDistance);
        }
        if (_keyBoardMinY > _editMaxY) {
            self.content.transform = CGAffineTransformIdentity;
        }
        
        [UIView commitAnimations];
    }
    if (textView.text.length == 0) {
        if (_isAsk == 1 || _isAsk == 2 || _isAsk == 3) {
            _label.text = @"请说明拒绝的原因...";
        }else{
            _label.text = @"给孩子终身受用的能力...";
        }
    }else{
        _label.text = @"";
    }
}

- (void)handleEvent:(UIButton *)sender{
    if (_content.text.length != 0) {
        if (_isAsk == 1) {
            [_management leaveAuthInfoList:_askId result:@"2" refuse:_content.text];
        }else if (_isAsk == 2){
            [_management tmpAuthInfoList:_askId result:@"2" refuse:_content.text];
        }else if (_isAsk == 3){
            [_management reportAuthInfoList:_askId result:@"2" reason:_content.text];
        }
        else{
            [_drawer editInfoList:@"3" content:_content.text];
        }
    }else{
        [MBProgressHUD showError:@"内容不能为空"];
    }
    
    
    
}

//点击空白处回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.content.transform = CGAffineTransformIdentity;
    [self.view endEditing:YES];
}
@end
