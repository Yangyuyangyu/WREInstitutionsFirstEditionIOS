//
//  StudentDetailCell.h
//  Institutions
//
//  Created by waycubeIOSb on 16/6/23.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;

@property (weak, nonatomic) IBOutlet UILabel *tetle;
@property (weak, nonatomic) IBOutlet UILabel *admin;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *number;
@end
