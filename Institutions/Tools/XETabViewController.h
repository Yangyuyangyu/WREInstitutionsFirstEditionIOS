//
//  XETabViewController.h
//  DeepBreathing
//
//  Created by rimi on 15/12/15.
//  Copyright © 2015年 肖恩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XETabViewController : UITabBarController
@property (nonatomic, assign)NSUInteger *number;

//designate中的参数写成属性

//designate
- (instancetype)initWithViewController:(NSArray *)viewControllers normalStateImages:(NSArray *)normalStateImages selectedStateImages:(NSArray *)selectedStateImages titles:(NSArray *)titles;

//secondary
- (instancetype)initWithViewController:(NSArray *)viewControllers;
@end
