//
//  UIImage+CornerRadius.h
//  UIImage
//
//  Created by CYKJ on 2019/11/27.
//  Copyright © 2019年 D. All rights reserved.


#import <UIKit/UIKit.h>

@interface UIImage (CornerRadius)

- (UIImage *)cgContextMakeCornerRadius:(CGFloat)radius;
- (UIImage *)bezierPathMakeCornerRadius:(CGFloat)radius;
- (UIImage *)customMakeCornerRadius:(CGFloat)radius;

@end
