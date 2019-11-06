//
//  ShadowView.m
//  Quartz2D
//
//  Created by CYKJ on 2019/11/5.
//  Copyright © 2019年 D. All rights reserved.


#import "ShadowView.h"

@implementation ShadowView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, UIColor.darkGrayColor.CGColor);
    CGContextSetFillColorWithColor(context, UIColor.whiteColor.CGColor);
    CGContextFillRect(context, rect);
    CGContextStrokeRect(context, rect);
    
    CGContextAddArc(context, self.bounds.size.width/2, self.bounds.size.height/2, 50, 0, M_2_PI, NO);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 5);
    // context 绘制画板；offset 阴影偏移量，参考 context 的坐标系；blur 非负数，决定阴影的模糊程度
    CGContextSetShadow(context, CGSizeMake(4.0, 4.0), 1.0);
    
    CGContextStrokePath(context);
}

@end
