//
//  RootNav.m
//  UIViewController
//
//  Created by CYKJ on 2019/8/26.
//  Copyright © 2019年 D. All rights reserved.
//

#import "RootNav.h"

@interface RootNav ()

@end

@implementation RootNav

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 设置右滑返回手势的代理为自身
    __weak typeof(self) weakself = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = (id)weakself;
    }
}


#pragma mark - UIGestureRecognizerDelegate
/**
  *  @brief   这个方法是在手势将要激活前调用：返回YES允许右滑手势的激活，返回NO不允许右滑手势的激活
  */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        // 屏蔽调用 rootViewController 的滑动返回手势，避免右滑返回手势引起死机问题
        if (self.viewControllers.count < 2 ||
            self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }
    // 这里就是非右滑手势调用的方法啦，统一允许激活
    return YES;
}

@end
