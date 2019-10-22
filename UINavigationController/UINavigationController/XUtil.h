//
//  XUtil.h
//  UINavigationController
//
//  Created by CYKJ on 2019/10/18.
//  Copyright © 2019年 D. All rights reserved.


#import <UIKit/UIKit.h>

@interface XUtil : NSObject

/**
  *  @brief   设置导航栏的颜色
  */
+ (void)setNavBar:(UINavigationBar *)bar withColor:(UIColor *)color;
/**
  *  @brief   设置导航栏的透明度
  */
+ (void)setNavBar:(UINavigationBar *)bar bgAlpha:(CGFloat)alpha;
/**
  *  @brief   隐藏导航栏底部线条
  */
+ (void)setNavBar:(UINavigationBar *)bar bottomLineHidden:(BOOL)isHidden;

@end
