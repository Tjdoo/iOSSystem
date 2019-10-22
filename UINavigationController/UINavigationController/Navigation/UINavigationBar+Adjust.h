//
//  UINavigationBar+Adjust.h
//  Demo
//
//  Created by D on 2018/3/23.
//  Copyright © 2018年 D. All rights reserved.


#import <UIKit/UIKit.h>

/**
  *  @brief   调整 iOS11 及之后的版本，leftBarButtonItems、rightBarButtonItems 与屏幕的间距。
  *
  *                   系统默认的间距为 { 0, 16, 0, 16 }
  */
@interface UINavigationBar (Adjust)

@property (nonatomic, assign) CGFloat lMarginToScreen;  // 左侧与屏幕距离
@property (nonatomic, assign) CGFloat rMarginToScreen;  // 右侧与屏幕距离

@end
