//
//  ViewController.m
//  UIView
//
//  Created by CYKJ on 2019/6/19.
//  Copyright © 2019年 D. All rights reserved.


#import "ViewController.h"
#import "UIView+CornerRadius.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView * view1;
@property (weak, nonatomic) IBOutlet UIView * view2;
@property (weak, nonatomic) IBOutlet UIView * shadowView;
@property (weak, nonatomic) IBOutlet UIView * view3;
@property (weak, nonatomic) IBOutlet UIView * view4;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self cornerShoadow1];
    [self cornerShoadow2];
    [self cornerShoadow3];

//    [_view4 addCornerRadius:CYCornerInsetsMake(0, 10, 4, 0)];
    // 不会触发离屏渲染
    _view4.backgroundColor = [UIColor clearColor];
    [_view4 drawRectWithRoundedCornerRadius:CYCornerInsetsMake(0, 10, 4, 0)
                                borderWidth:0
                            backgroundColor:UIColor.redColor
                               borderCorlor:nil];
}

/**
  *  @brief   masksToBounds 为 NO
  */
- (void)cornerShoadow1
{
    _view1.layer.cornerRadius  = 10;
    _view1.layer.masksToBounds = NO;
    
    _view1.layer.shadowColor   = [UIColor redColor].CGColor;
    _view1.layer.shadowOffset  = CGSizeMake(0, 0);
    _view1.layer.shadowOpacity = 0.8;
    _view1.layer.shadowRadius  = 8;
}

/**
  *  @brief   _shadowView 展示阴影，_view2 展示圆角。注：当 _shadowView 的 backgroundColor 为透明色时，阴影将没有效果
  */
- (void)cornerShoadow2
{
    _view2.layer.cornerRadius  = 10;
    _view2.layer.masksToBounds = YES;
    
    _shadowView.layer.shadowColor   = [UIColor redColor].CGColor;
    _shadowView.layer.shadowOffset  = CGSizeMake(0, 0);
    _shadowView.layer.shadowOpacity = 0.8;
    _shadowView.layer.shadowRadius  = 10;
}

/**
  *  @brief   shadowLayer 展示阴影，_view3 展示圆角
  */
- (void)cornerShoadow3
{
    CALayer * shadowLayer     = [CALayer layer];
    shadowLayer.shadowColor   = [UIColor redColor].CGColor;
    shadowLayer.shadowOffset  = CGSizeMake(0, 0);
    shadowLayer.shadowOpacity = 0.8;
    shadowLayer.shadowRadius  = 10;
    shadowLayer.frame         = _view3.frame;
    [self.view.layer addSublayer:shadowLayer];

    _view3.layer.cornerRadius  = 5;
    _view3.layer.masksToBounds = YES;
    // view3 从父视图中移除，需要更改 layer.frame，不然添加到 shadowLayer 上时会位置错误
    _view3.layer.frame = _view3.bounds;
    [_view3 removeFromSuperview];
    [shadowLayer addSublayer:_view3.layer];
}

@end
