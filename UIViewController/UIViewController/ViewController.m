//
//  ViewController.m
//  UIViewController
//
//  Created by CYKJ on 2019/6/26.
//  Copyright © 2019年 D. All rights reserved.


#import "ViewController.h"
#import "ChildVC.h"


#undef UIColorFromRGB
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()
{
    BOOL __isWhiteStatusBar;
    
    __block CGFloat __navBarAlphaValue;
}
@property (nonatomic, strong) ChildVC * childVC;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addChildViewControllerExample];
}

/**
  *  @brief   状态栏样式
  */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return __isWhiteStatusBar ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

/**
  *  @brief   测试返回手势
  */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIViewController * nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NextVC_SBID"];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 33)];
    label.text = @"Custom Back";
    label.backgroundColor = [UIColor orangeColor];
    // 导致系统返回按钮被“覆盖”，侧滑返回手势失效
    // 方式 ①：RootNav 中处理手势的响应
//    nextVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:label];
//    nextVC.navigationItem.leftBarButtonItems = nil;
//    nextVC.navigationItem.hidesBackButton = YES;
    // 是否同时显示返回按钮
//    nextVC.navigationItem.leftItemsSupplementBackButton = YES;
    
    // 方式 ②：修改系统的返回按钮样式，并保留了右滑返回手势
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Custom Back"
                                                                          style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(pop)];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *  @brief   iOS 5.0 ~ 添加子视图。
 *    好处：
             1、页面中的逻辑更加分明了。相应的 view 对应相应的 ViewController。
             2、当某个子 view 没有显示时，将不会被 Load，减少了内存的使用。
             3、当内存紧张时，没有 Load 的 view 将被首先释放，优化了程序的内存释放机制
 */
- (void)addChildViewControllerExample
{
    self.childVC = (ChildVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ChildVC_SBID"];
    [self addChildViewController:_childVC];
    [_childVC didMoveToParentViewController:self];
    [self.view addSubview:_childVC.view];
    
    /* childViewControllers = (
                    "<ChildVC: 0x7f8af1d0f450>"
               )
           */
    NSLog(@"childViewControllers = %@", self.childViewControllers);
    
    [self addChildViewController:_childVC];
    [self.view addSubview:_childVC.view];

    /* childViewControllers = (
                      "<ChildVC: 0x7f8af1d0f450>"
                )
           */
    // 当要添加的子视图控制器已经包含在视图控制器容器中，那么相当于先从父视图控制器中删除，然后重新添加到父视图控制器中。https://blog.csdn.net/allangold/article/details/78850695
    NSLog(@"childViewControllers = %@", self.childViewControllers);

    _childVC.view.frame = CGRectMake(10, 200, [UIScreen mainScreen].bounds.size.width - 20, 200);
    
    __typeof(self) __weak weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __typeof(weakSelf) __strong strongSelf = weakSelf;
        [strongSelf removeChildControllerExample];
    });
    
}

- (void)removeChildControllerExample
{
    [_childVC willMoveToParentViewController:nil];
    [_childVC removeFromParentViewController];
    [_childVC.view removeFromSuperview];
    _childVC = nil;
}


#pragma mark - UIScrollViewDeleage
/**
  *  @brief   导航栏透明处理
  */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY >= 0) {
        __navBarAlphaValue = MIN(1.0, offsetY / [self naviBarHeight]);
        
//        _naviBarTitleView.alpha = 1.0f;
//        _rightBlackNavigationBgView.alpha = 1.0f;
//        _naviBarGradientBgView.alpha = 1.0f;
    }
    else {
        __navBarAlphaValue = 0.0;
        
        CGFloat upDistancePercent = 1 + offsetY / [self naviBarHeight];
        
        // 下拉时，隐藏导航栏
//        _naviBarTitleView.alpha = upDistancePercent;
//        _rightWhiteNavigationBgView.alpha = upDistancePercent;  // 当 offsetY < 0 时，导航栏为白色样式
//        _naviBarGradientBgView.alpha = upDistancePercent;
    }
    
    [self __switchNaviStyleByAlpha:@(__navBarAlphaValue)];
}

- (void)__switchNaviStyleByAlpha:(NSNumber *)alpha
{
    CGFloat value = (alpha != nil) ? alpha.floatValue : 0.0f;
    
    if (value >= 0.7) {
        __isWhiteStatusBar = NO;
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//        self.hmoNameLabel.textColor = UIColorFromRGB(0x333333);
        self.navigationController.navigationBar.titleTextAttributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor blackColor]};
//        self.naviArrowImageView.image = __downArrowIcon;
//        self.rightWhiteNavigationBgView.hidden = YES;
//        self.rightBlackNavigationBgView.hidden = NO;
    }
    else {
        __isWhiteStatusBar = YES;
//        self.naviArrowImageView.image = __upArrowIcon;
//        self.rightWhiteNavigationBgView.hidden = NO;
//        self.rightBlackNavigationBgView.hidden = YES;
        
//        if (!__isLockNaviTitle) {
//            self.hmoNameLabel.textColor = UIColorFromRGB(0xffffff);
//        }
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationItem.title = nil;
    }
    
//    [CYKJXUtil setNavBar:self.navigationController.navigationBar bgAlpha:value backImg:(value < 0.7)];
    
    // [self setNeedsStatusBarAppearanceUpdate];   方法更耗时，导致界面有点卡顿。BarStyle 作用于 NavigationBar，同时对 statusBar 有影响
    if (__isWhiteStatusBar) {
        self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    }
    else {
        self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    }
}


#pragma mark - Tool

- (CGFloat)naviBarHeight
{
    /*   1、状态栏显示：刘海屏  44    非刘海屏   20
                2、状态栏隐藏：0
     
                当状态栏隐藏时，导航栏会贴着手机顶部，且导航栏一直是 44pt 的高度
            */
    return [[UIApplication sharedApplication] statusBarFrame].size.height + 44;
}

static BOOL __safeAreaInsetsDidChange = NO;
- (void)viewSafeAreaInsetsDidChange
{
    __safeAreaInsetsDidChange = YES;
    
    [super viewSafeAreaInsetsDidChange];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (__safeAreaInsetsDidChange) {
        
        if (@available(iOS 11.0, *)) {
            UIEdgeInsets safeAreaInsets = self.view.safeAreaInsets;
            CGFloat height = 44.0; // 导航栏原本的高度，通常是44.0
            height += safeAreaInsets.top > 0 ? safeAreaInsets.top : 20.0; // 20.0 是 statusbar的高度
        }
        else {
            
        }
    }
}

/**
  *  @brief  隐藏 X 以后设备的 HomeIndicator。此方法是在控制器 push 之后就会回调，屏幕若无交互事件响应时，延迟 2 秒左右会自动隐藏。
  */
- (BOOL)prefersHomeIndicatorAutoHidden
{
    return YES;
}

@end
