//
//  WithdrawalController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/6.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "WithdrawalController.h"
#import "NavigationView.h"
#import "CardController.h"
#import "ShowDetailsController.h"

@interface WithdrawalController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *card;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextFielde;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *allMoney;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, assign)BOOL isHaveDian;

@end

@implementation WithdrawalController

- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"提现" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    _backView.layer.shadowOffset = CGSizeMake(1, 1);
    _backView.layer.shadowColor = [UIColor blackColor].CGColor;
    _backView.layer.shadowOpacity = .5f;
    _backView.layer.cornerRadius = 5;
    _moneyTextFielde.delegate = self;
}

//控制只能输入小数点后2位
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        _isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            //首字母不能为0和小数点
            if([textField.text length] == 0){
                if(single == '.') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                if (single == '0') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!_isHaveDian)//text中还没有小数点
                {
                    _isHaveDian = YES;
                    return YES;
                    
                }else{
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (_isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}


//卡
- (IBAction)card:(UIButton *)sender {
    CardController *cardVC = [[CardController alloc] init];
    [self.navigationController pushViewController:cardVC animated:YES];
}
//全部
- (IBAction)all:(UIButton *)sender {
}
//提现
- (IBAction)submit:(UIButton *)sender {
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShowDetailsController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"ShowDetailsController"];
    [self.navigationController pushViewController:appendVC animated:YES];
}

//点击空白处回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
