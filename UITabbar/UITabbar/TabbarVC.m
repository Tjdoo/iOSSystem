//
//  TabbarVC.m
//  UITabbar
//
//  Created by CYKJ on 2019/6/10.
//  Copyright © 2019年 D. All rights reserved.


#import "TabbarVC.h"
#import "UITabBar+badge.h"


#undef UIColorFromRGB
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

typedef NS_ENUM(NSInteger, TabbarItem) {
    TabbarItem_HomePage = 0, // 首页
    TabbarItem_Message,      // 消息
    TabbarItem_Member,       // 会员
};




@interface TabbarVC () <UITabBarControllerDelegate>
{
    BOOL __shouldSelectVC;
}
@property (nonatomic, strong) CABasicAnimation * animation;
@property (nonatomic, strong) NSDate * lastDate; // 记录上一次点击的时间

@end


@implementation TabbarVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    
    [self updateTabbar];
}

- (void)updateTabbar
{
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.titlePositionAdjustment = UIOffsetMake(0, -3.5);
        
        NSDictionary * dict = @{ NSForegroundColorAttributeName : UIColorFromRGB(0x10CFA3),
                                 NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Regular" size:11] };
        // 设置 tabbarItem 选中状态下的文字颜色（避免被系统默认渲染）
        [obj setTitleTextAttributes:dict forState:UIControlStateSelected];
    }];
    
    // 显示红点
    [self.tabBar showBadgeOnItemIndex:1];
    
    // 去除 tabbar 顶部线条。https://www.jianshu.com/p/fbc336ea3657
    self.tabBar.backgroundImage = [[UIImage alloc] init];
    self.tabBar.shadowImage = [[UIImage alloc] init];
    
    // 设置背景图片。注意：如果直接设置 backgroundImage 为 @"TabbarBg"，顶部线条还会存在，因为 iOS 系统新创建了一个 UIImageView
    // https://www.jianshu.com/p/59251b2e0f1c
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"TabbarBg"];
    CGRect rect = self.tabBar.bounds;
    rect.origin.y = rect.size.height - 67;
    rect.size.height = 67;
    imageView.frame = rect;
    self.tabBar.opaque = YES;
    [self.tabBar insertSubview:imageView atIndex:0];
}


#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return __shouldSelectVC;
}

/**
  *  @brief   UITabbarController 在点击时，代码流程是：tabBar:didSelectItem:  -》tabBarController:shouldSelectViewController: -》子视图 viewWillAppear:  -》tabBarController:didSelectViewController:
 
             当未执行子视图 viewWillAppear 时，tabbarItem 上的图片实际上还没有更换，此时进行抖动动画，是无效的。此时有两种选择：
 
             1、在子视图的 viewWillAppear: 中处理动画；
             2、在 tabBarController:didSelectViewController: 代理方法中处理动画；
 
             方案 1 的问题在于：.selectIndex = 2 这种方式也会调用子视图的 viewWillAppear: 。所以抖动动画放 tabBarController:didSelectViewController: 代理方法中。
  */
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UIControl * tabBarButton = [viewController.tabBarItem valueForKey:@"view"];
    
    if (tabBarButton) {
        [tabBarButton.layer addAnimation:self.animation forKey:nil];
        
        // 只抖动图标，不抖动文本
//        UIImageView * tabBarSwappableImageView = [tabBarButton valueForKey:@"info"];
//        if (tabBarSwappableImageView) {
//            [tabBarSwappableImageView.layer addAnimation:self.animation forKey:nil];
//        }
    }
}


#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSUInteger tabIndex = [tabBar.items indexOfObject:item];

    // 点击当前 item
    if (tabIndex == self.selectedIndex) {
        
        __shouldSelectVC = NO;

        if (tabIndex == TabbarItem_Member) {  // “会员”
            
            NSDate * date = [NSDate date];
            
            // 处理双击事件
            if (date.timeIntervalSince1970 - _lastDate.timeIntervalSince1970 < 0.5) {
                // 发送通知，“会员”界面可以做刷新数据处理
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NewsDoubleTapedKey"
                                                                    object:nil];
            }
            _lastDate = date;
        }
    }
    else {
        __shouldSelectVC = YES;
    }
}


#pragma mark - GET
/**
  *  @brief   图标动画
  */
- (CABasicAnimation *)animation
{
    if (_animation == nil) {
        _animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        _animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        _animation.duration    = 0.2;
        _animation.repeatCount = 1;
        _animation.fromValue   = @0.7;
        _animation.toValue     = @1.0;
    }
    return _animation;
}

@end
