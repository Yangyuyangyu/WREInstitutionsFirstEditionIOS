//
//  XEDrawerViewController.h
//  DeepBreathing
//
//  Created by rimi on 15/12/15.
//  Copyright © 2015年 肖恩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XEDrawerViewController : UIViewController
@property (nonatomic, strong,readonly)UIViewController *mainController;
@property (nonatomic, strong,readonly)UIViewController *leftViewConroller;
@property (nonatomic, strong,readonly)UIViewController *rightViewController;

@property (nonatomic, assign)NSInteger number;

@property (nonatomic, strong,readonly)UIScreenEdgePanGestureRecognizer *gestureOfOoenningLeftDrawer;

- (instancetype)initWithMainController:(UIViewController *)mainController
                     leftViewConroller:(UIViewController *)leftViewConroller
                   rightViewController:(UIViewController *)rightViewController;

- (instancetype)initWithMainController:(UIViewController *)mainController leftViewConroller:(UIViewController *)leftViewConroller;

- (void)openLeftDrawer;
- (void)closeLeftDrawer;
- (void)openRigthDrawer;
- (void)closeRigthDrawer;

@end
