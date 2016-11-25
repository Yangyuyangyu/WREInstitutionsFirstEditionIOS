//
//  OtherController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/1.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "OtherController.h"
#import "NavigationView.h"
#import "OtherCell.h"
#import "AddOtherController.h"
#import "OtherDetailsController.h"

static NSString *identify = @"OtherCell";
@interface OtherController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *otherTab;
@end

@implementation OtherController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"其他课管理" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"] rightButtonImage:[UIImage imageNamed:@"icon_add.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        ShareS.isOpen = NO;
        [self.navigationController popViewControllerAnimated:YES];
    };
    navigationView.rightButtonAction = ^(){
        self.hidesBottomBarWhenPushed = YES;
        UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AddOtherController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"AddOtherController"];
        [self.navigationController pushViewController:appendVC animated:YES];
    };
    [self.view addSubview:self.otherTab];
}

#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OtherCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OtherCell" owner:self options:nil]lastObject];
    }
    cell.backView.layer.shadowOffset = CGSizeMake(1, 1);
    cell.backView.layer.shadowColor = [UIColor grayColor].CGColor;
    cell.backView.layer.shadowOpacity = .5f;
    cell.backView.layer.cornerRadius = 2;
    
    cell.more.tag = indexPath.row;
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
    self.hidesBottomBarWhenPushed = YES;
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OtherDetailsController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"OtherDetailsController"];
    [self.navigationController pushViewController:appendVC animated:YES];
}
#pragma mark--getter
- (UITableView *)otherTab{
    if (!_otherTab) {
        _otherTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - 64)];
        _otherTab.tableFooterView = [[UIView alloc] init];
        _otherTab.dataSource = self;
        _otherTab.delegate = self;
        _otherTab.separatorStyle = NO;
    }
    return _otherTab;
}

@end
