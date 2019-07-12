//
//  UIView+CornerRadius.m
//  CiYunApp
//
//  Created by CYKJ on 2019/6/19.
//  Copyright © 2019年 D. All rights reserved.


#import "UIView+CornerRadius.h"

@implementation UIView (CornerRadius)

- (void)addCornerRadius:(CYCornerInsets)cornerInsets
{
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    CGPathRef path = CYPathCreateWithRoundedRect(self.bounds, cornerInsets);
    shapeLayer.path = path;
    CGPathRelease(path);
    self.layer.mask = shapeLayer;
}

/**
  *  @brief  切圆角函数
  */
CGPathRef CYPathCreateWithRoundedRect(CGRect bounds, CYCornerInsets cornerRadius)
{
    const CGFloat minX = CGRectGetMinX(bounds);
    const CGFloat minY = CGRectGetMinY(bounds);
    const CGFloat maxX = CGRectGetMaxX(bounds);
    const CGFloat maxY = CGRectGetMaxY(bounds);
    
    const CGFloat topLeftCenterX = minX +  cornerRadius.topLeft;
    const CGFloat topLeftCenterY = minY + cornerRadius.topLeft;
    
    const CGFloat topRightCenterX = maxX - cornerRadius.topRight;
    const CGFloat topRightCenterY = minY + cornerRadius.topRight;
    
    const CGFloat bottomLeftCenterX = minX +  cornerRadius.bottomLeft;
    const CGFloat bottomLeftCenterY = maxY - cornerRadius.bottomLeft;
    
    const CGFloat bottomRightCenterX = maxX -  cornerRadius.bottomRight;
    const CGFloat bottomRightCenterY = maxY - cornerRadius.bottomRight;
    
    //虽然顺时针参数是YES，在iOS中的UIView中，这里实际是逆时针
    
    CGMutablePathRef path = CGPathCreateMutable();
    // 左上
    CGPathAddArc(path, NULL, topLeftCenterX, topLeftCenterY, cornerRadius.topLeft, M_PI, 3 * M_PI_2, NO);
    // 右上
    CGPathAddArc(path, NULL, topRightCenterX , topRightCenterY, cornerRadius.topRight, 3 * M_PI_2, 0, NO);
    // 右下
    CGPathAddArc(path, NULL, bottomRightCenterX, bottomRightCenterY, cornerRadius.bottomRight, 0, M_PI_2, NO);
    // 左下
    CGPathAddArc(path, NULL, bottomLeftCenterX, bottomLeftCenterY, cornerRadius.bottomLeft, M_PI_2,M_PI, NO);
    CGPathCloseSubpath(path);
    
    return path;
}

@end
