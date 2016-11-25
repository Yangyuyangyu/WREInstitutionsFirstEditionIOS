//
//  IntroductionController.h
//  Institutions
//
//  Created by waycubeIOSb on 16/6/14.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface IntroductionController : UIViewController

//判断是否是请假页
@property (nonatomic, assign) int isAsk;
//请假记录id
@property (nonatomic, copy) NSString *askId;
@end
