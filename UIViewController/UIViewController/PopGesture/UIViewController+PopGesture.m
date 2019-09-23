//
//  UIViewController+PopGesture.m
//  UIViewController
//
//  Created by CYKJ on 2019/8/26.
//  Copyright © 2019年 D. All rights reserved.


#import "UIViewController+PopGesture.h"

@implementation UIViewController (PopGesture)
/**
  *  @brief   禁用侧滑返回手势
  */
+ (void)popGestureClose:(UIViewController *)vc
{
    if ([vc.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        // 这里对添加到右滑视图上的所有手势禁用
        for (UIGestureRecognizer * popGesture in vc.navigationController.interactivePopGestureRecognizer.view.gestureRecognizers) {
            popGesture.enabled = NO;
        }
        // 若开启全屏右滑，不能再使用下面方法，请对数组进行处理
        //VC.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

/**
  *  @brief   启用侧滑返回手势
  */
+ (void)popGestureOpen:(UIViewController *)vc
{
    if ([vc.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        // 这里对添加到右滑视图上的所有手势启用
        for (UIGestureRecognizer * popGesture in vc.navigationController.interactivePopGestureRecognizer.view.gestureRecognizers) {
            popGesture.enabled = YES;
        }
        //若禁用全屏右滑，不能再使用下面方法，请对数组进行处理
        //VC.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

@end
