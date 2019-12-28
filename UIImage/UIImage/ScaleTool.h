//
//  ScaleTool.h
//  UIImage
//
//  Created by CYKJ on 2019/12/23.
//  Copyright © 2019 D. All rights reserved.


#import <UIKit/UIKit.h>

/**
  *  @brief   调整图片尺寸
  *  @discussion   UIKit、Core Graphic 和 Image I/O 对大多数图片缩放操作表现良好
  *  @see   https://www.jianshu.com/p/154b938d2046
  */
@interface ScaleTool : NSObject

+ (UIImage *)doScale1:(UIImage *)originalImage ratio:(CGFloat)ratio;
+ (UIImage *)doScale2:(UIImage *)originalImage ratio:(CGFloat)ratio;
+ (UIImage *)doScale3:(UIImage *)originalImage ratio:(CGFloat)ratio;
+ (UIImage *)doScale4:(UIImage *)originalImage ratio:(CGFloat)ratio;

+ (UIImage *)doScaleWithImagePath1:(NSString *)imagePath ratio:(CGFloat)ratio;
+ (UIImage *)doScaleWithImagePath2:(NSString *)imagePath ratio:(CGFloat)ratio;
+ (UIImage *)doScaleWithImagePath3:(NSString *)imagePath ratio:(CGFloat)ratio;
+ (UIImage *)doScaleWithImagePath4:(NSString *)imagePath ratio:(CGFloat)ratio;

@end
