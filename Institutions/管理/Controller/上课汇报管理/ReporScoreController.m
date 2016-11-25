//
//  ReporScoreController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/7/6.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ReporScoreController.h"
#import "NavigationView.h"
#import "ManagementModel.h"
#import "ReuseCell.h"

static NSString *identify = @"CELL";
@interface ReporScoreController ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *dataSource;
    NSArray *score_info;
    NSMutableArray *mutaArray;
    NSMutableDictionary *showDic;//用来判断分组展开与收缩的
}
@property (nonatomic, strong) UITableView *scoreTab;
@property (nonatomic, strong) ManagementModel *management;

@property (nonatomic, strong) UIImageView *image;

@end

@implementation ReporScoreController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scoreInfo:) name:@"scoreInfoInfoList" object:nil];
    
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"上课评分记录" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:self.scoreTab];
    
    mutaArray = [NSMutableArray array];
    _management = [[ManagementModel alloc] init];
    [_management scoreInfoInfoList:_dataId];
}
//打分
- (void)scoreInfo:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        for (int i = 0; i < dataSource.count; i ++) {
            [mutaArray insertObject:@"" atIndex:i];
        }
        [_scoreTab reloadData];
    }else{
        [MBProgressHUD showError:@"上课记录审失败"];
    }
}

#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataSource.count == 0) {
        return 0;
    }else{
        score_info = dataSource[section][@"score_info"];
        return score_info.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if(cell==NULL){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset=UIEdgeInsetsZero;
        cell.clipsToBounds = YES;
    }
    score_info = dataSource[indexPath.section][@"score_info"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = [NSString stringWithFormat:@"%@:%@分",score_info[indexPath.row][@"name"],score_info[indexPath.row][@"score"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([showDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]]) {
        return 30;
    }
    return 0;
}

//section头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
//section头部显示的内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XN_WIDTH, 40)];
    header.backgroundColor = [UIColor colorWithWhite:0.843 alpha:1.000];
    _image = [[UIImageView alloc] initWithFrame:CGRectMake(XN_WIDTH - 23, 7, 16, 16)];
    NSString *str = mutaArray[section];
    if (str.length == 0) {
        _image.image = [UIImage imageNamed:@"icon_next_gray (2).png"];
    }else{
        _image.image = [UIImage imageNamed:@"icon_down_gray.png"];
    }
    [header addSubview:_image];
    
    UILabel *score = [[UILabel alloc] initWithFrame:CGRectMake(XN_WIDTH - 75, 5, 50, 20)];
    score.text = [NSString stringWithFormat:@"%@分",dataSource[section][@"average"]];
    score.textColor = XN_COLOR_RED_MINT;
    score.font = [UIFont systemFontOfSize:15];
    score.textAlignment = NSTextAlignmentRight;
    [header addSubview:score];
    
    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 200, 20)];
    myLabel.text = [NSString stringWithFormat:@"%@",dataSource[section][@"name"]];
    [header addSubview:myLabel];
    
    
    // 单击的 Recognizer ,收缩分组cell
    header.tag = section;
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1; //点击的次数 =1:单击
    [singleRecognizer setNumberOfTouchesRequired:1];//1个手指操作
    [header addGestureRecognizer:singleRecognizer];//添加一个手势监测；
    
    return header;
}

#pragma mark 展开收缩section中cell 手势监听
-(void)SingleTap:(UITapGestureRecognizer*)recognizer{
    NSInteger didSection = recognizer.view.tag;
    
    if (!showDic) {
        showDic = [[NSMutableDictionary alloc]init];
    }
    
    NSString *key = [NSString stringWithFormat:@"%ld",(long)didSection];
    [mutaArray removeObjectAtIndex:didSection];
    if (![showDic objectForKey:key]) {
        [showDic setObject:@"1" forKey:key];
        [mutaArray insertObject:@"en" atIndex:didSection];
    }else{
        [mutaArray insertObject:@"" atIndex:didSection];
        [showDic removeObjectForKey:key];
    }
    
    [self.scoreTab reloadSections:[NSIndexSet indexSetWithIndex:didSection] withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark--getter
- (UITableView *)scoreTab{
    if (!_scoreTab) {
        _scoreTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - 64)];
        _scoreTab.tableFooterView = [[UIView alloc] init];
        _scoreTab.backgroundColor = [UIColor colorWithWhite:0.843 alpha:1.000];
        _scoreTab.dataSource = self;
        _scoreTab.delegate = self;
    }
    return _scoreTab;
}

@end
