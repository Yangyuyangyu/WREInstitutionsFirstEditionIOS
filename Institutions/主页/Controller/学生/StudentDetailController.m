//
//  StudentDetailController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/23.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "StudentDetailController.h"
#import "StudentDetailCell.h"
#import <UIImageView+WebCache.h>

#import "HomeModel.h"

static NSString *identify = @"StudentDetailCell";
@interface StudentDetailController ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *dataSource;
    NSDictionary *dataSourceDic;
}
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITableView *detailTab;

@property (nonatomic, strong) HomeModel *home;

@end

@implementation StudentDetailController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(student:) name:@"studentInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _detailTab.dataSource = self;
    _detailTab.delegate = self;
    _detailTab.tableHeaderView = _backView;
    
    _home = [[HomeModel alloc] init];
    
    [_home studentInfoList:_studentId];
    
    dataSource = [NSArray array];
    dataSourceDic = [NSDictionary dictionary];
}

- (void)student:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSourceDic = bitice.userInfo[@"data"][@"info"];
        [_headPic sd_setImageWithURL:dataSourceDic[@"head"] placeholderImage:[UIImage imageNamed:@"default_load_img.png"]];
        _name.text = dataSourceDic[@"name"];
        dataSource = bitice.userInfo[@"data"][@"groups"];
        [_detailTab reloadData];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
}
#pragma mark--UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StudentDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"StudentDetailCell" owner:self options:nil] lastObject];
    }
    NSDictionary *dic = dataSource[indexPath.row];
    cell.pic.layer.cornerRadius = 40;
    cell.pic.layer.masksToBounds = YES;
    [cell.pic sd_setImageWithURL:dic[@"img"] placeholderImage:[UIImage imageNamed:@"icon_addteacher_head.png"]];
    cell.tetle.text = dic[@"name"];
    cell.admin.text = [NSString stringWithFormat:@"管理员:%@",dic[@"admin_name"]];
    cell.content.text = dic[@"brief"];
    cell.number.text = [NSString stringWithFormat:@"%@个科目",dic[@"subjectNum"]];
    _detailTab.contentSize=CGSizeMake(0, 97 * dataSource.count + _backView.bounds.size.height);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
/*设置cell 的宽度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 97;
}
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)phone:(UIButton *)sender {
    NSString *phone = dataSourceDic[@"phone"];
    if (phone.length != 0) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }else{
        [MBProgressHUD showError:@"电话号码为空"];
    }
}

@end
