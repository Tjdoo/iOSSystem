//
//  UITabBar+badge.m
//  UITabbar
//
//  Created by D on 15/12/21.
//  Copyright © 2015年 D. All rights reserved.


#import "UITabBar+badge.h"

#define TabbarItemNums    3.0   // tabbar的数量如果是 4 个设置为 4.0
#define TABBAR_ITEM_TAG   8888
#define RED_CIRCLE_WIDTH  8     // 红点的宽


@implementation UITabBar (badge)

- (void)showBadgeOnItemIndex:(NSInteger)index
{
    if (index < 0 || index > TabbarItemNums)
        return;
    
    UIView * badgeView = [self viewWithTag:TABBAR_ITEM_TAG + index];
    
    if (badgeView) {
        badgeView.hidden = NO;
    }
    else {
        //新建红点
        badgeView = [[UIView alloc] init];
        badgeView.tag = TABBAR_ITEM_TAG + index;
        badgeView.layer.cornerRadius = RED_CIRCLE_WIDTH / 2;
        badgeView.backgroundColor = [UIColor redColor];
        
        CGRect tabFrame = self.frame;
        //设置红点的位置
        float percentX = (index + 0.65) / TabbarItemNums;
        CGFloat x = ceilf(percentX * tabFrame.size.width);  //需要注意的是坐标x，y一定要是整数，否则会有模糊
        CGFloat y = ceilf(0.125 * tabFrame.size.height);
        badgeView.frame = CGRectMake(x, y, RED_CIRCLE_WIDTH, RED_CIRCLE_WIDTH);
        [self addSubview:badgeView];
        [self bringSubviewToFront:badgeView];
    }
}

/**
  *  @brief   隐藏红点
  */
- (void)hideBadgeOnItemIndex:(NSInteger)index
{
    if (index < 0 || index > TabbarItemNums)
        return;
    
    for (UIView * subView in self.subviews) {
        if (subView.tag == TABBAR_ITEM_TAG + index) {
            subView.hidden = YES;
        }
    }
}

@end
