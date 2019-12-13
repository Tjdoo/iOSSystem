//
//  UIImage+CornerRadius.m
//  UIImage
//
//  Created by CYKJ on 2019/11/27.
//  Copyright © 2019年 D. All rights reserved.


#import "UIImage+CornerRadius.h"

@implementation UIImage (CornerRadius)

/**
  *  @brief   CGContext 裁剪
  */
- (UIImage *)cgContextMakeCornerRadius:(CGFloat)radius
{
    CGFloat w = self.size.width  * self.scale;
    CGFloat h = self.size.height * self.scale;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), false, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 左上角
    CGContextMoveToPoint(context, 0, radius);
    CGContextAddArcToPoint(context, 0, 0, radius, 0, radius);
    // 右上角
    CGContextAddArcToPoint(context, w, 0, w, radius, radius);
    // 右下角
    CGContextAddArcToPoint(context, w, h, w-radius, h, radius);
    // 左下角
    CGContextAddArcToPoint(context, 0, h, 0, h-radius, radius);
    CGContextClosePath(context);
    
    CGContextClip(context); // 先裁剪 context，再画图，就会在裁剪后的 path 中画
    [self drawInRect:CGRectMake(0, 0, w, h)];       // 画图
    CGContextDrawPath(context, kCGPathFill);
    
    UIImage * ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return ret;
}

/**
  *  @brief   UIBezierPath 裁剪
  */
- (UIImage *)bezierPathMakeCornerRadius:(CGFloat)radius
{
    CGFloat w = self.size.width  * self.scale;
    CGFloat h = self.size.height * self.scale;
    CGRect rect = CGRectMake(0, 0, w, h);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), false, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    [self drawInRect:rect];
    UIImage * ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return ret;
}

- (UIImage *)imageAddCornerWithRadius:(CGFloat)radius andSize:(CGSize)size
{
    CGFloat w = self.size.width  * self.scale;
    CGFloat h = self.size.height * self.scale;
    CGRect rect = CGRectMake(0, 0, w, h);

    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect
                                                byRoundingCorners:UIRectCornerAllCorners
                                                      cornerRadii:CGSizeMake(radius, radius)];
    CGContextAddPath(ctx, path.CGPath);
    CGContextClip(ctx);
    
    [self drawInRect:rect];
    CGContextDrawPath(ctx, kCGPathFillStroke);
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


// ------------------------------------------------------------------
// --------------------- 以下是自定义图像处理部分 -----------------------
// ------------------------------------------------------------------

/**
  *  @brief   自定义裁剪算法  https://www.jianshu.com/p/bbb50b2cb7e6
  */
- (UIImage *)customMakeCornerRadius:(CGFloat)radius
{
    // ①、CGDataProviderRef：CGImage -》二进制流
    CGDataProviderRef provider = CGImageGetDataProvider(self.CGImage);
    void * imgData = (void *)CFDataGetBytePtr(CGDataProviderCopyData(provider));
    
    int width  = self.size.width * self.scale;
    int height = self.size.height * self.scale;
    
    // ②、处理 imgData
    //    dealImage(imgData, width, height);
    cornerImage(imgData, width, height, radius);
    
    // ③、CGDataProviderRef：二进制流 -》CGImage
    CGDataProviderRef pv = CGDataProviderCreateWithData(NULL,
                                                        imgData,
                                                        width * height * 4,
                                                        releaseData);
    CGImageRef content = CGImageCreate(width,
                                       height,
                                       8,  // 每个颜色组件 8 位，The number of bits for each component in a source pixel. For example, if the source image uses the RGBA-32 format, you would specify 8 bits per component.
                                       32, // 每个像素大小，8 * 4 位
                                       4 * width,  // 每行多少个字节，一字节 8 位
                                       CGColorSpaceCreateDeviceRGB(),
                                       kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast,
                                       pv,
                                       NULL,
                                       true,
                                       kCGRenderingIntentDefault);
    UIImage * result = [UIImage imageWithCGImage:content];
    CGDataProviderRelease(pv);      // 释放空间
    CGImageRelease(content);
    
    return result;
}

void releaseData(void *info, const void *data, size_t size) {
    free((void *)data);
}

// 在 img 上处理图片, 测试用
void dealImage(UInt32 * img, int w, int h) {
    int num = w * h;
    UInt32 * cur = img;
    for (int i = 0; i < num; i++, cur++) {
        UInt8 *p = (UInt8 *)cur;
        // RGBA 排列
        // f(x) = 255 - g(x) 求负片
        p[0] = 255 - p[0];
        p[1] = 255 - p[1];
        p[2] = 255 - p[2];
        p[3] = 255;
    }
}

/**
  *  @brief   裁剪圆角
  */
void cornerImage(UInt32 *const img, int w, int h, CGFloat cornerRadius) {
    CGFloat c = cornerRadius;
    CGFloat min = w > h ? h : w;
    
    if (c < 0) { c = 0; }
    if (c > min * 0.5) { c = min * 0.5; }
    
//    // 左上 y:[0, c), x:[x, c-y)
//    for (int y = 0; y < c; y++) {
//        for (int x = 0; x < c-y; x++) {
//            UInt32 *p = img + y * w + x;    // p：32位指针，RGBA排列，各8位
//            if (isCircle(c, c, c, x, y) == false) {
//                *p = 0;
//            }
//        }
//    }
//    // 右上 y:[0, c), x:[w-c+y, w)
//    int tmp = w-c;
//    for (int y = 0; y<c; y++) {
//        for (int x = tmp+y; x<w; x++) {
//            UInt32 *p = img + y * w + x;
//            if (isCircle(w-c, c, c, x, y) == false) {
//                *p = 0;
//            }
//        }
//    }
//    // 左下 y:[h-c, h), x:[0, y-h+c)
//    tmp = h-c;
//    for (int y=h-c; y<h; y++) {
//        for (int x=0; x<y-tmp; x++) {
//            UInt32 *p = img + y * w + x;
//            if (isCircle(c, h-c, c, x, y) == false) {
//                *p = 0;
//            }
//        }
//    }
//    // 右下 y~[h-c, h), x~[w-c+h-y, w)
//    tmp = w-c+h;
//    for (int y=h-c; y<h; y++) {
//        for (int x=tmp-y; x<w; x++) {
//            UInt32 *p = img + y * w + x;
//            if (isCircle(w-c, h-c, c, x, y) == false) {
//                *p = 0;
//            }
//        }
//    }
    
    // 查找一个角时，同时查找另外三个角
    for (int y = 0; y < c; y++) {
        for (int x = 0; x < c-y; x++) {
            // y*w+x pointer
            UInt32 * leftTopP = img + y * w + x; // p 32位指针，RGBA排列，各8位
            // to 0.
            if (isCircle(c, c, c, x, y) == false) {
                
                UInt32 * rightTopP = img + y * w +(w - x);
                UInt32 * leftBottomP = img + (h -y) * w + x;
                UInt32 * rightBottomP = img + (h -y) * w + (w - x);
                
                *leftTopP = 0;
                *rightTopP = 0;
                *leftBottomP = 0;
                *rightBottomP = 0;
            }
        }
    }
}

// 判断点 (px, py) 在不在圆心 (cx, cy) 半径 r 的圆内
static inline bool isCircle(float cx, float cy, float r, float px, float py) {
    if ((px-cx) * (px-cx) + (py-cy) * (py-cy) > r * r) {
        return false;
    }
    return true;
}

// 其他图像效果可以自己写函数，然后在 dealImage: 中调用 otherImage 即可
void otherImage(UInt32 *const img, int w, int h) {
    // 自定义处理
}

@end
