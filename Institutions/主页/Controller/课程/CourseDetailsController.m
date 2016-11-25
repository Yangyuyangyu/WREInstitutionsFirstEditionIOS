//
//  CourseDetailsController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/3.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "CourseDetailsController.h"
#import "NavigationView.h"
#import "InstructionsCell.h"
#import "DetailsCell.h"
#import "EvaluationCell.h"
#import <UIImageView+WebCache.h>
#import "HomeModel.h"

static NSString *identify = @"InstructionsCell";
static NSString *identify1 = @"DetailsCell";
static NSString *identify2 = @"EvaluationCell";
@interface CourseDetailsController ()<UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>{
    NSArray *infoArray;
    
    NSArray *commentArray;
    NSDictionary *infoDic;
    NSDictionary *tInfoDic;
}
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *titel;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *institutions;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIImageView *teacherPic;
@property (weak, nonatomic) IBOutlet UILabel *name;
//特点
@property (weak, nonatomic) IBOutlet UILabel *characteristics;
//课程说明
@property (weak, nonatomic) IBOutlet UIButton *instruction;
@property (weak, nonatomic) IBOutlet UIView *instruView;
//详情
@property (weak, nonatomic) IBOutlet UIButton *details;
@property (weak, nonatomic) IBOutlet UIView *detailView;
//评价
@property (weak, nonatomic) IBOutlet UIButton *evaluation;
@property (weak, nonatomic) IBOutlet UIView *evaluView;

@property (weak, nonatomic) IBOutlet UITableView *detailTab;
//头View
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, strong) UIWebView *webView;

@property(nonatomic, assign)BOOL choice1;
@property(nonatomic, assign)BOOL choice2;
@property(nonatomic, assign)BOOL choice3;

@property (nonatomic, assign)CGFloat height;

@property (nonatomic, strong) HomeModel *home;

@end

@implementation CourseDetailsController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(course:) name:@"courseInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _choice1 = YES;
    _choice2 = NO;
    _choice3 = NO;
    _instruView.backgroundColor = XN_COLOR_RED_MINT;
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:_courseName leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    _home = [[HomeModel alloc] init];
    [_home courseInfoList:_courseId];
    
    _detailTab.delegate = self;
    _detailTab.dataSource = self;
    _detailTab.tableHeaderView = _backView;
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, XN_WIDTH, 1)];
    _webView.delegate = self;
    _webView.scrollView.scrollEnabled = NO;
    
    infoArray = @[@"适学人群",@"教学目标",@"退班规则",@"插班规则"];
}
- (void)course:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        commentArray = bitice.userInfo[@"data"][@"comment"];
        infoDic = bitice.userInfo[@"data"][@"info"];
        tInfoDic = bitice.userInfo[@"data"][@"tInfo"];
        
        NSString *pic = infoDic[@"img"];
        [_pic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"default_load_img.png"]];
        _titel.text = infoDic[@"name"];
        _content.text = infoDic[@"brief"];
        _institutions.text = infoDic[@"agency"];
        _address.text = infoDic[@"address"];
        
        NSString *teaPic = tInfoDic[@"head"];
        [_teacherPic sd_setImageWithURL:[NSURL URLWithString:teaPic] placeholderImage:[UIImage imageNamed:@"icon_addteacher_head.png"]];
        _name.text = tInfoDic[@"name"];
        _characteristics.text = tInfoDic[@"feature"];
        
        NSString *html = infoDic[@"detail"];
        NSString * htmlcontent = [NSString stringWithFormat:@"<style>img{max-width: 100%@;height: auto;}</style>%@",@"%",html];
        [self.webView loadHTMLString:htmlcontent baseURL:nil];
        [self.webView sizeToFit];
        
        [self.detailTab reloadData];
    }
}
#pragma mark--UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_choice1 == YES) {
        return infoArray.count;
    }else if (_choice2 == YES){
        return 1;
    }else{
        if (commentArray.count == 0) {
            return 1;
        }else{
            return commentArray.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_choice1 == YES) {
        InstructionsCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"InstructionsCell" owner:self options:nil]lastObject];
        }
        cell.titel.text = infoArray[indexPath.row];
            if (indexPath.row == 0) {
                cell.content.text = infoDic[@"fit_crowd"];
            }else if (indexPath.row == 1){
                cell.content.text = infoDic[@"goal"];
            }else if (indexPath.row == 2){
                cell.content.text = infoDic[@"quit_rule"];
            }else if (indexPath.row == 3){
                cell.content.text = infoDic[@"join_rule"];
            }
        _detailTab.contentSize=CGSizeMake(0, 70 * 4 + _backView.bounds.size.height);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (_choice2 == YES){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify1];
        }
        
        [cell.contentView addSubview:_webView];
        self.detailTab.contentSize=CGSizeMake(64, _height + _backView.bounds.size.height + 20);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        EvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"EvaluationCell" owner:self options:nil]lastObject];
        }
        
        if (commentArray.count == 0) {
            _detailTab.contentSize=CGSizeMake(0, _backView.bounds.size.height + 50);
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 21)];
            label.center = CGPointMake(XN_WIDTH/2, cell.frame.size.height/2 - 30);
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"暂无评价";
            [cell.contentView addSubview:label];
        }else{
            NSDictionary *dic = commentArray[indexPath.row];
            NSString *pic = dic[@"head"];
            [cell.pic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"head2x.png"]];
            cell.name.text = dic[@"name"];
            cell.date.text = dic[@"time"];
            cell.content.text = dic[@"content"];
            _detailTab.contentSize=CGSizeMake(0, 109 * commentArray.count + _backView.bounds.size.height);
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InstructionsCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InstructionsCell" owner:self options:nil]lastObject];
    }
    if (_choice1 == YES) {
        return cell.frame.size.height;
    }else if (_choice2 == YES){
        return _height;
    }else{
        return 109;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //获取页面高度（像素）
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    float clientheight = [clientheight_str floatValue];
    _height = clientheight;
    webView.frame = CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y, XN_WIDTH, clientheight + 20);
}

//所属机构
- (IBAction)institutions:(UIButton *)sender {
    NSLog(@"afga");
}
//地址
- (IBAction)address:(UIButton *)sender {
    NSLog(@"afga");
}

- (IBAction)choose:(UIButton *)sender {
    if (sender.tag == 0) {
        _choice1 = YES;
        _choice2 = NO;
        _choice3 = NO;
        _instruView.backgroundColor = XN_COLOR_RED_MINT;
        _detailView.backgroundColor = [UIColor colorWithWhite:0.937 alpha:1.000];
        _evaluView.backgroundColor = [UIColor colorWithWhite:0.937 alpha:1.000];
        [_detailTab reloadData];
    }else if (sender.tag == 1){
        _choice1 = NO;
        _choice2 = YES;
        _choice3 = NO;
        _detailView.backgroundColor = XN_COLOR_RED_MINT;
        _evaluView.backgroundColor = [UIColor colorWithWhite:0.937 alpha:1.000];
        _instruView.backgroundColor = [UIColor colorWithWhite:0.937 alpha:1.000];
//        _detailTab.scrollEnabled = NO;
        [_detailTab reloadData];
        
    }else{
        _choice1 = NO;
        _choice2 = NO;
        _choice3 = YES;
        _evaluView.backgroundColor = XN_COLOR_RED_MINT;
        _instruView.backgroundColor = [UIColor colorWithWhite:0.937 alpha:1.000];
        _detailView.backgroundColor = [UIColor colorWithWhite:0.937 alpha:1.000];
        [_detailTab reloadData];
    }
}

@end
