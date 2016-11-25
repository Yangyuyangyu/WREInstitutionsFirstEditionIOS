//
//  TeacherDetailsController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/21.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "TeacherDetailsController.h"
#import <UIImageView+WebCache.h>

#import "HomeModel.h"

@interface TeacherDetailsController ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITableView *detailTab;

@property (weak, nonatomic) IBOutlet UIImageView *backPIc;
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *name;
//电话号码
@property (weak, nonatomic) IBOutlet UILabel *phone;
//出生日期
@property (weak, nonatomic) IBOutlet UILabel *dateOf;
//地址
@property (weak, nonatomic) IBOutlet UILabel *address;
//简介
@property (weak, nonatomic) IBOutlet UILabel *summary;
//毕业院校
@property (weak, nonatomic) IBOutlet UILabel *graduation;
//成果分享
@property (weak, nonatomic) IBOutlet UILabel *res_share;

@property (nonatomic, strong) HomeModel *home;
@end

@implementation TeacherDetailsController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(teacher:) name:@"teacherInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _home = [[HomeModel alloc] init];
    [_home teacherInfoList:_teacherId];
}
- (void)teacher:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        NSDictionary *dic = bitice.userInfo[@"data"][@"info"];
        [_headPic sd_setImageWithURL:[NSURL URLWithString:dic[@"head"]] placeholderImage:[UIImage imageNamed:@"default_load_img.png"]];
        _name.text = dic[@"name"];
        _phone.text = [NSString stringWithFormat:@"手机号码:%@",dic[@"phone"]];
        _dateOf.text = [NSString stringWithFormat:@"出生日期:%@",dic[@"birthday"]];
        _address.text = [NSString stringWithFormat:@"家庭地址:%@",dic[@"address"]];
        _summary.text = [NSString stringWithFormat:@"简介:%@",dic[@"summary"]];
        _graduation.text = [NSString stringWithFormat:@"毕业院校:%@",dic[@"edu_exp"]];
        _res_share.text = [NSString stringWithFormat:@"最近分享:%@",dic[@"res_share"]];
    }
}
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)phon:(UIButton *)sender {
}

@end
