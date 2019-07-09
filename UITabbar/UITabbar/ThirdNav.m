//
//  ThirdNav.m
//  UITabbar
//
//  Created by CYKJ on 2019/6/14.
//  Copyright © 2019年 D. All rights reserved.


#import "ThirdNav.h"


@interface ThirdNav ()

@property (nonatomic, strong) UIImage * logoImage;

@end


@implementation ThirdNav

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self defaultImage];
    [self setTabbarItemContent];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh:)
                                                 name:@"NewsDoubleTapedKey" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarItem.title = @"";
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.tabBarItem.title = @"首页";
    self.tabBarItem.imageInsets = UIEdgeInsetsZero;
}

- (void)refresh:(NSNotification *)notify
{
    NSLog(@"💖💖💖💖💖");
}

/**
  *  @brief   将默认图处理成 39 * 39 的尺寸
  */
- (void)defaultImage
{
    UIImage * defaultImage = [UIImage imageNamed:@"首页_iconS"];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(39, 39), NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, 39, 39));
    CGContextClip(context);
    [defaultImage drawInRect:CGRectMake(0, 0, 39, 39)];
    defaultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.logoImage = [defaultImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

/**
  *  @brief   设置 tab 内容
  */
- (void)setTabbarItemContent
{
    self.tabBarItem.selectedImage = self.logoImage;
    self.tabBarItem.image = [UIImage imageNamed:@"首页_icon"];
}


#pragma mark - SET

- (void)setLogoUrl:(NSString *)logoUrl
{
    // logo 网址发生改变
    if (![_logoUrl isEqualToString:_logoUrl]) {
        self.logoImage = nil;
    }
    
    _logoUrl = logoUrl;
    
    // 加载网络图片
//    [[UIImageView new] sd_setImageWithURL:[NSURL URLWithString:logoUrl]
//                                completed:^(UIImage * image, NSError * error, SDImageCacheType cacheType, NSURL * imageURL) {
//
//                          if (image != nil) {
//
//                              UIGraphicsBeginImageContextWithOptions(CGSizeMake(39, 39), NO, [UIScreen mainScreen].scale);
//                              CGContextRef context = UIGraphicsGetCurrentContext();
//                              CGContextAddEllipseInRect(context, CGRectMake(0, 0, 39, 39));
//                              CGContextClip(context);
//                              [image drawInRect:CGRectMake(0, 0, 39, 39)];
//                              image = UIGraphicsGetImageFromCurrentImageContext();
//                              UIGraphicsEndImageContext();
//
//                              self.logoImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//                          }
//                          else if (self.logoImage == nil) {  // 如果没空才需要覆盖，避免单次请求失败
//                              [self defaultImage];
//                          }
//
//                          [self setTabbarItemContent];
//                      }];
}

@end
