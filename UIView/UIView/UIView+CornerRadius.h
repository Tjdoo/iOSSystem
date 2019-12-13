//  给 UIView 添加圆角
//
//  UIView+CornerRadius.h
//  CiYunApp
//
//  Created by CYKJ on 2019/6/19.
//  Copyright © 2019年 D. All rights reserved.


#import <UIKit/UIKit.h>

typedef struct CYCornerInsets {
    CGFloat topLeft;
    CGFloat topRight;
    CGFloat bottomLeft;
    CGFloat bottomRight;
} CYCornerInsets;

// 注意 CG_INLINE
CG_INLINE CYCornerInsets CYCornerInsetsMake(CGFloat topLeft,
                                  CGFloat topRight,
                                  CGFloat bottomLeft,
                                  CGFloat bottomRight)
{
    return (CYCornerInsets){ topLeft, topRight, bottomLeft, bottomRight };
}



/// https://www.jianshu.com/p/164106443353
@interface UIView (CornerRadius)

- (void)addCornerRadius:(CYCornerInsets)cornerInsets;

- (void)drawRectWithRoundedCornerRadius:(CYCornerInsets)cornerRadius
                            borderWidth:(CGFloat)borderWidth
                        backgroundColor:(UIColor *)backgroundColor
                           borderCorlor:(UIColor *)borderColor;

@end
