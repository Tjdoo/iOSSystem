//
//  GestureScrollView.m
//  CiYunDoctor
//
//  Created by CYD on 2018/11/16.
//  Copyright © 2018年 centrin. All rights reserved.
//

#import "GestureScrollView.h"

@implementation GestureScrollView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _leftMarginPercent = MAX(0.3, MIN(1, _leftMarginPercent));
}

- (instancetype)init
{
    if (self = [super init]) {
        _leftMarginPercent = MAX(0.3, MIN(1, _leftMarginPercent));
    }
    return self;
}

- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer
{
    // 侧滑距左边的距离
    CGFloat leftMargin = _leftMarginPercent * SCREEN_WIDTH;
    
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
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer
{
    return [self panBack:gestureRecognizer];
}

@end
