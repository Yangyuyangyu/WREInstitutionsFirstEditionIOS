//
//  ExamManagementController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/1.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ExamManagementController.h"
#import "NavigationView.h"
#import "ExanMCell.h"
#import "ExamResultsController.h"
#import "AddExamController.h"

static NSString *identify = @"ExanMCell";
@interface ExamManagementController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *examMTab;
@end

@implementation ExamManagementController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"考试管理" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"] rightButtonImage:[UIImage imageNamed:@"icon_add.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        ShareS.isOpen = NO;
        [self.navigationController popViewControllerAnimated:YES];
    };
    navigationView.rightButtonAction = ^(){
        self.hidesBottomBarWhenPushed = YES;
        UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AddExamController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"AddExamController"];
        [self.navigationController pushViewController:appendVC animated:YES];
    };
    [self.view addSubview:self.examMTab];
}

#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExanMCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExanMCell" owner:self options:nil]lastObject];
    }
    [cell.entering addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    // 取消选中状态
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}

- (void)handleEvent:(UIButton *)sender{
    self.hidesBottomBarWhenPushed = YES;
    ExamResultsController *examVc = [[ExamResultsController alloc] init];
    [self.navigationController pushViewController:examVc animated:YES];
}
#pragma mark--getter
- (UITableView *)examMTab{
    if (!_examMTab) {
        _examMTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - 64)];
        _examMTab.tableFooterView = [[UIView alloc] init];
        _examMTab.dataSource = self;
        _examMTab.delegate = self;
    }
    return _examMTab;
}

@end
