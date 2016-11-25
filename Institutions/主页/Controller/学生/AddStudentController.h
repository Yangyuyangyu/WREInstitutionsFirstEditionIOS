//
//  AddStudentController.h
//  Institutions
//
//  Created by waycubeIOSb on 16/6/6.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddStudentController : UIViewController
//判断是否是直接新增
@property (nonatomic, assign) BOOL isDirectly;
//学生id
@property (nonatomic, copy) NSString *studentId;
@end
