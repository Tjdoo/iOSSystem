//
//  UIViewController+Tool.m
//  UINavigationController
//
//  Created by CYKJ on 2019/10/18.
//  Copyright © 2019年 D. All rights reserved.


#import "UIViewController+Tool.h"
#import <objc/runtime.h>


@implementation UIViewController (Tool)

+ (void)load
{
    static dispatch_once_t once;
    dispatch_once( &once, ^{
        Method orginalMethod = class_getInstanceMethod([UIViewController class], @selector(viewDidLoad));
        Method myMethod = class_getInstanceMethod([UIViewController class], @selector(yj_viewDidLoad));
        
        //方法交换
        method_exchangeImplementations(orginalMethod, myMethod);
    } );
}

- (void)yj_viewDidLoad
{
    if (nil != self.navigationController && self.navigationController.viewControllers.count > 1
        && nil == self.navigationItem.leftBarButtonItem) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
        
        [btn sizeToFit];
        // 让按钮内部的所有内容左对齐
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.frame = CGRectMake(0, 0, 40, 40);
        [btn addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        // 设置右滑返回功能。即使某个界面再次更改了导航栏按钮，这里也会起作用
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }
    NSLog(@"Appear VC: %@, title:%@", NSStringFromClass(self.class), self.title);
    [self yj_viewDidLoad];
}

- (void)popVC
{
    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
