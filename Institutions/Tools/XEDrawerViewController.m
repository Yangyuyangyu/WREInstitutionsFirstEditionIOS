//
//  XEDrawerViewController.m
//  DeepBreathing
//
//  Created by rimi on 15/12/15.
//  Copyright © 2015年 肖恩. All rights reserved.
//

#import "XEDrawerViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "ControllerManager.h"
@interface XEDrawerViewController ()<UITabBarDelegate>
@property (nonatomic, strong) UIViewController *mainController;
@property (nonatomic, strong) UIViewController *leftViewConroller;
@property (nonatomic, strong) UIViewController *rightViewController;
//    屏幕边界的响应
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *gestureOfOoenningLeftDrawer;

@property (nonatomic, strong) UIView *maskView;
/**
 *  是否应该打开抽屉，当用户的手指一开始向左的时候，不应该再响应手势的任何状态了
 */
@property (nonatomic, assign) BOOL shouldBeginOpenning;

@property (nonatomic, assign) BOOL judge;

@property (nonatomic, assign) BOOL isright;

@property (nonatomic, assign) BOOL isleft;

- (void)initializeAppearance;
- (void)handleDrawerForLeft:(BOOL)isLeft open:(BOOL)isOpen;
- (CGFloat)interpolateFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent;
@end

static const CGFloat maskAlpha_ = 0.6f;
static const CGFloat leftScale_ = 0.8f;
static const CGFloat mainX_ = 0;
static const CGFloat wideX_ = 45;

@implementation XEDrawerViewController

#pragma mark-- initialize
- (instancetype)initWithMainController:(UIViewController *)mainController leftViewConroller:(UIViewController *)leftViewConroller rightViewController:(UIViewController *)rightViewController {
    self = [super init];
    if (self) {
        self.mainController = mainController;
        self.leftViewConroller = leftViewConroller;
        self.rightViewController = rightViewController;
    }
    return self;
}

- (instancetype)initWithMainController:(UIViewController *)MainController leftViewConroller:(UIViewController *)leftViewConroller {
    return [self initWithMainController:MainController leftViewConroller:leftViewConroller rightViewController:nil];
}

#pragma mark --life cycle

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeAppearance];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openLeft:) name:@"openLeftDrawerInfoList" object:nil];
}

//获取首页图标
- (void)openLeft:(NSNotification *)bitice{
    [self openLeftDrawer];
}
#pragma mark --private methods
- (void)initializeAppearance {
    [self.view addGestureRecognizer:self.gestureOfOoenningLeftDrawer];
    _isright = YES;
    _isleft = YES;
    ShareS.isOpen = NO;
    
//    加载左抽屉
    if (self.leftViewConroller) {
        [self addChildViewController:self.leftViewConroller];
        [self.leftViewConroller didMoveToParentViewController:self];
        self.leftViewConroller.view.transform = CGAffineTransformMakeScale(leftScale_, leftScale_);
    }
//    如果右抽屉在加载右抽屉
    if (self.rightViewController) {
        [self addChildViewController:self.rightViewController];
        
        [self.rightViewController didMoveToParentViewController:self];
        self.rightViewController.view.transform = CGAffineTransformMakeScale(leftScale_, leftScale_);
    }
//    加载主控制器
    [self addChildViewController:self.mainController];
    [self.view addSubview:self.mainController.view];
    [self.mainController didMoveToParentViewController:self];
   
    
}



- (void)handleDrawerForLeft:(BOOL)isLeft open:(BOOL)isOpen {
    CGRect frame;
    CGFloat alpha;
    void (^completionBlock)(BOOL) = nil;//声明Block变量
    if (isLeft && isOpen) {
        _judge = YES;
//        打开左抽屉
        if (_isleft == YES) {
            self.leftViewConroller.view.frame = CGRectMake(-(XN_WIDTH - wideX_), 0, XN_WIDTH - wideX_, XN_HEIGHT);
            _isleft = NO;
        }
        [self.view addSubview:self.leftViewConroller.view];
        [self.mainController.view addSubview:self.maskView];
        frame = CGRectMake(mainX_, 0, XN_WIDTH - wideX_, XN_HEIGHT);
        alpha = maskAlpha_;
    }else if (isLeft && !isOpen){
//    关闭左抽屉
        frame = CGRectMake(-(XN_WIDTH - wideX_), 0, XN_WIDTH - wideX_, XN_HEIGHT);
        alpha = 0;
        completionBlock = ^(BOOL flag){
            [self.leftViewConroller.view removeFromSuperview];
            [self.maskView removeFromSuperview];
        };
    }else if (!isLeft && isOpen){
//    打开右抽屉
        _judge = NO;
        if (_isright == YES) {
            self.rightViewController.view.frame = CGRectMake(XN_WIDTH, 0, XN_WIDTH - wideX_, XN_HEIGHT);
        }
        [self.view addSubview:self.rightViewController.view];
        [self.mainController.view addSubview:self.maskView];
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
        self.leftViewConroller.view.frame = frame;
        self.rightViewController.view.frame = frame;
        self.maskView.alpha = alpha;
    } completion:completionBlock];

    

}

//- 线性插值
- (CGFloat)interpolateFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent {
    return from + (to - from) * percent;
}

#pragma maek --interface methods
- (void)openLeftDrawer {
    [self handleDrawerForLeft:YES open:YES];
}
- (void)closeLeftDrawer {
    [self handleDrawerForLeft:YES open:NO];
}
- (void)openRigthDrawer {
    [self handleDrawerForLeft:NO open:YES];
}
- (void)closeRigthDrawer {
    [self handleDrawerForLeft:NO open:NO];
}

#pragma mark --callback/action
//translationInView： 该方法返回在横坐标上、纵坐标上拖动了多少像素
//velocityInView：在指定坐标系统中pan gesture拖动的速度
- (void)respndsToLeftGesture:(UIScreenEdgePanGestureRecognizer *)gesture {
    if (ShareS.isOpen == NO) {
        if (gesture.state == UIGestureRecognizerStateBegan) {
            [self.mainController.view addSubview:self.maskView];
        }else if (gesture.state == UIGestureRecognizerStateChanged) {
            _isleft = NO;
            [self.view addSubview:self.leftViewConroller.view];
            CGPoint translation = [gesture translationInView:gesture.view];//在指定的坐标系中移动
            if (translation.x > 0) {
                CGFloat percent = translation.x / 250.f;
                if (percent > 1) {
                    percent = 1;
                }
                CGFloat x = [self interpolateFrom:-(XN_WIDTH - wideX_) to:mainX_ percent:percent];
                CGFloat alpha = [self interpolateFrom:0 to:maskAlpha_ percent:percent];
                self.maskView.alpha = alpha;
                self.leftViewConroller.view.frame = CGRectMake(x, 0, XN_WIDTH - wideX_, XN_HEIGHT);
            }
        }else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled){
            CGPoint velocity = [gesture velocityInView:gesture.view];
            if (velocity.x > 0) {
                [self openLeftDrawer];
            }else {
                [self closeLeftDrawer];
            }
        }
    }else{
        return;
    }
    
}


- (void)tapOnMask:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint velocity = [gesture velocityInView:self.view];
        if (_judge == YES) {
            self.shouldBeginOpenning = (velocity.x < 0);
        }else{
            self.shouldBeginOpenning = (velocity.x > 0);
        }
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        if (!self.shouldBeginOpenning) {
            return;
        }
        if (_judge == YES) {
            // 控制抽屉vc的动画进程
            CGPoint translation = [gesture translationInView:gesture.view];
            if (translation.x < 0) {
                CGFloat percent = translation.x / -250.f;
                if (percent > 1) {
                    percent = 1;
                }
                CGFloat x = [self interpolateFrom:0 to:-(XN_WIDTH - wideX_) percent:percent];
                CGFloat alpha = [self interpolateFrom:maskAlpha_ to:0 percent:percent];
                self.maskView.alpha = alpha;
                self.leftViewConroller.view.frame = CGRectMake(x, 0, XN_WIDTH - wideX_, XN_HEIGHT);
            }
        }else{
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
        }
        
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        if (!self.shouldBeginOpenning) {
            return;
        }
        
        // 如果速度向右，则打开抽屉，否则，关闭抽屉
        CGPoint velocity = [gesture velocityInView:self.view];
        if (_judge == YES) {
            if (velocity.x > 0) {
                [self openLeftDrawer];
            } else {
                [self closeLeftDrawer];
            }
        }else{
            if (velocity.x < 0) {
                [self openRigthDrawer];
            } else {
                [self closeRigthDrawer];
            }
        }
        
        
    }
}

- (void)event:(UITapGestureRecognizer *)gesture{
    if (_judge == YES) {
        [self closeLeftDrawer];
    }else{
        [self closeRigthDrawer];
    }
    
}
#pragma mark --getter setter

- (UIScreenEdgePanGestureRecognizer *)gestureOfOoenningLeftDrawer {
    if (!_gestureOfOoenningLeftDrawer) {
        _gestureOfOoenningLeftDrawer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(respndsToLeftGesture:)];
        _gestureOfOoenningLeftDrawer.edges = UIRectEdgeLeft;//设置屏幕边缘
        
    }
    return _gestureOfOoenningLeftDrawer;
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



@end
