//
//  UIImage+Compress.m
//  CiYunApp
//
//  Created by CYKJ on 2019/4/17.
//  Copyright © 2019年 . All rights reserved.


#import "UIImage+Compress.h"
#import <objc/message.h>


@implementation UIImage (Compress)
/**
  *  @param   maxSize   压缩目标 size，单位 KB
  */
- (NSData *)compressImageForMaxSize:(NSInteger)maxSize
{
    // 先判断当前质量是否满足要求，不满足再进行压缩
    __block NSData * finallImageData = UIImageJPEGRepresentation(self, 1.0);
    
    NSUInteger sizeOrigin   = finallImageData.length;
    NSUInteger sizeOriginKB = sizeOrigin / 1000;
    
    if (sizeOriginKB <= maxSize) {
        return finallImageData;
    }
    
    // 获取原图片宽高比
    CGFloat sourceImageAspectRatio = self.size.width / self.size.height;
    // 先调整分辨率
    CGSize defaultSize = CGSizeMake(480, 800 / sourceImageAspectRatio);
    UIImage * newImage = [self newSizeImage:defaultSize image:self];
    finallImageData    = UIImageJPEGRepresentation(newImage, 1.0);
    
    //保存压缩系数
    NSMutableArray * compressionQualityArr = [NSMutableArray array];
    CGFloat avg   = 1.0 / 250;
    CGFloat value = avg;
    
    for (int i = 250; i >= 1; i --) {
        value = i * avg;
        [compressionQualityArr addObject:@(value)];
    }
    
    /*
             调整大小。说明：压缩系数数组 compressionQualityArr 是从大到小存储。
          */
    //思路：使用二分法搜索
    finallImageData = [self halfFuntion:compressionQualityArr
                                  image:newImage
                             sourceData:finallImageData
                                maxSize:maxSize];
    
    // 如果还是未能压缩到指定大小，则进行降分辨率
    while (finallImageData.length == 0) {
        // 每次降 100 分辨率
        CGFloat reduceWidth  = 100.0;
        CGFloat reduceHeight = 100.0 / sourceImageAspectRatio;
        
        if (defaultSize.width - reduceWidth <= 0 || defaultSize.height - reduceHeight <= 0) {
            break;
        }
        
        defaultSize = CGSizeMake(defaultSize.width - reduceWidth, defaultSize.height - reduceHeight);

        UIImage * image = [self newSizeImage:defaultSize
                                       image:[UIImage imageWithData:UIImageJPEGRepresentation(newImage, [[compressionQualityArr lastObject] floatValue])]];
        
        finallImageData = [self halfFuntion:compressionQualityArr
                                      image:image
                                 sourceData:UIImageJPEGRepresentation(image, 1.0)
                                    maxSize:maxSize];
    }
    return finallImageData;
}

/**
  *  @brief   调整图片分辨率/尺寸（等比例缩放）
  */
- (UIImage *)newSizeImage:(CGSize)size image:(UIImage *)sourceImage
{
    CGSize  newSize    = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    CGFloat tempHeight = newSize.height / size.height;
    CGFloat tempWidth  = newSize.width  / size.width;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
  *  @brief   二分法搜索
  */
- (NSData *)halfFuntion:(NSArray *)arr image:(UIImage *)image sourceData:(NSData *)finallImageData maxSize:(NSInteger)maxSize
{
    NSData * tempData = [NSData data];
    NSUInteger start  = 0;
    NSUInteger end    = arr.count - 1;
    NSUInteger index  = 0;
    NSUInteger difference = NSIntegerMax;
    
    while(start <= end) {
        index = start + (end - start) / 2;
        finallImageData = UIImageJPEGRepresentation(image, [arr[index] floatValue]);
        NSUInteger sizeOrigin   = finallImageData.length;
        NSUInteger sizeOriginKB = sizeOrigin / 1024;
        
        if (sizeOriginKB > maxSize) {
            start = index + 1;
        }
        else if (sizeOriginKB < maxSize) {
            if (maxSize - sizeOriginKB < difference) {
                difference = maxSize - sizeOriginKB;
                tempData   = finallImageData;
            }
            if (index <= 0) {
                break;
            }
            end = index - 1;
        }
        else {
            break;
        }
    }
    return tempData;
}

/**
  *  @brief   二分法压缩图片
  */
- (void)compressedImageInKB:(CGFloat)fImageKBytes imageBlock:(void(^)(NSData *imageData))block
{
    CGFloat compression = 1;
    NSData * imageData = UIImageJPEGRepresentation(self, compression);
    NSUInteger fImageBytes = fImageKBytes * 1000; //需要压缩的字节Byte，iOS系统内部的进制1000
    
    if (imageData.length <= fImageBytes){
        block(imageData);
        return;
    }
    
    CGFloat max = 1;
    CGFloat min = 0;
    
    // 指数二分处理，首先计算最小值
    compression = pow(2, -6);
    imageData = UIImageJPEGRepresentation(self, compression);
    
    if (imageData.length < fImageBytes) {
        // 二分最大 10 次，区间范围精度最大可达 0.00097657；最大 6 次，精度可达 0.015625
        for (int i = 0; i < 6; ++i) {
            compression = (max + min) / 2;
            imageData = UIImageJPEGRepresentation(self, compression);
            
            //容错区间范围0.9～1.0
            if (imageData.length < fImageBytes * 0.9) {
                min = compression;
            }
            else if (imageData.length > fImageBytes) {
                max = compression;
            }
            else {
                break;
            }
        }
        
        block(imageData);
        return;
    }
    
    // 对于图片太大上面的压缩比即使很小压缩出来的图片也是很大，不满足使用。然后再一步绘制压缩处理
    UIImage * resultImage = [UIImage imageWithData:imageData];
    
    while (imageData.length > fImageBytes) {
        @autoreleasepool {
            CGFloat ratio = (CGFloat)fImageBytes / imageData.length;
            // 使用 NSUInteger 不然由于精度问题，某些图片会有白边
            NSLog(@">>>>>>>>%f>>>>>>>%f>>>>>>>%f",resultImage.size.width, sqrtf(ratio), resultImage.size.height);
            CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                     (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
            //            resultImage = [self drawWithWithImage:resultImage Size:size];
            //            resultImage = [self scaledImageWithData:imageData withSize:size scale:resultImage.scale orientation:UIImageOrientationUp];
            resultImage = [self thumbnailForData:imageData maxPixelSize:MAX(size.width, size.height)];
            imageData = UIImageJPEGRepresentation(resultImage, compression);
        }
    }
    
    // 整理后的图片尽量不要用 UIImageJPEGRepresentation 方法转换，后面参数 1.0 并不表示的是原质量转换。
    block(imageData);
}

- (UIImage *)thumbnailForData:(NSData *)data maxPixelSize:(NSUInteger)size
{
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    CGImageSourceRef source = CGImageSourceCreateWithDataProvider(provider, NULL);
    
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(source, 0, (__bridge CFDictionaryRef) @{
                                                                                                      (NSString *)kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                                                                                                      (NSString *)kCGImageSourceThumbnailMaxPixelSize : @(size),
                                                                                                      (NSString *)kCGImageSourceCreateThumbnailWithTransform : @YES,
                                                                                                      });
    CFRelease(source);
    CFRelease(provider);
    
    if (!imageRef) {
        return nil;
    }
    
    UIImage * toReturn = [UIImage imageWithCGImage:imageRef];
    
    CFRelease(imageRef);
    
    return toReturn;
}

@end
