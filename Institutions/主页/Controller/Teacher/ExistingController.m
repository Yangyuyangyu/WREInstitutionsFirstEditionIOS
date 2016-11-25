//
//  ExistingController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/2.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ExistingController.h"
#import "TeacherCell.h"
#import "NavigationView.h"
#import "HomeModel.h"
#import <UIImageView+WebCache.h>
#import "AddStudentController.h"

static NSString *identify = @"TeacherCell";
@interface ExistingController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>{
    NSArray *dataSource;
}
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *recentlyTab;

@property (nonatomic, assign)BOOL isSearch;
@property (nonatomic, assign) BOOL isNO;

@property (nonatomic, strong)HomeModel *home;
@end

@implementation ExistingController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(choose:) name:@"chooseInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(save:) name:@"saveInfoList" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chooseStudent:) name:@"chooseStudentInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = @"";
    if (_isTeacher == YES) {
        title = @"全部老师";
    }else{
        title = @"选择已有学生";
    }
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:title leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    _recentlyTab.dataSource = self;
    _recentlyTab.delegate = self;
    _recentlyTab.tableFooterView = [[UIView alloc] init];
    
    dataSource = [NSArray array];
    _home = [[HomeModel alloc] init];
    if (_isTeacher == YES) {
        [_home chooseInfoList:nil];
    }else{
        [_home chooseStudentInfoList:nil];
    }
    
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTextField.returnKeyType = UIReturnKeySearch;
    _searchTextField.delegate = self;
    _isSearch = NO;
}
- (void)choose:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
    }else if ([bitice.userInfo[@"code"] isEqualToNumber:@(-1)]){
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
    [_recentlyTab reloadData];
}
- (void)save:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        [MBProgressHUD showError:@"新增成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([bitice.userInfo[@"code"] isEqualToNumber:@(-2)]){
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
}

- (void)chooseStudent:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
    [_recentlyTab reloadData];
}
#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TeacherCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic = dataSource[indexPath.row];
    cell.line.constant = 0;
    cell.content.hidden = YES;
    cell.pic.layer.cornerRadius = 25;
    cell.pic.layer.masksToBounds = YES;
    [cell.pic sd_setImageWithURL:dic[@"head"] placeholderImage:[UIImage imageNamed:@"default_load_img.png"]];
    cell.titel.text = dic[@"name"];
    cell.phone.tag = indexPath.row;
    [cell.phone addTarget:self action:@selector(phoneHandleEvent:) forControlEvents:UIControlEventTouchUpInside];
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _isSearch = YES;
    if (_isTeacher == YES) {
        [_home chooseInfoList:dataSource[indexPath.row][@"phone"]];
    }else{
        [_home chooseStudentInfoList:dataSource[indexPath.row][@"phone"]];
    }
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*设置cell 的宽度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;

}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor colorWithWhite:0.875 alpha:1.000];
    if (_isSearch == NO) {
        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.opaque = NO;
        headerLabel.textColor = [UIColor colorWithWhite:0.255 alpha:1.000];
        headerLabel.highlightedTextColor = [UIColor whiteColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:16];
        headerLabel.frame = CGRectMake(18, 0.0, 300.0, 44.0);
        headerLabel.text =  @"最近新增";
        [customView addSubview:headerLabel];
    }
    return customView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor colorWithWhite:0.843 alpha:0.000];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, XN_WIDTH * 0.8, 35);
    button.center = CGPointMake(XN_WIDTH/2, 30);
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    if (_isSearch == YES && dataSource.count != 0) {
        [button setTitle:@"新增" forState:UIControlStateNormal];
        _isNO = NO;
    }else{
        [button setTitle:@"查看最近新增" forState:UIControlStateNormal];
        _isNO = YES;
    }
    [button setTintColor:[UIColor whiteColor]];
    button.backgroundColor = XN_COLOR_RED_MINT;
    [button addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:button];
    return customView;
}
/*设置标题头的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_isSearch == NO) {
        return 40;
    }else{
        return 10;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_isSearch == YES) {
       return 60;
    }else{
        return 0;
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _isSearch = YES;
    [_searchTextField resignFirstResponder];
    if ([CManager validateMobile:textField.text]) {
        dataSource = nil;
        if (_isTeacher == YES) {
            [_home chooseInfoList:textField.text];
        }else{
            [_home chooseStudentInfoList:textField.text];
        }
    }else{
        [MBProgressHUD showError:@"电话号码不正确"];
    }
    return YES;
}
//限制输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.searchTextField) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }
    
    return YES;
}
#pragma mark--点击事件
- (void)handleEvent:(UIButton *)sender{
    if (_isNO == YES) {
        _isSearch = NO;
        if (_isTeacher == YES) {
            [_home chooseInfoList:nil];
        }else{
            [_home chooseStudentInfoList:nil];
        }
    }else{
        if (_isTeacher == YES) {
            [_home saveInfoList:dataSource[0][@"id"]];
        }else{
            self.hidesBottomBarWhenPushed = YES;
            UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            AddStudentController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"AddStudentController"];
            appendVC.studentId = dataSource[sender.tag][@"id"];
            appendVC.isDirectly = NO;
            [self.navigationController pushViewController:appendVC animated:YES];
        }
    }
}
- (void)phoneHandleEvent:(UIButton *)sender{
    NSString *phone = dataSource[sender.tag][@"phone"];
    if (phone.length != 0) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }else{
        [MBProgressHUD showError:@"电话号码为空"];
    }
}
//回收键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

//点击空白处回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
