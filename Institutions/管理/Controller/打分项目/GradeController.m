//
//  GradeController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/8.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "GradeController.h"
#import "GradeCell.h"
#import "NavigationView.h"
#import "ManagementModel.h"

static NSString *identify = @"GradeCell";
@interface GradeController ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *dataSouce;
    NSArray *dataArray;
    NSMutableDictionary *mutaDic;
}
@property (weak, nonatomic) IBOutlet UITableView *gradeTab;
//取消
@property (weak, nonatomic) IBOutlet UIButton *cancel;
//确定
@property (weak, nonatomic) IBOutlet UIButton *determine;

@property (nonatomic, strong) ManagementModel *management;
@end

@implementation GradeController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(manage:) name:@"manageInfoList" object:nil];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scoreItem:) name:@"scoreItemInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"打分项目" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    _gradeTab.delegate = self;
    _gradeTab.dataSource = self;
    _gradeTab.tableFooterView = [[UIView alloc] init];
    _gradeTab.separatorStyle = NO;
    _gradeTab.scrollEnabled = NO;
    
    _cancel.layer.borderWidth = 1;
    _cancel.layer.borderColor = [UIColor grayColor].CGColor;
    _cancel.layer.cornerRadius = 5;
    _cancel.layer.masksToBounds = YES;
    
    _determine.layer.borderWidth = 1;
    _determine.layer.borderColor = [UIColor grayColor].CGColor;
    _determine.layer.cornerRadius = 5;
    _determine.layer.masksToBounds = YES;
    
    dataSouce = @[@"纪律卫生与学具状态",@"回课练习与新课掌握",@"学习积极性与专注度",@"心理素质与表现能力",@"团队协作与协调能力"];
    
    mutaDic = [NSMutableDictionary dictionary];
    _management = [[ManagementModel alloc] init];
    [_management manageInfoList:@"7" typeId:_communityId];
}

//打分项目
- (void)manage:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataArray = bitice.userInfo[@"data"];
        for (NSDictionary *dic in dataArray) {
            NSString *str = dic[@"id"];
            int num = [str intValue];
            NSNumber *number = [NSNumber numberWithInt:num];
            [mutaDic setObject:number forKey:str];
        }
        
        [_gradeTab reloadData];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
}

//修改社团打分项目
- (void)scoreItem:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        [MBProgressHUD showSuccess:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
}
#pragma mark--UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GradeCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GradeCell" owner:self options:nil] lastObject];
    }
    cell.content.text = dataSouce[indexPath.row];
    cell.tick.tag = indexPath.row + 1;
    [cell.tick addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
    NSString *str = [NSString stringWithFormat:@"%d",(indexPath.row + 1)];
    if ([mutaDic objectForKey:str]) {
        cell.tick.selected = !cell.tick.selected;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)handleEvent:(UIButton *)sender{
    if (!sender.selected) {
        NSString *str = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        int num = [str intValue];
        NSNumber *number = [NSNumber numberWithInt:num];
        [mutaDic setObject:number forKey:str];
        sender.selected = !sender.selected;
    }else{
        NSString *str = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        [mutaDic removeObjectForKey:str];
        sender.selected = !sender.selected;
    }
}

- (IBAction)determine:(UIButton *)sender{
    if (sender.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSArray *item = [mutaDic allValues];
        //排序
        NSArray *sortedArray = [item sortedArrayUsingComparator: ^(id obj1, id obj2) {
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        //    拼接成字符串
        NSMutableString *mutaStr = [[NSMutableString alloc] init];
        for (int i = 0; i < sortedArray.count; i ++) {
            if (i == sortedArray.count - 1) {
                [mutaStr appendString:[NSString stringWithFormat:@"%@",sortedArray[i]]];
            }else{
                [mutaStr appendString:[NSString stringWithFormat:@"%@,",sortedArray[i]]];
            }
        }
        NSString *str = (NSString *)mutaStr;
        [_management scoreItemInfoList:_communityId item:str];
    }
}
@end
