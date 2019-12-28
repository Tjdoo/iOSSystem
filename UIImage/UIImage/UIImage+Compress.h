//  图片压缩
//
//  UIImage+Compress.h
//  CiYunApp
//
//  Created by CYKJ on 2019/4/17.
//  Copyright © 2019年 . All rights reserved.


#import <UIKit/UIKit.h>

@interface UIImage (Compress)

- (NSData *)compressImageForMaxSize:(NSInteger)maxSize;
- (UIImage *)newSizeImage:(CGSize)size image:(UIImage *)sourceImage;
- (void)compressedImageInKB:(CGFloat)fImageKBytes imageBlock:(void(^)(NSData *imageData))block;

@end
