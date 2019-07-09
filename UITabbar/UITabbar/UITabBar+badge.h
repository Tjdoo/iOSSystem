//
//  UITabBar+badge.h
//  UITabbar
//
//  Created by D on 15/12/21.
//  Copyright © 2015年 D. All rights reserved.


#import <UIKit/UIKit.h>

@interface UITabBar (badge)

/**
  *  @brief   显示小红点
  *  @param    index   item的序号
  */
- (void)showBadgeOnItemIndex:(NSInteger)index;

/**
  *  @brief   隐藏小红点
  *  @param   index    item的序号
  */
- (void)hideBadgeOnItemIndex:(NSInteger)index;

@end
