//
//  BankCardController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/14.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "BankCardController.h"
#import "NavigationView.h"
#import "BankCardCell.h"
#import "BindingController.h"
#import "DrawerModel.h"

static NSString *identify = @"BankCardCell";
@interface BankCardController ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *dataSource;
}
@property (weak, nonatomic) IBOutlet UIButton *operation;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;
@property (weak, nonatomic) IBOutlet UITableView *bankTab;

@property (nonatomic, strong) DrawerModel *drawer;

@property (nonatomic, assign) NSInteger number;
@end

@implementation BankCardController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(myCards:) name:@"myCardsInfoList" object:nil];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(delCard:) name:@"delCardInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"银行卡" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(XN_WIDTH - 60, 30, 50, 30);
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:@"解绑" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    _bankTab.delegate = self;
    _bankTab.dataSource = self;
    
    _drawer = [[DrawerModel alloc] init];
    [_drawer myCardsInfoList];
}

//修改简介
- (void)myCards:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        [_bankTab reloadData];
    }else{
        [MBProgressHUD showError:@"获取消息失败"];
    }
}

//解绑银行卡
- (void)delCard:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        NSMutableArray *mutabArray = [NSMutableArray array];
        [mutabArray addObjectsFromArray:dataSource];
        [mutabArray removeObjectAtIndex:_number];
        dataSource = (NSArray *)mutabArray;
        [_bankTab reloadData];
    }else{
        [MBProgressHUD showError:@"获取消息失败"];
    }
}
#pragma mark--UITableViewDelegate, UITableViewDataSource

//cell行数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataSource.count;
}
//表头的高度;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;//接近0
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor whiteColor];
    return customView;
}
//表尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BankCardCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic = dataSource[indexPath.section];
    cell.backView.layer.cornerRadius = 5;
    cell.backView.layer.masksToBounds = YES;
    cell.card.text = dic[@"bankName"];
    cell.type.text = dic[@"account_name"];
    cell.number.text = dic[@"account_num"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

//设置编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

//自定义按钮
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *layTopRowAction1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"解绑" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        _number = indexPath.section;
        [_drawer delCardInfoList:dataSource[indexPath.section][@"id"]];
        [tableView setEditing:NO animated:YES];
    }];
    layTopRowAction1.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *layTopRowAction2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"添加" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BindingController *bingVC = [mainSB instantiateViewControllerWithIdentifier:@"BindingController"];
        [self.navigationController pushViewController:bingVC animated:YES];
        [tableView setEditing:NO animated:YES];
    }];
    layTopRowAction2.backgroundColor = [UIColor greenColor];
    
    NSArray *arr = @[layTopRowAction1,layTopRowAction2];
    return arr;
}
//设置能否移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 114;
}
#pragma mark--按钮点击

- (void)handleEvent:(UIButton *)sender{
    [_bankTab setEditing:!_bankTab.editing animated:YES];
    if (_bankTab.editing) {
        _line.constant = -16;
        [sender setTitle:@"取消" forState:UIControlStateNormal];
    }else{
        _line.constant = 20;
        [sender setTitle:@"解绑" forState:UIControlStateNormal];
    }
}
//添加
- (IBAction)operation:(UIButton *)sender {
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BindingController *bingVC = [mainSB instantiateViewControllerWithIdentifier:@"BindingController"];
    [self.navigationController pushViewController:bingVC animated:YES];
}


@end
