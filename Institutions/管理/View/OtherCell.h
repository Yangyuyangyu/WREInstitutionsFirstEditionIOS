//
//  OtherCell.h
//  Institutions
//
//  Created by waycubeIOSb on 16/6/1.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherCell : UITableViewCell
//其他
@property (weak, nonatomic) IBOutlet UILabel *rest;

@property (weak, nonatomic) IBOutlet UILabel *tatle;
@property (weak, nonatomic) IBOutlet UILabel *tatle1;

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *time1;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *name1;
//更多
@property (weak, nonatomic) IBOutlet UIButton *more;

@property (weak, nonatomic) IBOutlet UIView *backView;
//维修状态
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *state1;
@end
