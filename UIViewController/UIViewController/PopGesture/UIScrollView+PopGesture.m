//
//  UIScrollView+PopGesture.m
//  UIViewController
//
//  Created by CYKJ on 2019/8/26.
//  Copyright © 2019年 D. All rights reserved.


#import "UIScrollView+PopGesture.h"

@implementation UIScrollView (PopGesture)

- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer
{
    // 侧滑距左边的距离
    CGFloat leftMargin = 0.3 * [UIScreen mainScreen].bounds.size.width;
    
    // 属于自身的手势
    if (gestureRecognizer == self.panGestureRecognizer) {
        
        UIPanGestureRecognizer * pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self];
        UIGestureRecognizerState state = gestureRecognizer.state;
        
        if (UIGestureRecognizerStateBegan == state || UIGestureRecognizerStatePossible == state) {
            CGPoint location = [gestureRecognizer locationInView:self];
            
            // 只允许在第一张时滑动返回生效
            if (point.x > 0 && location.x < leftMargin && self.contentOffset.x <= 0) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer
{
    if ([self panBack:gestureRecognizer]) {
        return YES;
    }
    return NO;
}

@end
