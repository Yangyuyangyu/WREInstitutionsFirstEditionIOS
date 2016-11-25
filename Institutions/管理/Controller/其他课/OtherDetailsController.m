//
//  OtherDetailsController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/8.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "OtherDetailsController.h"
#import "AddOtherCell.h"
#import "NavigationView.h"

static NSString *identify = @"AddOtherCell";
@interface OtherDetailsController ()<UITableViewDelegate ,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UITableView *detailTab;
@end

@implementation OtherDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"其他课详情" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    _detailTab.tableHeaderView = _backView;
}

#pragma mark--UITableViewDelegate ,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddOtherCell" owner:self options:nil]lastObject];
    }
    cell.contentTextView.editable = NO;
    return cell;
}
/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}
@end
