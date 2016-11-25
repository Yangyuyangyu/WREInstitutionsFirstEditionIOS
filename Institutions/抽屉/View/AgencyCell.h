//
//  AgencyCell.h
//  Institutions
//
//  Created by waycubeIOSb on 16/6/13.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTags.h"

@interface AgencyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;

@property (weak, nonatomic) IBOutlet UILabel *titel;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (nonatomic, strong) CCTags *tags;
@end
