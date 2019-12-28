//
//  ImageIO.m
//  UIImage
//
//  Created by CYKJ on 2019/12/24.
//  Copyright © 2019 D. All rights reserved.
//

#import "ImageIO.h"
#import <ImageIO/ImageIO.h>

@interface ImageIO ()
@property (nonatomic, assign) float expectLength;
@property (nonatomic, assign) BOOL isFinish;
@property (nonatomic, strong) NSMutableData * saveImgData;
@property (nonatomic, assign) CGImageSourceRef source;
@end


@implementation ImageIO

- (instancetype)init
{
    if (self = [super init]) {
        self.source = CGImageSourceCreateIncremental(nil);
        self.saveImgData = [NSMutableData data];
    }
    return self;
}

CGImageRef MyCreateCGImageFromFile(NSString * path)
{
    NSURL * url = [NSURL URLWithString:path];
    
    CGImageRef image;
    CGImageSourceRef imageSource;
    
    CFDictionaryRef imageOptions;
    CFStringRef imageKeys[2];
    CFTypeRef imageValues[2];
    //缓存键值对
    imageKeys[0] = kCGImageSourceShouldCache;
    imageValues[0] = (CFTypeRef)kCFBooleanTrue;
    //float-point键值对
    imageKeys[1] = kCGImageSourceShouldAllowFloat;
    imageValues[1] = (CFTypeRef)kCFBooleanTrue;
    //获取Dictionary，用来创建资源
    imageOptions = CFDictionaryCreate(NULL, (const void **) imageKeys,
                                      (const void **) imageValues, 2,
                                      &kCFTypeDictionaryKeyCallBacks,
                                      &kCFTypeDictionaryValueCallBacks);
    //资源创建
    imageSource = CGImageSourceCreateWithURL((CFURLRef)url, imageOptions);
    CFRelease(imageOptions);
    
    if (imageSource == NULL) {
        return NULL;
    }
    //图片获取，index=0
    image = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    CFRelease(imageSource);
    
    return image;
}

CGImageRef MyCreateThumbnailCGImageFromURL(NSURL * url, int imageSize)
{
    CGImageRef thumbnailImage;
    CGImageSourceRef imageSource;
    
    CFDictionaryRef imageOptions;
    CFStringRef imageKeys[3];
    CFTypeRef imageValues[3];
    
    CFNumberRef thumbnailSize;
    //先判断数据是否存在
    imageSource = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    
    if (imageSource == NULL) {
        fprintf(stderr, "Image source is NULL.");
        return  NULL;
    }
    //创建缩略图等比缩放大小，会根据长宽值比较大的作为imageSize进行缩放
    thumbnailSize = CFNumberCreate(NULL, kCFNumberIntType, &imageSize);
    
    imageKeys[0] = kCGImageSourceCreateThumbnailWithTransform;
    imageValues[0] = (CFTypeRef)kCFBooleanTrue;
    
    imageKeys[1] = kCGImageSourceCreateThumbnailFromImageIfAbsent;
    imageValues[1] = (CFTypeRef)kCFBooleanTrue;
    //缩放键值对
    imageKeys[2] = kCGImageSourceThumbnailMaxPixelSize;
    imageValues[2] = (CFTypeRef)thumbnailSize;
    
    imageOptions = CFDictionaryCreate(NULL, (const void **) imageKeys,
                                      (const void **) imageValues, 3,
                                      &kCFTypeDictionaryKeyCallBacks,
                                      &kCFTypeDictionaryValueCallBacks);
    //获取缩略图
    thumbnailImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, imageOptions);
    
    CFRelease(imageOptions);
    CFRelease(thumbnailSize);
    CFRelease(imageSource);
    
    if (thumbnailImage == NULL) {
        return NULL;
    }
    return thumbnailImage;
}


#pragma mark - 处理渐变式加载
/**
 *  @brief   接收到服务器的响应
 */
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    //图片的总长度
    self.expectLength = dataTask.response.expectedContentLength;
    //标记图片是否下载完毕
    self.isFinish = NO;
    // 允许处理服务器的响应，才会继续接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
}

/**
 *  @brief   接收到服务器的数据（可能调用多次）
 */
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    // saveImageData中存储每次服务器响应返回的图片数据
    [self.saveImgData appendData:data];
    
    self.isFinish = NO;
    
    // 判断图片是否下载完毕
    if (self.expectLength == self.saveImgData.length) {
        self.isFinish = YES;
    }
    //填充数据
    CGImageSourceUpdateData(self.source, (__bridge CFDataRef)self.saveImgData, self.isFinish);
    CGImageRef oneRef = CGImageSourceCreateImageAtIndex(self.source, 0, nil);
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage * image =  [UIImage imageWithCGImage:oneRef];
        // 释放
        CGImageRelease(oneRef);
    });
}

/**
 *  @brief   请求成功或者失败（如果失败，error 有值）
 */
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    if (self.expectLength == self.saveImgData.length) {
        //释放
        CFRelease(self.source);
    }
}


#pragma mark - CGImageDestinationRef
/**
  *  @brief   将图片数据写入 Image Destination
  */
- (void)writeCGImage:(CGImageRef)image
               toURL:(NSURL *)url
            withType:(CFStringRef)imageType
          andOptions:(CFDictionaryRef)options
{
    float compression = 1.0; //设置压缩比
    int orientation = 4; // 设置朝向 bottom, left.
    CFStringRef myKeys[3];
    CFTypeRef   myValues[3];
    CFDictionaryRef myOptions = NULL;
    myKeys[0] = kCGImagePropertyOrientation;
    myValues[0] = CFNumberCreate(NULL, kCFNumberIntType, &orientation);
    myKeys[1] = kCGImagePropertyHasAlpha;
    myValues[1] = kCFBooleanTrue;
    myKeys[2] = kCGImageDestinationLossyCompressionQuality;
    myValues[2] = CFNumberCreate(NULL, kCFNumberFloatType, &compression);
    myOptions = CFDictionaryCreate( NULL, (const void **)myKeys, (const void **)myValues, 3,
                                   &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    // Release 不需要的变量
    
    CGImageDestinationRef myImageDest = CGImageDestinationCreateWithURL((CFURLRef)url, imageType, 1, nil);
    CGImageDestinationAddImage(myImageDest, image, options);  // 添加数据和图片
    CGImageDestinationFinalize(myImageDest);  // 最后调用，完成数据写入
    CFRelease(myImageDest);
}

@end
