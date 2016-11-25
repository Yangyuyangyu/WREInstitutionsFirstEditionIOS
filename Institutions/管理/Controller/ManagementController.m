//
//  ManagementController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/5/27.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ManagementController.h"
#import "ManagementCell.h"
#import "NavigationView.h"
#import "DynamicController.h"
#import "CorporateTPlanController.h"
#import "AskLApprovalController.h"
#import "TemporaryAController.h"
#import "MaintenanceController.h"
#import "PhoneToController.h"
#import "ScoreController.h"
#import "OtherController.h"
#import "ReportingAuditController.h"
#import "ExamManagementController.h"


static NSString *identify = @"ManagementCell";
@interface ManagementController ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray *contentArray1;
    NSArray *contentArray2;
    NSArray *contentArray3;
    NSArray *picArray1;
    NSArray *picArray2;
    NSArray *picArray3;
}
@property (nonatomic, strong)UITableView *managTab;



@end

@implementation ManagementController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"日常管理" leftButtonImage:nil];
    [self.view addSubview:navigationView];
    [self.view addSubview:self.managTab];
    contentArray1 = @[@"动态",@"社团训练规划",@"请假审批",@"临时帐号审批"];
    picArray1 = @[@"manage_dynamic.png",@"manage_association.png",@"manage_leave.png",@"manage_temporary.png"];
    contentArray2 = @[@"维修管理",@"电话追访记录",@"打分项目管理"];
    picArray2 = @[@"manage_repair.png",@"manage_phone.png",@"manage_grade.png"];
    contentArray3 = @[@"其他课管理",@"上课汇报审核",@"考试管理"];
    picArray3 = @[@"manage_other.png",@"manage_class_condition.png",@"manage_exam.png"];
    
}


#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }else{
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ManagementCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ManagementCell" owner:self options:nil]lastObject];
    }
    if (indexPath.section == 0) {
        cell.content.text = contentArray1[indexPath.row];
        cell.pic.image = [UIImage imageNamed:picArray1[indexPath.row]];
    }else if (indexPath.section == 1){
        cell.content.text = contentArray2[indexPath.row];
        cell.pic.image = [UIImage imageNamed:picArray2[indexPath.row]];
    }else{
        cell.content.text = contentArray3[indexPath.row];
        cell.pic.image = [UIImage imageNamed:picArray3[indexPath.row]];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    ShareS.isOpen = YES;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                DynamicController *dyVc = [[DynamicController alloc] init];
                [self.navigationController pushViewController:dyVc animated:YES];
                }
                break;
            case 1:{
//                CorporateTPlanController *dyVc = [[CorporateTPlanController alloc] init];
//                [self.navigationController pushViewController:dyVc animated:YES];
                [MBProgressHUD showError:@"暂未开放"];
            }
                break;
            case 2:{
                UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                AskLApprovalController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"AskLApprovalController"];
                [self.navigationController pushViewController:appendVC animated:YES];
            }
                break;
            case 3:{
                TemporaryAController *dyVc = [[TemporaryAController alloc] init];
                [self.navigationController pushViewController:dyVc animated:YES];
            }
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:{
                MaintenanceController *dyVc = [[MaintenanceController alloc] init];
                [self.navigationController pushViewController:dyVc animated:YES];
            }
                break;
            case 1:{
                PhoneToController *dyVc = [[PhoneToController alloc] init];
                [self.navigationController pushViewController:dyVc animated:YES];
            }
                break;
            case 2:{
                ScoreController *dyVc = [[ScoreController alloc] init];
                [self.navigationController pushViewController:dyVc animated:YES];
            }
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:{
//                OtherController *dyVc = [[OtherController alloc] init];
//                [self.navigationController pushViewController:dyVc animated:YES];
                [MBProgressHUD showError:@"暂未开放"];
            }
                break;
            case 1:{
                ReportingAuditController *dyVc = [[ReportingAuditController alloc] init];
                [self.navigationController pushViewController:dyVc animated:YES];
            }
                break;
            case 2:{
//                ExamManagementController *dyVc = [[ExamManagementController alloc] init];
//                [self.navigationController pushViewController:dyVc animated:YES];
                [MBProgressHUD showError:@"暂未开放"];
            }
                break;
            default:
                break;
        }
    }
    self.hidesBottomBarWhenPushed = NO;
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

/*设置标题头的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
#pragma mark--getter
- (UITableView *)managTab{
    if (!_managTab) {
        _managTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - 113)];
        _managTab.tableFooterView = [[UIView alloc] init];
        _managTab.dataSource = self;
        _managTab.delegate = self;
    }
    return _managTab;
}

@end
