//
//  RankingController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/5/27.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "RankingController.h"
#import "NavigationView.h"
#import "RankingCell.h"
#import "CZCover.h"
#import "ControllerManager.h"
#import "RightViewController.h"
#import "DrawerModel.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>

static NSString *identify1 = @"CELL";
static NSString *identify = @"RankingCell";
@interface RankingController ()<UITableViewDataSource, UITableViewDelegate, CZCoverDelegate>{
    NSArray *dataArray;
    NSArray *dataSource;
}
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UITableView *rankingTab;

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *gestureOfOoenningRightDrawer;
@property (nonatomic, strong) RightViewController *rightViewController;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, assign) BOOL isright;
@property (nonatomic, assign) BOOL shouldBeginOpenning;

@property (nonatomic, strong)CZCover *cover;
@property (nonatomic, strong)UITableView *czTabel;
@property (nonatomic, assign)NSInteger isdaily;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) DrawerModel *drawer;

@end

static const CGFloat maskAlpha_ = 0.6f;
static const CGFloat leftScale_ = 0.8f;
static const CGFloat wideX_ = 45;

@implementation RankingController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rank:) name:@"rankInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rightDrawe:) name:@"rightDraweInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"排名" leftButtonImage:nil];
    [self.view addSubview:navigationView];
    _rankingTab.delegate = self;
    _rankingTab.dataSource = self;
    _rankingTab.tableFooterView = [[UIView alloc] init];
    
    _isdaily = 10;
    dataArray = @[@"日常管理",@"考试排名"];
    _name = @"0";
    
    //    让分割线顶头
    if ([self.czTabel respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.czTabel setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.czTabel respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.czTabel setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    self.rightViewController = [[RightViewController alloc] init];
    _isright = YES;
    
    [self addChildViewController:self.rightViewController];
    
    [self.rightViewController didMoveToParentViewController:self];
    self.rightViewController.view.transform = CGAffineTransformMakeScale(leftScale_, leftScale_);
    [self.view addGestureRecognizer:self.gestureOfOoenningRightDrawer];
    
    _drawer = [[DrawerModel alloc] init];

    [_drawer rankInfoList:@"" groupId:@"" course:@""];
      
}
//排名
- (void)rank:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"][@"list"];
        [_rankingTab reloadData];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
}

//刷新排名
- (void)rightDrawe:(NSNotification *)bitice{
    [self closeRigthDrawer];
    _name = bitice.userInfo[@"number"];
    if ([bitice.userInfo[@"number"] isEqualToString:@"0"]){
        NSString *groupId = bitice.userInfo[@"enId"];
       [_drawer rankInfoList:@"1" groupId:groupId course:@""];
    }else{
        NSString *courseId = bitice.userInfo[@"enId"];
       [_drawer rankInfoList:@"2" groupId:@"" course:courseId];
    }
}
- (void)handleDrawerForLeft:(BOOL)isLeft open:(BOOL)isOpen {
    CGRect frame;
    CGFloat alpha;
    void (^completionBlock)(BOOL) = nil;//声明Block变量
    if (!isLeft && isOpen){
        //    打开右抽屉
        if (_isright == YES) {
            self.rightViewController.view.frame = CGRectMake(XN_WIDTH, 0, XN_WIDTH - wideX_, XN_HEIGHT);
            _isright = NO;
        }
        [self.view addSubview:self.maskView];
        [self.view addSubview:self.rightViewController.view];
        
        frame = CGRectMake(wideX_, 0, XN_WIDTH - wideX_, XN_HEIGHT);
        alpha = maskAlpha_;
    } else {
        // 关闭右抽屉
        frame = CGRectMake(XN_WIDTH, 0, XN_WIDTH - wideX_, XN_HEIGHT);
        alpha = 0;
        completionBlock = ^(BOOL flag) {
            [self.rightViewController.view removeFromSuperview];
            [self.maskView removeFromSuperview];
        };
    }
    
    //打开左抽屉//弹动效果
    [UIView animateWithDuration:0.7 delay:0.05 usingSpringWithDamping:3 initialSpringVelocity:4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.rightViewController.view.frame = frame;
        self.maskView.alpha = alpha;
    } completion:completionBlock];
}

//- 线性插值
- (CGFloat)interpolateFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent {
    return from + (to - from) * percent;
}
#pragma maek --interface methods
- (void)openRigthDrawer {
    [self handleDrawerForLeft:NO open:YES];
}
- (void)closeRigthDrawer {
    [self handleDrawerForLeft:NO open:NO];
}

- (void)respndsToRightGesture:(UIScreenEdgePanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.view addSubview:self.maskView];
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
        [self.view addSubview:self.rightViewController.view];
        CGPoint translation = [gesture translationInView:gesture.view];//在指定的坐标系中移动
        if (translation.x < 0) {
            CGFloat percent = translation.x / -250.f;
            if (percent > 1) {
                percent = 1;
            }
            CGFloat x = [self interpolateFrom:XN_WIDTH to:wideX_ percent:percent];
            CGFloat alpha = [self interpolateFrom:0 to:maskAlpha_ percent:percent];
            self.maskView.alpha = alpha;
            self.rightViewController.view.frame = CGRectMake(x, 0, XN_WIDTH - wideX_, XN_HEIGHT);
        }
    }else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled){
        CGPoint velocity = [gesture velocityInView:gesture.view];
        if (velocity.x < 0) {
            [self openRigthDrawer];
        }else {
            [self closeRigthDrawer];
        }
    }
}


- (void)tapOnMask:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint velocity = [gesture velocityInView:self.view];
        self.shouldBeginOpenning = (velocity.x > 0);
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        if (!self.shouldBeginOpenning) {
            return;
        }
            CGPoint translation = [gesture translationInView:gesture.view];//在指定的坐标系中移动
            if (translation.x > 0) {
                CGFloat percent = translation.x / 250.f;
                if (percent > 1) {
                    percent = 1;
                }
                CGFloat x = [self interpolateFrom:wideX_ to:XN_WIDTH percent:percent];
                CGFloat alpha = [self interpolateFrom:maskAlpha_ to:0 percent:percent];
                self.maskView.alpha = alpha;
                self.rightViewController.view.frame = CGRectMake(x, 0, XN_WIDTH - wideX_, XN_HEIGHT);
        }
        
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        if (!self.shouldBeginOpenning) {
            return;
        }
        
        // 如果速度向右，则打开抽屉，否则，关闭抽屉
        CGPoint velocity = [gesture velocityInView:self.view];
        
            if (velocity.x < 0) {
                [self openRigthDrawer];
            } else {
                [self closeRigthDrawer];
            }
        
        
    }
}
- (void)event:(UITapGestureRecognizer *)gesture{
    [self closeRigthDrawer];
}

- (UIScreenEdgePanGestureRecognizer *)gestureOfOoenningRightDrawer{
    if (!_gestureOfOoenningRightDrawer) {
        _gestureOfOoenningRightDrawer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(respndsToRightGesture:)];
        _gestureOfOoenningRightDrawer.edges = UIRectEdgeRight;
    }
    return _gestureOfOoenningRightDrawer;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XN_WIDTH, XN_HEIGHT)];
        _maskView.alpha = 0;
        _maskView.backgroundColor = [UIColor blackColor];
        [_maskView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnMask:)]];
        [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)]];
    }
    return _maskView;
}

#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        return dataArray.count;
    }else{
        return dataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify1];
        }
        cell.textLabel.text = dataArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.tintColor = XN_COLOR_RED_MINT;
        if (indexPath.row == 0) {
            if (_isdaily == 0) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                cell.textLabel.textColor = XN_COLOR_RED_MINT;
                
            }
        }else{
            if (_isdaily == 1) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                cell.textLabel.textColor = XN_COLOR_RED_MINT;
            }
        }
        
        return cell;
    }else{
        RankingCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RankingCell" owner:self options:nil]lastObject];
        }
        NSDictionary *dic = dataSource[indexPath.row];
        cell.number.text = dic[@"my_order"];
        NSString *title = @"";
        if ([_name isEqualToString:@"0"]) {
            title = [NSString stringWithFormat:@"社团:%@",dic[@"search_name"]];
        }else{
            title = [NSString stringWithFormat:@"课程:%@",dic[@"search_name"]];
        }
        cell.subject.text = title;
        NSString *pic = dic[@"head"];
        cell.pic.layer.cornerRadius = 25;
        cell.pic.layer.masksToBounds = YES;
        [cell.pic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"icon_addteacher_head.png"]];
        cell.name.text = dic[@"name"];
        cell.score.text = [NSString stringWithFormat:@"平均分:%@分",dic[@"score"]];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        NSArray *array = [tableView visibleCells];
        for (UITableViewCell *cell in array) {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.textLabel.textColor = [UIColor blackColor];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        UITableViewCell *cell=[self.czTabel cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        cell.textLabel.textColor = XN_COLOR_RED_MINT;
        _isdaily = indexPath.row;
        _pic.image = [UIImage imageNamed:@"dong.png"];
        _rankLabel.text = dataArray[_isdaily];
        NSDictionary *dic = [NSDictionary dictionary];
        if (_isdaily == 0) {
            dic = @{@"number":@"0"};
        }else{
            dic = @{@"number":@"1"};
        }
        [self openRigthDrawer];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openRigthDrawerInfoList" object:nil userInfo:dic];
        [_cover remove];
    }
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100) {
        return 35;
    }else{
        return 90;
    }
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
//排名
- (IBAction)ranking:(UIButton *)sender {
    // 弹出蒙板
    _cover = [CZCover show];
    _cover.delegate = self;
    [self.view addSubview:_cover];
    [_cover addSubview:self.czTabel];
    _pic.image = [UIImage imageNamed:@"top.png"];
}
//筛选
- (IBAction)screening:(UIButton *)sender {
    NSDictionary *dic = [NSDictionary dictionary];
    if (_isdaily == 10) {
        [MBProgressHUD showError:@"请先选择排名类型"];
    }else{
        if (_isdaily == 0) {
            dic = @{@"number":@"0"};
        }else{
            dic = @{@"number":@"1"};
        }
        [self openRigthDrawer];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openRigthDrawerInfoList" object:nil userInfo:dic];
    }
    
}

#pragma mark--getter
- (UITableView *)czTabel{
    if (!_czTabel) {
        _czTabel = [[UITableView alloc]initWithFrame:CGRectMake(0, 114, XN_WIDTH, 70)];
        _czTabel.tableFooterView = [[UIView alloc] init];
        _czTabel.dataSource = self;
        _czTabel.delegate = self;
        _czTabel.tag = 100;
    }
    return _czTabel;
}
@end
