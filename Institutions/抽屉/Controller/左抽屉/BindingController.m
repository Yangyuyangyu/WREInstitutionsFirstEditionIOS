//
//  BindingController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/14.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "BindingController.h"
#import "NavigationView.h"
#import "DrawerModel.h"

@interface BindingController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;

@property (weak, nonatomic) IBOutlet UITextField *card;

@property (weak, nonatomic) IBOutlet UITextField *type;

@property (nonatomic, strong) DrawerModel *drawerl;
@end

@implementation BindingController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addCard:) name:@"addCardInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"添加银行卡" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(XN_WIDTH - 60, 30, 50, 30);
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:@"绑定" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    _drawerl = [[DrawerModel alloc] init];
    _card.delegate = self;
}

//添加银行卡
- (void)addCard:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showError:@"获取消息失败"];
    }
}

- (void)handleEvent:(UIButton *)sender{
    NSString *str = [_card.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (_name.text.length == 0) {
        [MBProgressHUD showError:@"持卡人姓名不能为空"];
    }else if (![CManager validateBankCardNumber:str]){
        [MBProgressHUD showError:@"卡号不正确"];
    }else if (_type.text.length == 0){
        [MBProgressHUD showError:@"卡的类型不能为空"];
    }else{
        [_drawerl addCardInfoList:_name.text cardNo:str type:_type.text];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField) {
        NSString* text = textField.text;
        //删除
        if([string isEqualToString:@""]){
            
            //删除一位
            if(range.length == 1){
                //最后一位,遇到空格则多删除一次
                if (range.location == text.length-1 ) {
                    if ([text characterAtIndex:text.length-1] == ' ') {
                        [textField deleteBackward];
                    }
                    return YES;
                }
                //从中间删除
                else{
                    NSInteger offset = range.location;
                    
                    if (range.location < text.length && [text characterAtIndex:range.location] == ' ' && [textField.selectedTextRange isEmpty]) {
                        [textField deleteBackward];
                        offset --;
                    }
                    [textField deleteBackward];
                    textField.text = [self parseString:textField.text];
                    UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                    textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                    return NO;
                }
            }
            else if (range.length > 1) {
                BOOL isLast = NO;
                //如果是从最后一位开始
                if(range.location + range.length == textField.text.length ){
                    isLast = YES;
                }
                [textField deleteBackward];
                textField.text = [self parseString:textField.text];
                
                NSInteger offset = range.location;
                if (range.location == 3 || range.location  == 8) {
                    offset ++;
                }
                if (isLast) {
                    //光标直接在最后一位了
                }else{
                    UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                    textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                }
                
                return NO;
            }
            
            else{
                return YES;
            }
        }
        
        else if(string.length >0){
            
            //限制输入字符个数
            if (([self noneSpaseString:textField.text].length + string.length - range.length > 19) ) {
                return NO;
            }
            //判断是否是纯数字(千杀的搜狗，百度输入法，数字键盘居然可以输入其他字符)
            //            if(![string isNum]){
            //                return NO;
            //            }
            [textField insertText:string];
            textField.text = [self parseString:textField.text];
            
            NSInteger offset = range.location + string.length;
            if (range.location == 4 || range.location  == 9 || range.location  == 14 || range.location  == 19) {
                offset ++;
            }
            UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
            textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
            return NO;
        }else{
            return YES;
        }
        
    }
    
    return YES;
}

- (NSString*)noneSpaseString:(NSString*)string
{
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString*)parseString:(NSString*)string
{
    if (!string) {
        return nil;
    }
    NSMutableString* mStr = [NSMutableString stringWithString:[string stringByReplacingOccurrencesOfString:@" " withString:@""]];
    if (mStr.length >4) {
        [mStr insertString:@" " atIndex:4];
    }if (mStr.length > 9) {
        [mStr insertString:@" " atIndex:9];
        
    }if (mStr.length > 14) {
        [mStr insertString:@" " atIndex:14];
        
    }if (mStr.length > 19) {
        [mStr insertString:@" " atIndex:19];
        
    }
    
    return  mStr;
}

//点击空白处回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
