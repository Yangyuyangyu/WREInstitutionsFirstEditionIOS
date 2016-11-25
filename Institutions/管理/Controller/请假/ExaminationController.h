//
//  ExaminationController.h
//  Institutions
//
//  Created by waycubeIOSb on 16/6/7.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExaminationController : UIViewController
//判断是请假审批还是临时帐号审批
@property (nonatomic, assign)BOOL isAsk;
//判断是否已审核
@property (nonatomic, copy) NSString *status;
//请假记录id
@property (nonatomic, copy) NSString *askId;
@end
