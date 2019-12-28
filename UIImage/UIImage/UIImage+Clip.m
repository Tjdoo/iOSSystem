//
//  UIImage+Clip.m
//  CiYunApp
//
//  Created by CYKJ on 2019/4/9.
//  Copyright © 2019年 . All rights reserved.


#import "UIImage+Clip.h"

#define SCREEN_WIDTH         ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT        ([[UIScreen mainScreen] bounds].size.height)

@implementation UIImage (Clip)

/**
  *  @brief   以中心位置剪切。可以通过改变 rect 的 x、y 值调整剪切位置
  */
-(UIImage *)clipImage:(CGSize)size
{
    UIImage * aImage = self;
    
    CGFloat scale = MIN(aImage.size.width / SCREEN_WIDTH, aImage.size.height / SCREEN_HEIGHT);
    
    CGFloat x = 0.0;
    CGFloat y = 0.0;
    CGFloat w = size.width * scale;
    CGFloat h = size.height * scale;
    
    // 正面
    if (aImage.imageOrientation == UIImageOrientationUp) {
        
        x = (aImage.size.width - w) / 2.0;
        y = (aImage.size.height - h) / 2.0;
    }
    // 相机拍出来的照片是 right
    else if (aImage.imageOrientation == UIImageOrientationRight) {
        
        x = (aImage.size.height - w) / 2.0;
        y = (aImage.size.width - h) / 2.0;
    }
    
    return [aImage imageFromRect:CGRectMake(x, y, w, h)];
}

/**
  *  @brief   裁剪出实际边框内的图片
  *  @param   rect   要截取的区域
  */
- (UIImage *)imageFromRect:(CGRect)rect
{
    // 裁剪
    CGImageRef cgRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage * image = [UIImage imageWithCGImage:cgRef];
    
    CGImageRelease(cgRef);
    
    return image;
}

/**
  *  @brief   CoreGraphics 库处理图片的方向
  */
- (UIImage *)cgFixOrientation
{
    UIImage * aImage = self;
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp) {
        return aImage;
    }
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    
    // CGAffineTransformConcat(T1, T2)，它的执行顺序是 T1 -> T2
    // CGAffineTransformXXX(T1, T2)，它的执行顺序是 T2 -> T1
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:  // 倒置
        case UIImageOrientationDownMirrored:
        {
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
        }
            break;

        case UIImageOrientationLeft:  // 左转
        case UIImageOrientationLeftMirrored:
        {
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
        }
            break;

        case UIImageOrientationRight: // 右转
        case UIImageOrientationRightMirrored:
        {
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
        }
            break;
        default:
            break;
    }

    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
        {
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
        }
            break;

        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
        {
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
        }
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }

    // 以 RightMirrored 为例（见 RightMirrored.png），执行矩阵变换的顺序是：Scale -》Translate -》Rotate -》Translate
    // https://www.jianshu.com/p/df094c044096
    
    // Now we draw the underlying CGImage into a new context, applying the transform calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             aImage.size.width,
                                             aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage),
                                             0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    
    // 绘制图片，设置区域
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.height, aImage.size.width), aImage.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.width, aImage.size.height), aImage.CGImage);
            break;
    }
    
    // 获取图片
    CGImageRef cgRef = CGBitmapContextCreateImage(ctx);
    UIImage * img = [UIImage imageWithCGImage:cgRef];
    
    CGContextRelease(ctx);
    CGImageRelease(cgRef);
    
    return img;
}

/**
  *  @brief   UIKit 库处理图片方向
  */
- (UIImage *)uiFixOrientation
{
    if (self.imageOrientation == UIImageOrientationUp) {
        return self;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){ 0, 0, self.size }];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
