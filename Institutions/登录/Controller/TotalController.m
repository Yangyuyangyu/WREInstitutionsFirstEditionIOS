//
//  TotalController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/5/31.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "TotalController.h"
#import "ForgetController.h"
#import "loginController.h"
#import "RegisteredController.h"

@interface TotalController ()
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIButton *regist;

@end

@implementation TotalController

- (void)viewDidLoad {
    [super viewDidLoad];
    _login.layer.cornerRadius = 5;
    _login.layer.masksToBounds = YES;
    _login.layer.borderWidth = 1;
    _login.layer.borderColor = [UIColor whiteColor].CGColor;
    _regist.layer.cornerRadius = 5;
    _regist.layer.masksToBounds = YES;
    _regist.layer.borderWidth = 1;
    _regist.layer.borderColor = [UIColor whiteColor].CGColor;
}
- (IBAction)login:(UIButton *)sender {
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    loginController * forgetVC = [mainSB instantiateViewControllerWithIdentifier:@"loginController"];
    [self.navigationController pushViewController:forgetVC animated:YES];
}
- (IBAction)registered:(UIButton *)sender {
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegisteredController * forgetVC = [mainSB instantiateViewControllerWithIdentifier:@"RegisteredController"];
    [self.navigationController pushViewController:forgetVC animated:YES];
}
- (IBAction)forget:(UIButton *)sender {
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ForgetController * forgetVC = [mainSB instantiateViewControllerWithIdentifier:@"ForgetController"];
    [self.navigationController pushViewController:forgetVC animated:YES];
}



@end
