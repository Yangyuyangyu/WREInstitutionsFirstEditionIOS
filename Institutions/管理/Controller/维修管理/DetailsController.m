//
//  DetailsController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/8.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "DetailsController.h"
#import "NavigationView.h"

@interface DetailsController ()
@property (weak, nonatomic) IBOutlet UILabel *name;
//科目
@property (weak, nonatomic) IBOutlet UILabel *subjects;
//器材
@property (weak, nonatomic) IBOutlet UILabel *equipment;
//说明
@property (weak, nonatomic) IBOutlet UILabel *content;
//课程
@property (weak, nonatomic) IBOutlet UILabel *course;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;
@end

@implementation DetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"乐器维修" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    _name.text = _dic[@"user_name"];
    _subjects.text = _dic[@"subject"];
    _equipment.text = _dic[@"instrument"];
    _content.text = _dic[@"remark"];
    _course.text = _dic[@"course"];
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    
    CGRect rect = [_content.text boundingRectWithSize:CGSizeMake(XN_WIDTH - 30, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    if (rect.size.height > 100) {
        _line.constant = 172 + rect.size.height;
    }
}


@end
