//
//  ChildVC.m
//  UIViewController
//
//  Created by CYKJ on 2019/6/26.
//  Copyright © 2019年 D. All rights reserved.


#import "ChildVC.h"

@interface ChildVC ()

@end

@implementation ChildVC

- (void)dealloc
{
    NSLog(@"Child VC Dealloc!");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"Child VC WillAppear!");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"Child VC DidAppear!");
    
//    __typeof(self) __weak weakSelf = self;
//    // 5.0 秒后移除。这种方式不好将自己置为 nil
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        __typeof(weakSelf) __weak strongSelf = weakSelf;
//
//        [strongSelf willMoveToParentViewController:nil];
//        [strongSelf.view removeFromSuperview];
//        [strongSelf removeFromParentViewController];
//    });
}

@end
