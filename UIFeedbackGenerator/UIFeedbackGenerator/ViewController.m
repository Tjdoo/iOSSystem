//
//  ViewController.m
//  UIFeedbackGenerator
//
//  Created by CYKJ on 2019/10/30.
//  Copyright © 2019年 D. All rights reserved.


#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>


@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 普通短震，3D Touch 中 Peek 震动反馈
//    AudioServicesPlaySystemSound(1519);
    // 普通短震，3D Touch 中 Pop 震动反馈
//    AudioServicesPlaySystemSound(1520);
    // 连续三次短震
//    AudioServicesPlaySystemSound(1521);
    
    
    /* UIImpactFeedbackGenerator 只在 iphone7 后手机才会产生震动
     
                UIImpactFeedbackStyleLight  轻度点击
                UIImpactFeedbackStyleMedium  中度点击
                UIImpactFeedbackStyleHeavy  重度点击
            */
//    UIImpactFeedbackGenerator * impactLight = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
//    [impactLight impactOccurred];
    
    // 选择切换
    UISelectionFeedbackGenerator * feedbackSelection = [[UISelectionFeedbackGenerator alloc] init];
    [feedbackSelection selectionChanged];
}

@end
