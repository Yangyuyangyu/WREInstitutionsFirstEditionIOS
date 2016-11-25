//
//  AfterDetailController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/8.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "AfterDetailController.h"
#import "NavigationView.h"

#import "ManagementModel.h"

@interface AfterDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *studentName;
@property (weak, nonatomic) IBOutlet UILabel *teacherName;
//部门
@property (weak, nonatomic) IBOutlet UILabel *department;
//追访内容
@property (weak, nonatomic) IBOutlet UITextView *content;
//反馈情况
@property (weak, nonatomic) IBOutlet UITextView *feedback;
//解决办法
@property (weak, nonatomic) IBOutlet UITextView *wayTo;
//原因
@property (weak, nonatomic) IBOutlet UITextView *way;
//解决
@property (weak, nonatomic) IBOutlet UILabel *solve;

@property (nonatomic, strong) ManagementModel *management;
@end

@implementation AfterDetailController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(followIn:) name:@"followInfoInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"电话追访" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    _content.editable = NO;
    _feedback.editable = NO;
    _wayTo.editable = NO;
    _way.editable = NO;
    
    _management = [[ManagementModel alloc] init];
    
    [_management followInfoInfoList:_dataId];
    
}

- (void)followIn:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        NSDictionary *dic = bitice.userInfo[@"data"];
        _studentName.text = dic[@"student"];
        _teacherName.text = dic[@"teacher"];
        _department.text = dic[@"group_name"];
        _content.text = dic[@"content"];
        _feedback.text = dic[@"feedback"];
        _wayTo.text = dic[@"solution"];
        _way.text = dic[@"reason"];
        NSString *str = dic[@"is_solved"];
        if ([str isEqualToString:@"1"]) {
            _solve.text = @"已解决";
        }else{
            _solve.text = @"未解决";
        }
    }else{
        
    }
}


@end
