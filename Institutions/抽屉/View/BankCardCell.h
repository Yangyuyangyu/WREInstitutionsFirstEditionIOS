//
//  BankCardCell.h
//  Institutions
//
//  Created by waycubeIOSb on 16/6/14.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *backPic;
//卡名
@property (weak, nonatomic) IBOutlet UILabel *card;
//类型
@property (weak, nonatomic) IBOutlet UILabel *type;
//卡号
@property (weak, nonatomic) IBOutlet UILabel *number;
@end
