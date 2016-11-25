//
//  ShowDetailsController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/7.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ShowDetailsController.h"
#import "NavigationView.h"

@interface ShowDetailsController ()
@property (weak, nonatomic) IBOutlet UIView *backView;
//提示
@property (weak, nonatomic) IBOutlet UILabel *prompt;
//卡
@property (weak, nonatomic) IBOutlet UILabel *card;
//金额
@property (weak, nonatomic) IBOutlet UILabel *money;

@end

@implementation ShowDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"提现详情" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    _backView.layer.shadowOffset = CGSizeMake(1, 1);
    _backView.layer.shadowColor = [UIColor blackColor].CGColor;
    _backView.layer.shadowOpacity = .5f;
    _backView.layer.cornerRadius = 5;
}



@end
