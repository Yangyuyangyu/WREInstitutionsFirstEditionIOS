//
//  GradeCell.h
//  Institutions
//
//  Created by waycubeIOSb on 16/6/8.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *content;
//打勾
@property (weak, nonatomic) IBOutlet UIButton *tick;
@end
