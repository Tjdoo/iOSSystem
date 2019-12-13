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
    // 方式 ①
//    CGPathRef path = CYPathCreateWithRoundedRect(self.bounds, cornerInsets);
//
//    CAShapeLayer * shape1 = [CAShapeLayer layer];
//    shape1.path = path;
//    self.layer.mask = shape1;
//    CGPathRelease(path);
    
    // 方式 ②。实际和 ① 是一样的，都是 CAShapeLayer + CGPath
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer * shape2 = [CAShapeLayer layer];
    shape2.frame = self.bounds;
    shape2.path = bezierPath.CGPath;
    self.layer.mask = shape2;
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

- (void)drawRectWithRoundedCornerRadius:(CYCornerInsets)cornerRadius
                                 borderWidth:(CGFloat)borderWidth
                             backgroundColor:(UIColor *)backgroundColor
                                borderCorlor:(UIColor *)borderColor
{
//    CGFloat halfBorderWidth = borderWidth / 2.0;
    CGFloat width = self.bounds.size.width, height = self.bounds.size.height;
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    // 左上角
    CGContextMoveToPoint(context, 0, cornerRadius.topLeft);
    CGContextAddArcToPoint(context, 0, 0, cornerRadius.topLeft, 0, cornerRadius.topLeft);
    // 右上角
    CGContextAddArcToPoint(context, width, 0, width, cornerRadius.topRight, cornerRadius.topRight);
    // 右下角
    CGContextAddArcToPoint(context, width, height, width - cornerRadius.bottomRight, height, cornerRadius.bottomRight);
    // 左下角
    CGContextAddArcToPoint(context, 0, height, 0, 0, cornerRadius.bottomLeft);
    CGContextClosePath(context);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
  
    self.layer.contents = (id)image.CGImage;
}

@end
