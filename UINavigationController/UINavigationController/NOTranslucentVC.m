//
//  NOTranslucentVC.m
//  UINavigationController
//
//  Created by CYKJ on 2019/10/18.
//  Copyright © 2019年 D. All rights reserved.


#import "NOTranslucentVC.h"
#import "XUtil.h"

/**    navigationBar.translucent = NO 时的导航栏处理   **/

@interface NOTranslucentVC () <UIScrollViewDelegate>
{
    BOOL __willDisappear;
    BOOL __translucent;
}
@property (weak, nonatomic) IBOutlet UIScrollView * scroll;

@end


@implementation NOTranslucentVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    // 当导航栏 translucent = NO 时，导航栏不透明，将 controller（不是 scroll，是整个控制器） 的 frame 从（0， 64）开始布局
    // 通过设置 extendedLayoutIncludesOpaqueBars = YES 或者 xib、storyboard 中勾选 under opaque bars，将 controller 从 (0, 0) 开始布局
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    __willDisappear = NO;
    
    __translucent = self.navigationController.navigationBar.translucent;
    self.navigationController.navigationBar.translucent = NO; // 不透明
    [XUtil setNavBar:self.navigationController.navigationBar bgAlpha:0];
    [XUtil setNavBar:self.navigationController.navigationBar withColor:[UIColor darkGrayColor]];
    [XUtil setNavBar:self.navigationController.navigationBar bottomLineHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    __willDisappear = YES;
    
    self.navigationController.navigationBar.translucent = __translucent;
    [XUtil setNavBar:self.navigationController.navigationBar bgAlpha:1.0];
    [XUtil setNavBar:self.navigationController.navigationBar withColor:[UIColor clearColor]];
    [XUtil setNavBar:self.navigationController.navigationBar bottomLineHidden:NO];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (__willDisappear) {
        return;
    }
    
    CGFloat alpha = scrollView.contentOffset.y / 100;
    [XUtil setNavBar:self.navigationController.navigationBar bgAlpha:alpha];
}

@end
