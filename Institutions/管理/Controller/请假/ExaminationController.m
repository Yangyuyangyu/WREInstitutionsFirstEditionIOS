//
//  ExaminationController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/7.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ExaminationController.h"
#import "NavigationView.h"
#import "IntroductionController.h"

#import "ManagementModel.h"

@interface ExaminationController (){
    NSDictionary *dataSourceDic;
}
@property (weak, nonatomic) IBOutlet UILabel *name;
//课程
@property (weak, nonatomic) IBOutlet UILabel *course;
//事由
@property (weak, nonatomic) IBOutlet UILabel *reason;

@property (weak, nonatomic) IBOutlet UILabel *time;
//备注
@property (weak, nonatomic) IBOutlet UILabel *note;

@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *refused;
@property (weak, nonatomic) IBOutlet UIButton *through;

@property (weak, nonatomic) IBOutlet UIView *backView;
//临时帐号
@property (weak, nonatomic) IBOutlet UILabel *phone;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;

@property (weak, nonatomic) IBOutlet UIView *backView1;
@property (weak, nonatomic) IBOutlet UILabel *backLabel;

@property (nonatomic, strong) ManagementModel *management;
@end

@implementation ExaminationController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(leaveInfo:) name:@"leaveInfoInfoList" object:nil];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(leaveAuth:) name:@"leaveAuthInfoList" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tmpInfo:) name:@"tmpInfoInfoList" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tmpAuth:) name:@"tmpAuthInfoList" object:nil];
    if (_isAsk == YES) {
        [_management leaveInfoInfoList:_askId];
    }else{
        [_management tmpInfoInfoList:_askId];
    }
    
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *str = @"";
    if (_isAsk == YES) {
        str = @"请假审批";
        _backView.hidden = YES;
        _line.constant -= _line1.constant;
        _line1.constant = 0;
    }else{
        str = @"临时帐号审批";
    }
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:str leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    _management = [[ManagementModel alloc] init];
    dataSourceDic = [NSDictionary dictionary];
    
}
//临时帐号审批
- (void)tmpInfo:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSourceDic = bitice.userInfo[@"data"];
        _name.text = dataSourceDic[@"name"];
        _course.text = dataSourceDic[@"course"];
        _reason.text = dataSourceDic[@"reason"];
        _time.text = dataSourceDic[@"class_time"];
        _note.text = dataSourceDic[@"remark"];
        _phone.text = dataSourceDic[@"account"];
        _status = dataSourceDic[@"status"];
        if ([_status isEqualToString:@"0"]) {
            _backView1.hidden = NO;
            _backLabel.hidden = YES;
            _refused.layer.borderWidth = 1;
            _refused.layer.borderColor = [UIColor grayColor].CGColor;
            _refused.layer.cornerRadius = 5;
            _refused.layer.masksToBounds = YES;
            
            _through.layer.borderWidth = 1;
            _through.layer.borderColor = [UIColor grayColor].CGColor;
            _through.layer.cornerRadius = 5;
            _through.layer.masksToBounds = YES;
        }else{
            _backView1.hidden = YES;
            _backLabel.hidden = NO;
            if ([_status isEqualToString:@"1"]) {
                _backLabel.text = @"已通过";
            }else{
                _backLabel.text = @"已拒绝";
            }
        }
    }else{
        [MBProgressHUD showError:@"审批失败"];
    }
}
//临时帐号审批
- (void)tmpAuth:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showError:@"审批失败"];
    }
}

- (void)leaveInfo:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSourceDic = bitice.userInfo[@"data"];
        _name.text = dataSourceDic[@"name"];
        _course.text = dataSourceDic[@"course"];
        _reason.text = dataSourceDic[@"reason"];
        _time.text = [NSString stringWithFormat:@"%@~%@",dataSourceDic[@"start"],dataSourceDic[@"end"]];
        _note.text = dataSourceDic[@"remark"];
        _status = dataSourceDic[@"status"];
        if ([_status isEqualToString:@"0"]) {
            _backView1.hidden = NO;
            _backLabel.hidden = YES;
            _refused.layer.borderWidth = 1;
            _refused.layer.borderColor = [UIColor grayColor].CGColor;
            _refused.layer.cornerRadius = 5;
            _refused.layer.masksToBounds = YES;
            
            _through.layer.borderWidth = 1;
            _through.layer.borderColor = [UIColor grayColor].CGColor;
            _through.layer.cornerRadius = 5;
            _through.layer.masksToBounds = YES;
        }else{
            _backView1.hidden = YES;
            _backLabel.hidden = NO;
            if ([_status isEqualToString:@"1"]) {
                _backLabel.text = @"已通过";
            }else{
                _backLabel.text = @"已拒绝";
            }
        }
    }
}
//请假审批
- (void)leaveAuth:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showError:@"审批失败"];
    }
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
//拒绝
- (IBAction)refused:(UIButton *)sender {
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    IntroductionController *locationVc = [mainSB instantiateViewControllerWithIdentifier:@"IntroductionController"];
    if (_isAsk == YES) {
        locationVc.isAsk = 1;
    }else{
        locationVc.isAsk = 2;
    }
    locationVc.askId = _askId;
    [self.navigationController pushViewController:locationVc animated:YES];

}
//通过
- (IBAction)through:(UIButton *)sender {
    if (_isAsk == YES) {
        [_management leaveAuthInfoList:_askId result:@"1" refuse:@""];
    }else{
        [_management tmpAuthInfoList:_askId result:@"1" refuse:@""];
    }
    
}

@end
