//
//  XETabViewController.m
//  DeepBreathing
//
//  Created by rimi on 15/12/15.
//  Copyright © 2015年 肖恩. All rights reserved.
//

#import "XETabViewController.h"
#import "ControllerManager.h"
@interface XETabViewController ()<UITabBarDelegate>
@property (nonatomic, strong)UITabBar *myTabBar;

- (void)initializeApperaance;
@end

//static const NSInteger buttonTag_ = 100;//能用静态全局变量就不用宏定义

enum {
    ButtonTag = 100
    
};

@implementation XETabViewController

#pragma mark --initialize
//自定义加载tab
- (instancetype)initWithViewController:(NSArray *)viewControllers normalStateImages:(NSArray *)normalStateImages selectedStateImages:(NSArray *)selectedStateImages titles:(NSArray *)titles{
    self = [super init];
    if (self) {
        for (int i = 0; i < viewControllers.count; i ++) {
            [self addChildVc:viewControllers[i] title:titles[i] image:normalStateImages[i] selectedImage:selectedStateImages[i] number:i];
        }
//        self.什么 一写就调viewDidLoad，
    }
    return self;
}

- (instancetype)initWithViewController:(NSArray *)viewControllers {
    return [self initWithViewController:viewControllers normalStateImages:nil selectedStateImages:nil titles:nil];
}
#pragma mark --life cycle 生命周期
//第一次访问View调用，是生命周期的第一步（抛开生命周期）
//- (void)loadView {
//    UIScrollView *scrollview;
//    self.view = scrollview;
//    [self viewDidLoad];
//    [super loadView];
//}



//loadView后调用viewDidLoad
- (void)viewDidLoad {
//    [super viewDidLoad];
    [self initializeApperaance];
    
}


#pragma mark --重新父类方法override

#pragma mark --私有方法private methods
- (void)initializeApperaance {
    _myTabBar.delegate = self ;
}

#pragma mark --接口方法interface methods

#pragma mark --回调、事件callback/action


#pragma mark --系统协议方法system protocol

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item;{
    [ControllerManager sharedManager].drawerVC.number = item.tag;
    
}
#pragma mark --自定义协议方法custom protocol
/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage number:(NSInteger)number;
{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.tag = number;
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = XN_COLOR_RED_MINT;
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    nav.navigationBarHidden = YES;
    // 添加为子控制器
    [self addChildViewController:nav];
}
#pragma mark --setter

#pragma mark --getter












@end
