//  给 UIView 添加圆角
//
//  UIView+CornerRadius.h
//  CiYunApp
//
//  Created by CYKJ on 2019/6/19.
//  Copyright © 2019年 北京慈云科技有限公司. All rights reserved.


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct CYCornerInsets {
    CGFloat topLeft;
    CGFloat topRight;
    CGFloat bottomLeft;
    CGFloat bottomRight;
} CYCornerInsets;

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

@end

NS_ASSUME_NONNULL_END
