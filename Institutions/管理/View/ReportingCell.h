//
//  ReportingCell.h
//  Institutions
//
//  Created by waycubeIOSb on 16/6/12.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *tickPic;
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UIImageView *backPic;

@property (weak, nonatomic) IBOutlet UILabel *titel;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *timer;
@end
