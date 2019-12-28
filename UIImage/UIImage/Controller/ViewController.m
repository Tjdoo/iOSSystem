//
//  ViewController.m
//  UIImage
//
//  Created by CYKJ on 2019/7/8.
//  Copyright © 2019年 D. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView * loadImageView;
@property (weak, nonatomic) IBOutlet UIImageView * renderImageView1;
@property (weak, nonatomic) IBOutlet UIImageView * renderImageView2;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self __testLoadImage];
    [self __testBlendMode];
//    [self __testImageIO];
    
    // 支持的图片格式
    CFArrayRef mySourceTypes = CGImageSourceCopyTypeIdentifiers();
    CFShow(mySourceTypes);
    CFArrayRef myDestinationTypes = CGImageDestinationCopyTypeIdentifiers();
    CFShow(myDestinationTypes);
}

/**
  *  @brief    imageNamed: 与 imageWithContentsOfFile:的区别。https://www.cnblogs.com/LynnAIQ/p/5937402.html
  */
- (void)__testLoadImage
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 0; i < 100000; i++) {
            self.loadImageView.image = [UIImage imageNamed:@"iicon"];
//            self.loadImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iicon" ofType:@"png"]];
        }
    });
}

/**
  *  @brief   图片混合模式
  */
- (void)__testBlendMode
{
    // ①、通过 UIKit 库处理
    self.renderImageView1.image = [self imageFillColor:[UIColor orangeColor]
                                           originImage:[UIImage imageNamed:@"Star"]];
    // ②、通过 iOS7.0 UIImage 类新增的方法
    self.renderImageView2.image = [self renderImage:[UIImage imageNamed:@"Star"]];
    self.renderImageView2.tintColor = [UIColor orangeColor];
}

/// https://blog.csdn.net/ouyangtianhan/article/details/17278579
/// UIImage：https://developer.apple.com/documentation/uikit/uiimage
/// CGBlendMode：https://developer.apple.com/documentation/coregraphics/cgblendmode
- (UIImage *)imageFillColor:(UIColor *)color originImage:(UIImage *)originImage
{
    UIGraphicsBeginImageContextWithOptions(originImage.size, NO, 0);
    // 设置画笔颜色
    [color setFill];
    
    CGRect bounds = CGRectMake(0, 0, originImage.size.width, originImage.size.height);
    UIRectFill(bounds);
    
    // 保留灰度
    [originImage drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:1.0];
    // 保留透明度
    [originImage drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0];
    
    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

- (UIImage *)renderImage:(UIImage *)originImage
{
    return [originImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

/**
  *  @brief   测试 imageIO 的过程。https://www.cnblogs.com/fengmin/p/5702240.html
  */
- (void)__testImageIO
{
    NSString * resource = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"];
    NSData * data = [NSData dataWithContentsOfFile:resource options:0 error:nil];
    CFDataRef dataRef = (__bridge CFDataRef)data;
    CGImageSourceRef source = CGImageSourceCreateWithData(dataRef, nil);
    CGImageRef cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil);
    UIImage * image = [UIImage imageWithCGImage:cgImage];
}

- (void)__testStretchable
{
    /**
             创建一个内容可拉伸，而边角不拉伸的图片。根据设置的宽度和高度，将接下来的一个像素进行左右扩展和上下拉伸。
     
             注意：可拉伸的范围都是距离 leftCapWidth 后的 1 竖排像素，和距离 topCapHeight 后的 1 横排像素。如果参数指定 (10, 5)。那么，图片左边 10 个像素，上边 5 个像素。不会被拉伸，x 坐标为 11 的一个像素会被横向复制，y 坐标为 6 的一个像素会被纵向复制。
     
             注意：只是对一个像素进行复制到一定宽度，而图像后面的剩余像素也不会被拉伸。
     
                leftCapWidth  左边不拉伸区域的宽度
                topCapHeight  上面不拉伸的高度
             */
    [[UIImage imageNamed:@""] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    
    
    /**
            该方法返回的是 UIImage 类型的对象，即返回经该方法拉伸后的图像
     
            参数 1：capInsets  是 UIEdgeInsets 类型的数据，即原始图像要被保护的区域。
     
                         这个参数是一个结构体，定义如下：
     
                         typedef struct {
                             CGFloat top, left , bottom, right ;
                         } UIEdgeInsets;
     
                    该参数的意思是被保护的区域到原始图像外轮廓的上部、左部、底部、右部的直线距离
     
            参数 2：resizingMode  是 UIImageResizingMode 类似的数据，即图像拉伸时选用的拉伸模式。这个参数是一个枚举类型，有以下两种方式：
     
                 UIImageResizingModeTile,     平铺
                 UIImageResizingModeStretch,  拉伸
            */
    [[UIImage imageNamed:@""] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)
                                             resizingMode:UIImageResizingModeStretch];
}

@end
