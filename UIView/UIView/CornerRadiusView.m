//
//  CornerRadiusView.m
//  UIView
//
//  Created by CYKJ on 2019/10/28.
//  Copyright © 2019年 D. All rights reserved.


#import "CornerRadiusView.h"

@implementation CornerRadiusView

/*!
    CGContextSetShadowWithColor() 一定要在 CGContextBeginTransparencyLayer() 透明层开始之前。
 
    因为 CGContextBeginTransparencyLayer 与 CGContextEndTransparencyLayer 之间是一个整体，你可以把整个看做是一个对象，阴影作用在整个对象上面（如图-0），如果写在 CGContextBeginTransparencyLayer 之后，那么就变成内部组合对象每一个都有阴影（如图-1），视图层叠处也有阴影。
 
    Quartz 透明层可以理解为一个对象组，对象组里面又有多个对象。效果都会作用于对象组。Quartz 为每一个上下文维护一个透明层栈。可以嵌套。当 CGContextEndTransparencyLayer 调用后，Quartz 将对象放入上下文。并使用上下文的全局 alpha 值、阴影状态、剪裁区域作用域对象组。
 
     作者：清风沐沐
     链接：https://www.jianshu.com/p/8861f9eeb9c6
 */
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 10, [UIColor yellowColor].CGColor);
    // 开始透明层
//    CGContextBeginTransparencyLayer(context, NULL);
    // 绘制组合对象
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(100, 100, 100, 100));
    CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(150, 50, 100, 100));
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(150, 100, 100, 100));
    // 结束
//    CGContextEndTransparencyLayer(context);
}

@end
