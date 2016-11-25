//
//  ProjectController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/7/7.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ProjectController.h"
#import "NavigationView.h"
#import "ManagementModel.h"

@interface ProjectController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *content;

@property (nonatomic, copy)NSString *html;
@property (nonatomic, strong) ManagementModel *magagement;
@end

@implementation ProjectController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(manage:) name:@"manageInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *str = [NSString stringWithFormat:@"%@管理制度",_gname];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:str leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    _content.delegate = self;
    _content.layer.cornerRadius = 10;
    _content.layer.masksToBounds = YES;
    
    _magagement = [[ManagementModel alloc] init];
    [_magagement manageInfoList:@"11" typeId:_gid];
    
}
- (void)manage:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        _html = bitice.userInfo[@"data"][@"detail"];
        [_content loadHTMLString:_html baseURL:nil];
    }
}

@end
