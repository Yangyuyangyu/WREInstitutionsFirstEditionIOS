//
//  CardController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/7.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "CardController.h"
#import "NavigationView.h"
#import "CommCell.h"

static NSString *identify = @"CommCell";
@interface CardController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *courseTab;

@end

@implementation CardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"选择银行卡" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:self.courseTab];
}
#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor colorWithWhite:0.875 alpha:1.000];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor colorWithWhite:0.255 alpha:1.000];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:13];
    headerLabel.frame = CGRectMake(18, 0.0, 300.0, 44.0);
    headerLabel.text =  @"到账银行";
    [customView addSubview:headerLabel];
   
    return customView;
}
/*设置标题头的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
/*设置cell 的宽度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
#pragma mark--getter
- (UITableView *)courseTab{
    if (!_courseTab) {
        _courseTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - 64)];
        _courseTab.tableFooterView = [[UIView alloc] init];
        _courseTab.dataSource = self;
        _courseTab.delegate = self;
    }
    return _courseTab;
}

@end
