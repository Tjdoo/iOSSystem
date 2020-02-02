//  处理与侧滑返回手势冲突
//
//  GestureScrollView.h
//  CiYunDoctor
//
//  Created by CYD on 2018/11/16.
//  Copyright © 2018年 centrin. All rights reserved.


#import <UIKit/UIKit.h>

@interface GestureScrollView : UIScrollView

@property (nonatomic, assign) CGFloat leftMarginPercent;  // 响应范围。取值：0.3 ~ 1，1 为全屏响应。默认为 0.3

@end
