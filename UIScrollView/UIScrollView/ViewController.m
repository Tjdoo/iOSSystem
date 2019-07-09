//
//  ViewController.m
//  UIScrollView
//
//  Created by CYKJ on 2019/7/4.
//  Copyright © 2019年 D. All rights reserved.


#import "ViewController.h"


@interface ViewController () <UIScrollViewDelegate>

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 手指滑动
    if (scrollView.isDecelerating || scrollView.isTracking || scrollView.isDragging) {
        
    }
}

/**
  *  @brief   非手指滑动不触发
  */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

@end
