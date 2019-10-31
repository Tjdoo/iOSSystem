//  中间凸起的 tabbar
//
//  BulgeTabbar.h
//  UITabbar
//
//  Created by CYKJ on 2019/10/30.
//  Copyright © 2019年 D. All rights reserved.


#import <UIKit/UIKit.h>

@class BulgeTabbar;
// BulgeTabbar 的代理必须实现 addButtonClick，以响应中间“+”按钮的点击事件
@protocol BulgeTabbarDelegate <NSObject>
@required

- (void)bulgeButtonClick:(BulgeTabbar *)tabBar;

@end



@interface BulgeTabbar : UITabBar

@property (nonatomic, weak) id<BulgeTabbarDelegate> bulgeTabBarDelegate;
@property (nonatomic, assign) NSInteger itemCount;  // 按钮数
@property (nonatomic, assign) NSInteger bulgeIndex; // 凸起按钮所在的位置

@end
