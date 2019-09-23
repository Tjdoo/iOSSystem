//
//  ViewController.m
//  UIImage
//
//  Created by CYKJ on 2019/7/8.
//  Copyright © 2019年 D. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView * renderImageView1;
@property (weak, nonatomic) IBOutlet UIImageView * renderImageView2;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // imageNamed: 与 imageWithContentsOfFile:的区别。https://www.cnblogs.com/LynnAIQ/p/5937402.html
    
    // ①、通过 UIKit 库处理
    self.renderImageView1.image = [self imageFillColor:[UIColor greenColor]
                                          originImage:[UIImage imageNamed:@"筛选"]];
    // ②、通过 iOS7.0 UIImage 类新增的方法
    self.renderImageView2.image = [self renderImage:[UIImage imageNamed:@"筛选"]];
    self.renderImageView2.tintColor = [UIColor greenColor];
}

- (UIImage *)imageFillColor:(UIColor *)color originImage:(UIImage *)originImage
{
    UIGraphicsBeginImageContextWithOptions(originImage.size, NO, 0);
    // 设置画笔颜色
    [color setFill];
    
    CGRect bounds = CGRectMake(0, 0, originImage.size.width, originImage.size.height);
    UIRectFill(bounds);
    
    [originImage drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:1.0];
    // 再绘制一次
    [originImage drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0];
    
    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

- (UIImage *)renderImage:(UIImage *)originImage
{
    return [originImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

@end
