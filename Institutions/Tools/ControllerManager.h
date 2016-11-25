//
//  ControllerManager.h
//  UI_深呼吸
//
//  Created by rimi on 15/12/21.
//  Copyright © 2015年 肖恩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XEDrawerViewController.h"
#import "XETabViewController.h"
@interface ControllerManager : NSObject

@property (nonatomic, strong, readonly) XEDrawerViewController *drawerVC;
@property (nonatomic, strong, readonly) XETabViewController *tabVC;
@property (nonatomic, strong, readonly) UIViewController *rootViewContorller;

+ (instancetype)sharedManager;
@end
