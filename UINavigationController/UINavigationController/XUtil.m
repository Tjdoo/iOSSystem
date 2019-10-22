//
//  XUtil.m
//  UINavigationController
//
//  Created by CYKJ on 2019/10/18.
//  Copyright © 2019年 D. All rights reserved.


#import "XUtil.h"


@implementation XUtil

+ (void)setNavBar:(UINavigationBar *)bar withColor:(UIColor *)color
{
    // 修改标题颜色
    if (@available(iOS 8.2, *)) {
        [bar setTitleTextAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:17 weight:UIFontWeightMedium], NSForegroundColorAttributeName : color}];
    }
    else {
        [bar setTitleTextAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:17],
                                       NSForegroundColorAttributeName : color}];
    }
    
    // 修改系统返回图标颜色
    [bar setTintColor:color];
}

+ (void)setNavBar:(UINavigationBar *)bar bgAlpha:(CGFloat)alpha
{
    /*  注意：不同版本的 sdk，导航栏的结构可能不同。
     
        iOS 12.1
         (
             <_UIBarBackground: 0x7fed53519890; frame = (0 -44; 414 88); userInteractionEnabled = NO; layer = <CALayer: 0x600003fb4cc0>>,
             <_UINavigationBarLargeTitleView: 0x7fed5351b2d0; frame = (0 0; 0 50); clipsToBounds = YES; hidden = YES; layer = <CALayer: 0x600003fb4ee0>>,
             <_UINavigationBarContentView: 0x7fed5351a850; frame = (0 0; 414 44); layer = <CALayer: 0x600003fb4d60>>,
             <_UINavigationBarModernPromptView: 0x7fed53522c00; frame = (0 0; 0 50); alpha = 0; hidden = YES; layer = <CALayer: 0x600003fb6160>>
         )
     
        iOS  8.1
         (
                 <_UINavigationBarBackground: 0x7fc73445dad0; frame = (0 -20; 414 64); alpha = 2.64; autoresize = W; userInteractionEnabled = NO; layer = <CALayer: 0x7fc73445de90>>,
                 <UIView: 0x7fc73446fe30; frame = (350 0; 44 44); autoresize = RM+BM; layer = <CALayer: 0x7fc734474e60>>,
                 <UIButton: 0x7fc734472b30; frame = (20 2; 40 40); opaque = NO; layer = <CALayer: 0x7fc734475820>>,
                 <_UINavigationBarBackIndicatorView: 0x7fc734461c80; frame = (12 11.6667; 13 21); alpha = 0; opaque = NO; userInteractionEnabled = NO; layer = <CALayer: 0x7fc734461fc0>>
         )
            */
    if ([bar subviews].count > 0) {
        [[[bar subviews] objectAtIndex:0] setAlpha:alpha];
        if (((UIView *)[[bar subviews] objectAtIndex:0]).subviews.count > 1) {
            [((UIView *)[[bar subviews] objectAtIndex:0]).subviews[1] setAlpha:alpha];
        }
    }
}

+ (void)setNavBar:(UINavigationBar *)bar bottomLineHidden:(BOOL)isHidden
{
    [self __findBarBottomLineOnView:bar].hidden = isHidden;
}

/**
  *  @brief   系统的导航栏底部线条是 UIImageView 对象，高度为 0.333 或 0.5 pt
  */
+ (UIView *)__findBarBottomLineOnView:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return view;
    }
    
    for (UIView * subview in view.subviews) {
        UIView * line = [self __findBarBottomLineOnView:subview];
        if (line) {
            return line;
        }
    }
    return nil;
}

@end
