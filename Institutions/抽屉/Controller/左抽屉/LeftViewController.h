//
//  LeftViewController.h
//  DeepBreathing
//
//  Created by rimi on 15/12/15.
//  Copyright © 2015年 肖恩. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^PhonNumberBlock) (id info);
typedef void (^HomeBlock) (id info);
@interface LeftViewController : UIViewController
@property (nonatomic, copy) PhonNumberBlock phonNumberBlok;
@property (nonatomic, copy) HomeBlock homeBlock;
@end
