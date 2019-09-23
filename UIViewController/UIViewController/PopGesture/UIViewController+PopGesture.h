//
//  UIViewController+PopGesture.h
//  UIViewController
//
//  Created by CYKJ on 2019/8/26.
//  Copyright © 2019年 D. All rights reserved.


#import <UIKit/UIKit.h>

@interface UIViewController (PopGesture)

+ (void)popGestureClose:(UIViewController *)vc;
+ (void)popGestureOpen:(UIViewController *)vc;

@end
