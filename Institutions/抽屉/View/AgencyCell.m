//
//  AgencyCell.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/13.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "AgencyCell.h"

@implementation AgencyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setTags:(CCTags *)tags
{
    _tags = tags;
    for (int i = 0; i < tags.tagsArray.count; i ++) {
        UILabel *tagsLb = [[UILabel alloc] init];
        tagsLb.text = tags.tagsArray[i];
        tagsLb.font = TagsTitleFont;
        tagsLb.textAlignment = NSTextAlignmentCenter;
        tagsLb.textColor = XN_COLOR_RED_MINT;
        tagsLb.backgroundColor = [UIColor whiteColor];
        tagsLb.layer.borderWidth = 1;
        tagsLb.layer.borderColor = [UIColor lightGrayColor].CGColor;
        tagsLb.layer.cornerRadius = 15;
        tagsLb.layer.masksToBounds = YES;
        tagsLb.frame = CGRectFromString(tags.tagsFrames[i]);
        [self.contentView addSubview:tagsLb];
        
    }
}

@end
