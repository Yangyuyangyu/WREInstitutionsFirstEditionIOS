//
//  AfterVisitController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/8.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "AfterVisitController.h"
#import "NavigationView.h"
#import "AddPhoneToController.h"
#import "OtherCell.h"
#import "AfterDetailController.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>

#import "ManagementModel.h"

static NSString *identify = @"OtherCell";
@interface AfterVisitController ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *dataSource;
}
@property (nonatomic, strong)UITableView *afterTab;

@property (nonatomic, strong) ManagementModel *management;
@end

@implementation AfterVisitController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(manage:) name:@"manageInfoList" object:nil];
    [self.afterTab.mj_header beginRefreshing];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"电话追访" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"] rightButtonImage:[UIImage imageNamed:@"icon_add.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    navigationView.rightButtonAction = ^(){
        UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AddPhoneToController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"AddPhoneToController"];
        [self.navigationController pushViewController:appendVC animated:YES];
    };
    [self.view addSubview:self.afterTab];
    
    _management = [[ManagementModel alloc] init];
    
    _afterTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_management manageInfoList:@"6" typeId:_institutionsId];
        });
    }];
    
}
- (void)manage:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        [_afterTab reloadData];
    }
    [_afterTab.mj_header endRefreshing];//结束刷新
}
#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OtherCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OtherCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic = dataSource[indexPath.row];
    cell.backView.layer.shadowOffset = CGSizeMake(1, 1);
    cell.backView.layer.shadowColor = [UIColor grayColor].CGColor;
    cell.backView.layer.shadowOpacity = .5f;
    cell.backView.layer.cornerRadius = 2;
    cell.rest.text = @"电话追访";
    cell.tatle1.text = @"学生";
    cell.tatle.text = dic[@"student"];
    cell.name1.text = @"指导老师";
    cell.name.text = dic[@"teacher"];
    cell.time1.text = @"时间";
    cell.time.text = dic[@"time"];
    cell.more.tag = indexPath.row;
    cell.state.hidden = YES;
    cell.state1.hidden = YES;
    [cell.more addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 171;
}

- (void)handleEvent:(UIButton *)sender{
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AfterDetailController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"AfterDetailController"];
    appendVC.dataId = dataSource[sender.tag][@"id"];
    [self.navigationController pushViewController:appendVC animated:YES];
}

#pragma mark--getter
- (UITableView *)afterTab{
    if (!_afterTab) {
        _afterTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - 64)];
        _afterTab.tableFooterView = [[UIView alloc] init];
        _afterTab.dataSource = self;
        _afterTab.delegate = self;
        _afterTab.separatorStyle = NO;
    }
    return _afterTab;
}

@end
