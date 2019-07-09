//
//  FirstNav.m
//  UITabbar
//
//  Created by CYKJ on 2019/6/10.
//  Copyright © 2019年 D. All rights reserved.


#import "FirstNav.h"

@interface FirstNav ()

@end

@implementation FirstNav

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // https://www.jianshu.com/p/e61c096753eb
    // 方案 ①、在 Assets.xcassets 中设置图片的渲染方式
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"消息_iconS"];

    // 方案 ②、代码处理
    //self.tabBarItem.selectedImage = [[UIImage imageNamed:@"消息_iconS"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // ！！！注意：normalImage 渲染也要 Original，不然图片颜色会改变
}

@end
