//
//  AskCell.h
//  Institutions
//
//  Created by waycubeIOSb on 16/6/1.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AskCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *typo;
@property (weak, nonatomic) IBOutlet UILabel *content;
//审批状态
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;
//课程文本
@property (weak, nonatomic) IBOutlet UILabel *course;
@end
