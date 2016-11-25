//
//  ReportDetailController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/12.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ReportDetailController.h"
#import "NavigationView.h"
#import "ReportingDetailCell.h"
#import "ManagementModel.h"
#import "IntroductionController.h"
#import "ReporScoreController.h"
#import "NetworkingManager.h"
#import "AFNetworking.h"
#import <UIImageView+WebCache.h>
#import "XWScanImage.h"//图片浏览器

static NSString *identify = @"ReportingDetailCell";
@interface ReportDetailController ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *dataSource;
    NSArray *dataArray;
    //新增
    NSArray *studentArray;//点名数据
}
@property (nonatomic, strong)UITableView *rDetailTab;
@property (nonatomic, assign)CGRect rect;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) ManagementModel *management;

@property(nonatomic,strong) NSArray *work_imgArray;//作业图片数组



@end

@implementation ReportDetailController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reportInfo:) name:@"reportInfoInfoList" object:nil];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reportAuth:) name:@"reportAuthInfoList" object:nil];
    [_management reportInfoInfoList:_dataId];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_button removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.843 alpha:1.000];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"上课记录审核" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    dataArray = @[@"课堂重点",@"上课过程",@"建议办法",@"作业展示"];
    dataSource = @[@"",@"",@"",@""];
    
    [self.view addSubview:self.rDetailTab];
    
    _management = [[ManagementModel alloc] init];
    //获取点名
    [self getCourseStudentInfo:_dataId];
    
}

- (void)reportInfo:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        NSDictionary *dic = bitice.userInfo[@"data"];
        NSString *content = dic[@"content"];
        NSString *problem = dic[@"problem"];
        NSString *solution = dic[@"solution"];
        //作业展示
        NSString *work_content = dic[@"work_content"];
        NSString*workImg=dic[@"img"];
        NSString*workImgNow=nil;
        //判断最后一位是否为","进行拆分
        
        if(workImg.length!=0){
            NSString *last = [workImg substringFromIndex:workImg.length-1];
            if([last isEqualToString:@","]){
                workImgNow=[workImg substringToIndex:workImg.length-1];
                _work_imgArray=[workImgNow componentsSeparatedByString:@","];
            }else{
                _work_imgArray=[workImg componentsSeparatedByString:@","];
            }
        }
        
        NSLog(@"作业图片%@",_work_imgArray);
        
        NSString *status = dic[@"status"];
        if ([status isEqualToString:@"0"]) {//未审核
            CGRect frame1 = CGRectMake(15, XN_HEIGHT - 50, XN_WIDTH / 2 - 30, 35);
            CGRect frame2 = CGRectMake(XN_WIDTH / 2 + 15, XN_HEIGHT - 50, XN_WIDTH / 2 - 30, 35);
            CGRect frame3 = CGRectMake(15, XN_HEIGHT - 100, XN_WIDTH - 30, 35);
            
            [self setUpButton:frame1 number:100 name:@"拒绝"];
            [self setUpButton:frame2 number:101 name:@"通过"];
            [self setUpButton:frame3 number:102 name:@"查看学生评分"];
        }else if ([status isEqualToString:@"1"]){//通过
            CGRect labelframe = CGRectMake(0, 0, 100, 25);
            [self setUplabel:labelframe name:@"已通过"];
            CGRect frame3 = CGRectMake(15, XN_HEIGHT - 50, XN_WIDTH - 30, 35);
            [self setUpButton:frame3 number:102 name:@"查看学生评分"];
            _rDetailTab.frame = CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - 145);
        }else{ //拒绝
//            CGRect labelframe = CGRectMake(0, 0, 100, 25);
//            [self setUplabel:labelframe name:@"已拒绝"];
//            CGRect frame3 = CGRectMake(15, XN_HEIGHT - 50, XN_WIDTH - 30, 35);
//            [self setUpButton:frame3 number:102 name:@"查看学生评分"];
//            _rDetailTab.frame = CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - 145);
            CGRect frame1 = CGRectMake(15, XN_HEIGHT - 50, XN_WIDTH / 2 - 30, 35);
            CGRect frame2 = CGRectMake(XN_WIDTH / 2 + 15, XN_HEIGHT - 50, XN_WIDTH / 2 - 30, 35);
            CGRect frame3 = CGRectMake(15, XN_HEIGHT - 100, XN_WIDTH - 30, 35);
            
            [self setUpButton:frame1 number:100 name:@"再次拒绝"];
            [self setUpButton:frame2 number:101 name:@"再次通过"];
            [self setUpButton:frame3 number:102 name:@"查看学生评分"];
        }
        
        
        dataSource = @[content,problem,solution,work_content];
        [_rDetailTab reloadData];
    }
}

//上课记录审核
- (void)reportAuth:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showError:@"上课记录审核失败"];
    }
}
#pragma mark--UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return studentArray.count;
    }else{
        return dataSource.count+_work_imgArray.count;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIImageView*tView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_telephone.png"]];
    tView.frame=CGRectMake(0, 0, 20, 20);
    
    if(indexPath.section==0){
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"studentCell"];
        if(cell==nil){
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"studentCell"];
            cell.accessoryView=tView;
        }
        NSDictionary *dic=studentArray[indexPath.row];
        int state=[dic[@"call_state"] intValue];
        NSString *headStr=dic[@"head"];
        NSString*head=[NSString stringWithFormat:@"http://www.weiraoedu.com%@",[headStr substringFromIndex:1]];
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:@"icon_addteacher_head.png"]];
        cell.textLabel.text=dic[@"name"];
        switch (state) {//1准时，2迟到，3请假，4未到
            case 1:
                cell.detailTextLabel.text=@"准时";
                
                break;
            case 2:
                cell.detailTextLabel.text=@"迟到";
                break;
            case 3:
                cell.detailTextLabel.text=@"请假";
                cell.detailTextLabel.textColor=[UIColor colorWithRed:0.336 green:0.723 blue:1.000 alpha:1.000];
                break;
            case 4:
                cell.detailTextLabel.text=@"未到";
                cell.detailTextLabel.textColor=[UIColor redColor];
                break;
            default:
                break;
        }
        
        return cell;
    }else{
        UITableViewCell *cellWork=[tableView dequeueReusableCellWithIdentifier:@"studentWorkCell"];
        if(cellWork==nil){
            cellWork=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"studentWorkCell"];
            cellWork.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        ReportingDetailCell *cellRe = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cellRe) {
            cellRe = [[[NSBundle mainBundle] loadNibNamed:@"ReportingDetailCell" owner:self options:nil]lastObject];
        }
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        if(indexPath.row<=3){
            cellRe.titel.text = dataArray[indexPath.row];
            cellRe.content.text = dataSource[indexPath.row];
            cellRe.selectionStyle = UITableViewCellSelectionStyleNone;
            _rect = [cellRe.content.text boundingRectWithSize:CGSizeMake(cellRe.content.width, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                   attributes:attributes
                                                      context:nil];
            
            return cellRe;
        }else{
            UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width , 230)];
            //为UIImageView1添加点击事件
            UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick1:)];
            [img addGestureRecognizer:tapGestureRecognizer1];
            //让UIImageView和它的父类开启用户交互属性
            [img setUserInteractionEnabled:YES];
            [img sd_setImageWithURL:[NSURL URLWithString:_work_imgArray[indexPath.row-4]]];
            [cellWork.contentView addSubview:img];
            
            return cellWork;
        }
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        NSDictionary *dic=studentArray[indexPath.row];
        [self alertTelePhone:dic[@"phone"]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        return 44;
    }else{
        if(indexPath.row<=3){
            return _rect.size.height +65;
        }else{
            return 240;
        }
        
    }
    
}

- (void)handleEvent:(UIButton *)sender{
    if (sender.tag == 100) {
        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        IntroductionController *locationVc = [mainSB instantiateViewControllerWithIdentifier:@"IntroductionController"];
        locationVc.isAsk = 3;
        locationVc.askId = _dataId;
        [self.navigationController pushViewController:locationVc animated:YES];
    }else if (sender.tag == 101){
        [_management reportAuthInfoList:_dataId result:@"1" reason:@""];
    }else{
        ReporScoreController *reporVC = [[ReporScoreController alloc] init];
        reporVC.dataId = _dataId;
        [self.navigationController pushViewController:reporVC animated:YES];
    }
    
}

- (void)setUplabel:(CGRect)frame name:(NSString *)name{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = XN_COLOR_RED_MINT;
    label.text = name;
    label.center = CGPointMake(XN_WIDTH / 2, XN_HEIGHT - 65);
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

- (void)setUpButton:(CGRect)frame number:(NSInteger)number name:(NSString *)name{
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    _button.frame = frame;
    _button.backgroundColor = XN_COLOR_RED_MINT;
    [_button setTintColor:[UIColor whiteColor]];
    [_button addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
    _button.layer.cornerRadius = 5;
    _button.tag = number;
    _button.layer.masksToBounds = YES;
    [_button setTitle:name forState:UIControlStateNormal];
    [self.view addSubview:_button];
}
#pragma mark--getter
- (UITableView *)rDetailTab{
    if (!_rDetailTab) {
        _rDetailTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - 175)];
        _rDetailTab.tableFooterView = [[UIView alloc] init];
        _rDetailTab.backgroundColor = [UIColor colorWithWhite:0.843 alpha:1.000];
        _rDetailTab.dataSource = self;
        _rDetailTab.delegate = self;
        _rDetailTab.separatorStyle=NO;
    }
    return _rDetailTab;
}

//拨号
-(void)alertTelePhone:(NSString*)telephone{
    NSString*msg=[[NSString alloc] initWithFormat:@"是否拨号:%@",telephone];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle: UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //拨号
        NSString*te=[[NSString alloc] initWithFormat:@"tel://%@",telephone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:te]];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}


-(void)getCourseStudentInfo:(NSString *)courseId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/callInfo2?classId=%@",Basicurl,courseId];
    NSLog(@"%@",urlstr);
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        
        int i=[object[@"code"] intValue];
        switch (i) {
            case 0:
                XNLog(@"获取课程报告学生点名成功  %@",object);
                studentArray=object[@"data"];
                [_rDetailTab reloadData];
                break;
                
            default:
                XNLog(@"获取课程报告学生点名失败%@",object[@"msg"]);
                break;
        }
    } failureBlock:^(id object) {
        XNLog(@"获取课程报告学生点名失败%@",object[@"msg"]);
    }];
}

#pragma mark - 浏览大图点击事件
-(void)scanBigImageClick1:(UITapGestureRecognizer *)tap{
    NSLog(@"点击图片");
    UIImageView *clickedImageView = (UIImageView *)tap.view;
    [XWScanImage scanBigImageWithImageView:clickedImageView];
}


@end
