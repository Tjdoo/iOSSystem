//
//  BulgeTabbar.m
//  UITabbar
//
//  Created by CYKJ on 2019/10/30.
//  Copyright © 2019年 D. All rights reserved.


#import "BulgeTabbar.h"

#define AddButtonMargin 10

@interface BulgeTabbar ()

@property (nonatomic, weak) UIButton * bulgeButton; // 凸起按钮

@end


@implementation BulgeTabbar

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        [self __initProperties];
        [self __createBulgeButton];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self __initProperties];
    [self __createBulgeButton];
}

- (void)__initProperties
{
    self.itemCount = 4;
    self.bulgeIndex = 1;
}

/**
  *  @brief   创建凸起按钮
  */
- (void)__createBulgeButton
{
    UIButton * btn = [[UIButton alloc] init];
    btn.bounds = CGRectMake(0, 0, 64, 64);
    [btn setImage:[UIImage imageNamed:@"Add"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
    
    self.bulgeButton = btn;
}

/**
  *  @brief   按钮点击事件
  */
- (void)btnClicked:(UIButton *)sender
{
    if([self.bulgeTabBarDelegate respondsToSelector:@selector(bulgeButtonClick:)]) {
        [self.bulgeTabBarDelegate bulgeButtonClick:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 去掉  TabBar上部的横线
    for (UIView * view in self.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height <= 1)   //横线的高度为 0.5
        {
            UIImageView *line = (UIImageView *)view;
            line.hidden = YES;
        }
    }
    
    // 设置凸起按钮的位置
    self.bulgeButton.center = CGPointMake(self.bounds.size.width * 3/8, self.bounds.size.height * 0.3);

    int index = 0;
    CGFloat w = self.bounds.size.width / self.itemCount;

    // 系统自带的按钮类型是 UITabBarButton，找出这些类型的按钮，然后重新排布位置，空出中间的位置
    Class class = NSClassFromString(@"UITabBarButton");
    
    // UITabBarButton 并不一定是按照顺序添加到 tabbar 上的
    NSMutableArray * indexs = [NSMutableArray arrayWithCapacity:self.itemCount];
    for (UITabBarItem * item in self.items) {
        [indexs addObject:@(item.tag)];
    }

    // ⚠️ 如果是通过 storyboard 创建的 UITabbar 对象，btn 的顺序是错乱的
    for (UIView * btn in self.subviews) {
        
        if ([btn isKindOfClass:class]) {

            btn.frame = CGRectMake(index * w,
                                   self.bounds.origin.y,
                                   w,
                                   self.bounds.size.height - 2);
            
            index++;
            // 如果是凸起按钮的位置，跳过
            if (index == self.bulgeIndex) {
                index++;
            }
        }
    }
    [self bringSubviewToFront:self.bulgeButton];
}

/**
  *  @brief   重写 hitTest: 方法，监听凸起按钮的点击，目的是为了让凸出的部分点击也有反应
  */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    //这一个判断是关键，不判断的话 push 到其他页面，点击“+”按钮的位置也是会有反应的，这样就不好了
    //self.isHidden == NO 说明当前页面是有TabBar的，那么肯定是在根控制器页面
    //在根控制器页面，那么我们就需要判断手指点击的位置是否在“+”按钮或“添加”标签上
    //是的话让“+”按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
    if (self.isHidden == NO) {
        //将当前TabBar的触摸点转换坐标系，转换到“+”按钮的身上，生成一个新的点
        CGPoint newA = [self convertPoint:point toView:self.bulgeButton];
        
        //判断如果这个新的点是在“+”按钮身上，那么处理点击事件最合适的view就是“+”按钮
        if ( [self.bulgeButton pointInside:newA withEvent:event]) {
            return self.bulgeButton;
        }
        //如果点击事件不在凸起按钮上，直接让系统处理
        else {
            return [super hitTest:point withEvent:event];
        }
    }
    else {
        // TabBar隐藏了，那么说明已经 push 到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return [super hitTest:point withEvent:event];
    }
}

@end
