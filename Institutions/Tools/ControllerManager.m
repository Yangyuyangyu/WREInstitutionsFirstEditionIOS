
//
//  ControllerManager.m
//  UI_深呼吸
//
//  Created by rimi on 15/12/21.
//  Copyright © 2015年 肖恩. All rights reserved.
//

#import "ControllerManager.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "HomeController.h"
#import "ManagementController.h"
#import "RankingController.h"
@interface ControllerManager ()
@property (nonatomic, strong) XEDrawerViewController *drawerVC;
@property (nonatomic, strong) XETabViewController *tabVC;
@property (nonatomic, strong) UIViewController *rootViewContorller;

@end

@implementation ControllerManager

+ (instancetype)sharedManager {
    static ControllerManager *manager;
    manager = [[ControllerManager alloc] init];
    return manager;
}


- (UIViewController *)rootViewContorller {
    if (!_rootViewContorller) {
        UINavigationController *naNVC = [[UINavigationController alloc] initWithRootViewController:self.drawerVC];
        naNVC.navigationBarHidden = YES;
        _rootViewContorller = naNVC;
    }
    return _rootViewContorller;
}

- (XEDrawerViewController *)drawerVC {
    if (!_drawerVC) {
        UINavigationController *naNVC = [[UINavigationController alloc] initWithRootViewController:self.tabVC];
        naNVC.navigationBarHidden = YES;
        UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LeftViewController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"LeftViewController"];
        _drawerVC = [[XEDrawerViewController alloc] initWithMainController:naNVC leftViewConroller:appendVC];
    }
    return _drawerVC;
}

- (XETabViewController *)tabVC {
    if (!_tabVC) {
        //初始化控制器
        UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HomeController *homeVC = [mainSB instantiateViewControllerWithIdentifier:@"HomeController"];
        ManagementController *manaVC = [[ManagementController alloc] init];
        RankingController *rankVC = [mainSB instantiateViewControllerWithIdentifier:@"RankingController"];
        NSArray *normalImages = @[@"icon_main_home_noselect.png",@"icon_main_manage_normal.png",@"icon_main_ranking_normal.png"];
        NSArray *selectedImages = @[@"icon_main_home_select.png",@"icon_main_manage_select.png",@"icon_main_ranking_select.png"];
        NSArray *viewControllers = @[homeVC, manaVC, rankVC];
        NSArray *titles = @[@"首页",@"管理",@"排名"];
        XETabViewController *tabController = [[XETabViewController alloc] initWithViewController:viewControllers normalStateImages:normalImages selectedStateImages:selectedImages titles:titles];
        _tabVC = tabController;
    }
    return _tabVC;
}
@end
