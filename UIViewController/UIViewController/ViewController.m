//
//  ViewController.m
//  UIViewController
//
//  Created by CYKJ on 2019/6/26.
//  Copyright © 2019年 D. All rights reserved.


#import "ViewController.h"
#import "ChildVC.h"


@interface ViewController ()

@property (nonatomic, strong) ChildVC * childVC;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addChildViewControllerExample];
}

/**
 *  @brief   iOS 5.0 ~ 添加子视图。
 *    好处：
             1、页面中的逻辑更加分明了。相应的 view 对应相应的 ViewController。
             2、当某个子 view 没有显示时，将不会被 Load，减少了内存的使用。
             3、当内存紧张时，没有 Load 的 view 将被首先释放，优化了程序的内存释放机制
 */
- (void)addChildViewControllerExample
{
    self.childVC = (ChildVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ChildVC_SBID"];
    [self addChildViewController:_childVC];
    [self.view addSubview:_childVC.view];
    
    /* childViewControllers = (
                    "<ChildVC: 0x7f8af1d0f450>"
               )
           */
    NSLog(@"childViewControllers = %@", self.childViewControllers);
    
    [self addChildViewController:_childVC];
    [self.view addSubview:_childVC.view];

    /* childViewControllers = (
                      "<ChildVC: 0x7f8af1d0f450>"
                )
           */
    // 当要添加的子视图控制器已经包含在视图控制器容器中，那么相当于先从父视图控制器中删除，然后重新添加到父视图控制器中。https://blog.csdn.net/allangold/article/details/78850695
    NSLog(@"childViewControllers = %@", self.childViewControllers);

    _childVC.view.frame = CGRectMake(10, 200, [UIScreen mainScreen].bounds.size.width - 20, 200);
    
    __typeof(self) __weak weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __typeof(weakSelf) __strong strongSelf = weakSelf;
        [strongSelf removeChildControllerExample];
    });
    
}

- (void)removeChildControllerExample
{
    [_childVC willMoveToParentViewController:nil];
    [_childVC removeFromParentViewController];
    [_childVC.view removeFromSuperview];
    _childVC = nil;
}

@end
