//
//  HomeController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/5/27.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "HomeController.h"
#import "TeacherController.h"
#import "CourseController.h"
#import "StudentsController.h"
#import "ConstructionController.h"
#import "CommunityController.h"
#import "SubjectsController.h"
#import "ReportingAuditController.h"
#import "AskLApprovalController.h"
#import "PhoneToController.h"
#import "ControllerManager.h"

#import "MoneyController.h"
#import "CurriculumController.h"

#import "HomeModel.h"
#import "DrawerModel.h"
#import <UIImageView+WebCache.h>


@interface HomeController ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *homeTab;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *pic;
//老师数
@property (weak, nonatomic) IBOutlet UILabel *number1;
@property (weak, nonatomic) IBOutlet UILabel *teacher;
//学生数
@property (weak, nonatomic) IBOutlet UILabel *number2;
//课程
@property (weak, nonatomic) IBOutlet UILabel *course;

@property (nonatomic, strong) HomeModel *home;
@property (nonatomic, strong) DrawerModel *drawer;

@property (weak, nonatomic) IBOutlet UIImageView *headerImg;

@end

@implementation HomeController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(count:) name:@"countInfoList" object:nil];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(info:) name:@"infoInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    _homeTab.contentSize = CGSizeMake(64, _backView.bounds.size.height / 2 + 35);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _homeTab.tableHeaderView = _backView;
    _homeTab.delegate = self;
    _home = [[HomeModel alloc] init];
    _drawer = [[DrawerModel alloc] init];
    
    [_drawer infoInfoList];
    [_home countInfoList];
}
//获取首页图标
- (void)info:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        NSString *pic = bitice.userInfo[@"data"][@"img"];
        [_headerImg sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"default_load_img.png"]];
        _headerImg.layer.cornerRadius = 15;
        _headerImg.layer.masksToBounds = YES;
    }
}
//统计老师课程数
- (void)count:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        _number1.text = bitice.userInfo[@"data"][@"teacherNum"];
        if ([bitice.userInfo[@"data"][@"courseNum"] isKindOfClass:[NSNull class]]) {
            _number2.text = @"0";
        }else{
            _number2.text = bitice.userInfo[@"data"][@"courseNum"];
        }
    }
}
//打开左抽屉
- (IBAction)header:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openLeftDrawerInfoList" object:nil userInfo:nil];
}
//网页登录
- (IBAction)webPage:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.weiraoedu.com/Admin/Account/login.html"]];
}
- (IBAction)content:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    ShareS.isOpen = YES;
    switch (sender.tag) {
        case 0:
        {
            UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            StudentsController * teaVc = [mainSB instantiateViewControllerWithIdentifier:@"StudentsController"];
            [self.navigationController pushViewController:teaVc animated:YES];
        }
            break;
        case 1:
        {
            ConstructionController *teaVc = [[ConstructionController alloc] init];
            [self.navigationController pushViewController:teaVc animated:YES];
        }
            break;
        case 2:
        {
            CommunityController *teaVc = [[CommunityController alloc] init];
            [self.navigationController pushViewController:teaVc animated:YES];
        }
            break;
        case 3:
        {
            ReportingAuditController *reporVC = [[ReportingAuditController alloc] init];
            [self.navigationController pushViewController:reporVC animated:YES];
        }
            break;
        case 4:
        {
            UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            CurriculumController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"CurriculumController"];
            [self.navigationController pushViewController:appendVC animated:YES];
        }
            break;
        case 5:
        {
            SubjectsController *teaVc = [[SubjectsController alloc] init];
            teaVc.isInstitutions = YES;
            [self.navigationController pushViewController:teaVc animated:YES];
        }
            break;
        case 6:
        {
            UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            AskLApprovalController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"AskLApprovalController"];
            [self.navigationController pushViewController:appendVC animated:YES];
        }
            break;
        case 7:
        {
            PhoneToController *phonVC = [[PhoneToController alloc] init];
            [self.navigationController pushViewController:phonVC animated:YES];
        }
            break;
        case 8:
        {
//            UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            MoneyController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"MoneyController"];
//            [self.navigationController pushViewController:appendVC animated:YES];
            [MBProgressHUD showError:@"暂未开放"];
        }
            break;
        default:
            break;
    }
    
    self.hidesBottomBarWhenPushed = NO;
}
- (IBAction)teacher:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    ShareS.isOpen = YES;
    TeacherController *teaVc = [[TeacherController alloc] init];
    [self.navigationController pushViewController:teaVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//课程
- (IBAction)course:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    ShareS.isOpen = YES;
    CourseController *courseVc = [[CourseController alloc] init];
    [self.navigationController pushViewController:courseVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}



@end
