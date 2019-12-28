//
//  ScaleTool.m
//  UIImage
//
//  Created by CYKJ on 2019/12/23.
//  Copyright © 2019 D. All rights reserved.


#import "ScaleTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation ScaleTool

/**
 *  @brief   UIKIt框架：UIGraphicsBeginImageContextWithOptions
  */
+ (UIImage *)doScale1:(UIImage *)originalImage ratio:(CGFloat)ratio
{
    // 缩放尺寸
//    CGSize size = CGSizeMake(originalImage.size.width * ratio, originalImage.size.height * ratio);
//    CGSize size = AVMakeRectWithAspectRatioInsideRect(originalImage.size, imageView.bounds);
    CGSize size = CGSizeApplyAffineTransform(originalImage.size,
                                             CGAffineTransformScale(CGAffineTransformIdentity, ratio, ratio));

    // 是否有透明通道
    BOOL hasAlpha = NO;
    // 显示缩放系数。设置为 0 时会自动使用主屏幕的缩放系数  Automatically use scale factor of main screen
    CGFloat scale = 0.0;
    
    UIGraphicsBeginImageContextWithOptions(size, hasAlpha, scale);
    [originalImage drawInRect:CGRectMake(0, 0, size.width, size.height)];

    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

/**
  *  @brief   Core Graphic/Quartz 2D：CGBitmapContext
  */
+ (UIImage *)doScale2:(UIImage *)originalImage ratio:(CGFloat)ratio
{
    CGImageRef cgImage = originalImage.CGImage;
    
    CGFloat w = CGImageGetWidth(cgImage) * ratio;
    CGFloat h = CGImageGetHeight(cgImage)* ratio;
    CGFloat bitsPerComponent = CGImageGetBitsPerComponent(cgImage);
    CGFloat bytesPerRow = CGImageGetBytesPerRow(cgImage);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(cgImage);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(cgImage);
    
    CGContextRef context = CGBitmapContextCreate(nil,
                                                 w,
                                                 h,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 bitmapInfo);
    // CGContextSetInterpolationQuality 允许上下文在各个保真度等级插入像素。传递 kCGInterpolationHigh 参数用来获得最优的结果
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextDrawImage(context,
                       CGRectMake(0, 0, w, h),
                       cgImage);
    CGImageRelease(cgImage);
    
    return [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
}

/**
  *  @brief   Image I/O：CGImageSourceCreateThumbnailAtIndex
  *  @discussion   Image I/O 是可以用来处理图片的框架。依赖 Core Graphic，它可以在许多不同格式下读写，访问图片媒体，执行通用图片处理
  */
+ (UIImage *)doScale3:(UIImage *)originalImage ratio:(CGFloat)ratio
{
    CGSize size = originalImage.size;
    // 图片尺寸的调整是通过 kCGImageSourceThumbnailMaxPixelSize 完成
    // kCGImageSourceCreateThumbnailFromImageIfAbsent 或者 kCGImageSourceCreateThumbnailFromImageAlways，后续调用，Image I/O 将自动缓存缩放的结果。
    CFDictionaryRef options = (__bridge CFDictionaryRef)@{ (__bridge id)kCGImageSourceThumbnailMaxPixelSize : @(MAX(size.width, size.height) * ratio), (__bridge id)kCGImageSourceCreateThumbnailFromImageIfAbsent : (__bridge id)kCFBooleanTrue };
    
    NSData * data = UIImageJPEGRepresentation(originalImage, 1.0);
    // 图片数据源的容器
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    if (imageSourceRef == NULL) {
        return nil;
    }
    
    CGImageRef cgImage = CGImageSourceCreateThumbnailAtIndex(imageSourceRef,
                                                             0,
                                                             options);
    CFRelease(imageSourceRef);
    UIImage * image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return image;
}

/**
  *  @brief   Core Image：Core Image Lanczos 采样
  *  @discussion   Core Image 提供一个使用 CILanczosScaleTransform 滤镜内置的 Lanczos 采样函数。虽然是比 UIKit 更高级的 API，但在 Core Image 普遍使用 KVC，所以使用起来比较笨拙。
  */
+ (UIImage *)doScale4:(UIImage *)originalImage ratio:(CGFloat)ratio
{
    CIImage * ciImage = [CIImage imageWithCGImage:originalImage.CGImage];
    
    // 变换滤镜
    CIFilter * filter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
    [filter setValue:ciImage forKey:@"inputImage"];
    [filter setValue:@(ratio) forKey:@"inputScale"];
    [filter setValue:@(1.0) forKey:@"inputAspectRatio"];

    CIImage * outputImage = (CIImage *)[filter valueForKey:@"outputImage"];
    
    CIContext * context = [CIContext contextWithOptions:nil];
    if (context == nil) {
        return nil;
    }
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:outputImage.extent];
    UIImage * image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return image;
}


+ (UIImage *)doScaleWithImagePath3:(NSString *)imagePath ratio:(CGFloat)ratio
{
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:imagePath], nil);
    if (imageSourceRef == NULL) {
        return nil;
    }
    // 图片尺寸的调整是通过 kCGImageSourceThumbnailMaxPixelSize 完成
    // kCGImageSourceCreateThumbnailFromImageIfAbsent 或者 kCGImageSourceCreateThumbnailFromImageAlways，后续调用，Image I/O 将自动缓存缩放的结果。
    CFDictionaryRef options = (__bridge CFDictionaryRef)@{ (__bridge id)kCGImageSourceThumbnailMaxPixelSize : @(100), (__bridge id)kCGImageSourceCreateThumbnailFromImageIfAbsent : (__bridge id)kCFBooleanTrue };
    
    CGImageRef cgImage = CGImageSourceCreateThumbnailAtIndex(imageSourceRef,
                                                             0,
                                                             options);
    CFRelease(imageSourceRef);
    UIImage * image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return  image;
}

@end
