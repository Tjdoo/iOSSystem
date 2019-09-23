//
//  NextVC.m
//  UIViewController
//
//  Created by CYKJ on 2019/8/26.
//  Copyright © 2019年 D. All rights reserved.
//

#import "NextVC.h"
#import "UIViewController+PopGesture.h"


@interface NextVC ()

@end


@implementation NextVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 禁用本页面的侧滑返回手势
    //self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [UIViewController popGestureClose:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [UIViewController popGestureOpen:self];
}

@end
