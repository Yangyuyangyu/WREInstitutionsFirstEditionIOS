//
//  AddExamController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/13.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "AddExamController.h"
#import "NavigationView.h"
#import "CZCover.h"

static NSString *identify = @"CELL";
@interface AddExamController ()<UITableViewDelegate, UITableViewDataSource, CZCoverDelegate>{
    NSArray *dataSource;
}
//科目
@property (weak, nonatomic) IBOutlet UILabel *subject;
//开始
@property (weak, nonatomic) IBOutlet UIButton *start;
//结束
@property (weak, nonatomic) IBOutlet UIButton *end;

@property (nonatomic, strong)CZCover *cover;
@property (nonatomic, strong)UITableView *czTabel;

@property (nonatomic, strong)UIDatePicker *pickView;
@end

@implementation AddExamController

- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"考试管理" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    //    让分割线顶头
    if ([self.czTabel respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.czTabel setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.czTabel respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.czTabel setLayoutMargins:UIEdgeInsetsZero];
        
    }
    dataSource = @[@"afaada",@"ffff",@"ggggg",@"车上语文002"];
}
#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.text = dataSource[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.537 alpha:1.000];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel sizeToFit];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _subject.text = dataSource[indexPath.row];
    [_cover remove];
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*设置cell 的宽度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
//让分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}
- (IBAction)time:(UIButton *)sender {
    [self masking:sender.tag];
}
//课程
- (IBAction)course:(UIButton *)sender {
    // 弹出蒙板
    _cover = [CZCover show];
    _cover.delegate = self;
    [self.view addSubview:_cover];
    [_cover addSubview:self.czTabel];
}
//新增
- (IBAction)new:(UIButton *)sender {
    
}
- (void)confirm:(UIButton *)sender{
    NSDate *textmydate = [self.pickView date];
    NSDateFormatter *dateformate = [[NSDateFormatter alloc] init];
    [dateformate setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *showdate =[dateformate stringFromDate:textmydate];
    NSLog(@"%@",showdate);
    if (sender.tag == 10) {
        [_start setTitle:showdate forState:UIControlStateNormal];
    }else{
        [_end setTitle:showdate forState:UIControlStateNormal];
    }
    
    [_cover remove];
}
- (void)masking:(NSInteger)number{
    [self.view endEditing:YES];
    // 弹出蒙板
    _cover = [CZCover show];
    _cover.delegate = self;
    [self.view addSubview:_cover];
    // 弹出pop菜单
    CGFloat popW = XN_WIDTH - 20;
    CGFloat popX = 10;
    CGFloat popH = XN_HEIGHT/3;
    CGFloat popY = XN_HEIGHT/3;
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(popX, popY, popW, popH)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, CGRectGetMaxY(self.pickView.frame)+3, XN_WIDTH - 30, 35);
    button.backgroundColor = XN_COLOR_RED_MINT;
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button setTintColor:[UIColor whiteColor]];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = number;
    [view addSubview:self.pickView];
    [view addSubview:button];
    [_cover addSubview:view];
    
}
#pragma mark--getter
- (UITableView *)czTabel{
    if (!_czTabel) {
        _czTabel = [[UITableView alloc]initWithFrame:CGRectMake(XN_WIDTH - 130, 114, 100, 120)];
        _czTabel.tableFooterView = [[UIView alloc] init];
        _czTabel.dataSource = self;
        _czTabel.delegate = self;
        _czTabel.layer.borderWidth = 1;
        _czTabel.layer.borderColor = XN_COLOR_RED_MINT.CGColor;
        _czTabel.layer.cornerRadius = 5;
        _czTabel.layer.masksToBounds = YES;
        _czTabel.tag = 100;
    }
    return _czTabel;
}

- (UIDatePicker *)pickView{
    if (!_pickView) {
        CGFloat popW = XN_WIDTH - 20;
        CGFloat popH = XN_HEIGHT/3 - 45;
        _pickView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, popW, popH)];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
        _pickView.locale = locale;
        _pickView.datePickerMode = UIDatePickerModeDateAndTime;
    }
    return _pickView;
}
@end
