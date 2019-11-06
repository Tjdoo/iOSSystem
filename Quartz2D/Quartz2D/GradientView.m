//
//  GradientView.m
//  Quartz2D
//
//  Created by CYKJ on 2019/11/5.
//  Copyright © 2019年 D. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

#pragma mark - CGGradient
/**
 *  @brief   因为 Quartz 为我们计算渐变，使用一个 CGGradient 对象来创建和绘制一个轴向/径向渐变则更直接，只需要以下几步：
 
        1> 创建一个CGGradient对象，提供一个颜色空间，一个饱含两个或更多颜色组件的数组，一个包含两个或多个位置的数组，和两个数组中元素的个数。
        2> 使用 CGContextDrawLinearGradient 或者 CGContentDrawRadialGradient 绘制。
        3> 释放 CGGradient 对象
  */
//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    // 使用 CGGradient 绘制
//    CGColorSpaceRef deviceRGB = CGColorSpaceCreateDeviceRGB();
//    size_t num_of_locations = 2;
//    // 注意每个位置对应一个颜色
//    CGFloat locations[2] = {0.0,1.0};
//    CGFloat components[8] = {1.0, 0.0, 0.0, 1.0,//红色
//        0.0,1.0,0.0,1.0};//绿色
//    CGGradientRef gradient = CGGradientCreateWithColorComponents(deviceRGB, components, locations, num_of_locations);
//    CGPoint startPoint = CGPointMake(0, 0);
//    CGPoint endPoint = CGPointMake(rect.size.width, rect.size.height);
//    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
//    CGColorSpaceRelease(deviceRGB);
//    CGGradientRelease(gradient);
//}

//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    // 颜色空间
//    CGColorSpaceRef deviceRGB = CGColorSpaceCreateDeviceRGB();
//    // 位置数组和颜色数组包含元素的个数
//    size_t num_of_locations = 2;
//    CGFloat locations[2] = {0.0, 1.0};
//    // 颜色组件数组的元素的数目必须是位置数目的4倍
//    CGFloat components[8] = {0.0, 0.0, 1.0, 1.0, //白色
//                             0.0, 1.0, 0.0, 1.0 }; //黑色
//    CGGradientRef gradient = CGGradientCreateWithColorComponents(deviceRGB, components, locations, num_of_locations);
//    CGPoint startCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
//    CGPoint endCenter = CGPointMake(self.bounds.size.width/2 + 10, self.bounds.size.height/2 + 10);
//    CGFloat startRadius = 0.0;
//    CGFloat endRadius = 50.0;
//    CGContextDrawRadialGradient(context, gradient, startCenter, startRadius, endCenter, endRadius, 0);
//    CGColorSpaceRelease(deviceRGB);
//    CGGradientRelease(gradient);
//}


#pragma mark - CGShading

static CGFunctionRef myGetFunction (CGColorSpaceRef colorspace) {  // ①
    size_t numComponents;
    static const CGFloat input_value_range [2] = { 0, 1 };
    static const CGFloat output_value_ranges [8] = { 0, 1, 0, 1, 0, 1, 0, 1 }; static const CGFunctionCallbacks callbacks = { 0, // ②
        &myCalculateShadingValues,
        NULL };
    numComponents = 1 + CGColorSpaceGetNumberOfComponents (colorspace); // ③
    
    return CGFunctionCreate ((void *) numComponents,  1,  input_value_range,  numComponents, output_value_ranges,  &callbacks);
}

//static void myCalculateShadingValues (void * info,
//                                      const CGFloat * in,
//                                      CGFloat * out)
//{
//    CGFloat v;
//    size_t k, components;
//    static const CGFloat c[] = {1, 0, 0.5, 0 };
//    components = (size_t)info;
//    v = *in;
//    for (k = 0; k < components -1; k++)
//        *out++ = c[k] * v;
//    *out++ = 1;
//}
//
//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    CGPoint startPoint, endPoint;
//
//    CGFunctionRef myFunctionObject;
//    CGShadingRef myShading;
//
//    startPoint = CGPointMake(0, 0.5);
//    endPoint = CGPointMake(1, 0.5);
//    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
//    myFunctionObject = myGetFunction (colorspace);
//    myShading = CGShadingCreateAxial (colorspace,
//                                      startPoint,
//                                      endPoint,
//                                      myFunctionObject,
//                                      false,
//                                      false);
//    CGContextDrawShading (context, myShading);
//    CGShadingRelease (myShading);
//    CGColorSpaceRelease (colorspace);
//    CGFunctionRelease (myFunctionObject);
//}

static void  myCalculateShadingValues (void *info,
                                       const CGFloat *in,
                                       CGFloat *out)
{
    size_t k, components;
    double frequency[4] = { 55, 220, 110, 0 };
    components = (size_t)info;
    for (k = 0; k < components - 1; k++)
        *out++ = (1 + sin(*in * frequency[k]))/2;
    *out++ = 1; // alpha
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint startPoint, endPoint;
    CGFloat startRadius, endRadius;
    startPoint = CGPointMake(0.25,0.3);
    startRadius = .1;
    endPoint = CGPointMake(.7,0.7);
    endRadius = .25;
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFunctionRef myShadingFunction = myGetFunction(colorspace);
    CGShadingRef shading;
    
    shading = CGShadingCreateRadial(colorspace,
                                    startPoint,
                                    startRadius,
                                    endPoint,
                                    endRadius,
                                    myShadingFunction,
                                    false,
                                    false);
    CGContextDrawShading(context, shading);
    CGShadingRelease(shading);
    CGColorSpaceRelease(colorspace);
    CGFunctionRelease(myShadingFunction);
}



#pragma mark -

CGFunctionRef _Nullable CGFunctionCreate (
                                          
    void * _Nullable info,  // info 用来传递到 callback 的数据（就是指向回调所需要的数据的指针），注意他的生命周期可能不只是方法的生命周期
                                          
    size_t domainDimension, // 输入的数量，quart中，就是 1。(回调输入值的个数，Quartz要求回调携带一个输入值)
                                          
    const CGFloat * _Nullable domain, // 一组数据，确定输入的有效间隔，在 Quartz中是 0 到 1，0表示开始，1表示结束 （一个浮点数的数组。Quartz只会提供数组中的一个元素给回调函数。一个转入值的范围是0(渐变的开始点的颜色)到1(渐变的结束点的颜色)。）
                                          
    size_t rangeDimension,  // 输出的数量:(回调提供的输出值的数目，对于每一个输入值，我们的回调必须为每个颜色组件提供一个值，以及一个alpha值来指定透明度，颜色组件值由Quartz提供的颜色空间来解释，并提供给CGShading创建函数。例如如果我们使用RGB颜色空间，则我们提供4作为输出值(R,G,B,A)的数目)
                                          
    const CGFloat * _Nullable range,  // 输出的有效间隔 （一个浮点数的数组，用于指定每个颜色组件的值及alpha值）
                                          
    const CGFunctionCallbacks * _Nullable callbacks  // 用来计算的实际方法 （一个回调数据结构，包含结构体的版本(设置为0)、生成颜色组件值的回调、一个可选的用于释放回调中info参数表示的数据。）格式如下 格式如下void myCalculateShadingValues (void *info, const CGFloat *in, CGFloat *out)
);

@end
