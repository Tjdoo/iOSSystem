//
//  TranslucentVC.m
//  UINavigationController
//
//  Created by CYKJ on 2019/10/18.
//  Copyright © 2019年 D. All rights reserved.


#import "TranslucentVC.h"
#import "XUtil.h"

/**    navigationBar.translucent = YES 时的导航栏处理   **/

@interface TranslucentVC () <UIScrollViewDelegate>
{
    BOOL __willDisappear;
    BOOL __translucent;
}
@property (weak, nonatomic) IBOutlet UIScrollView * scroll;

@end


@implementation TranslucentVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    // 透明的导航栏进行上下滑动处理时，因为有一层 _UIBackdropView - _UIBackdropEffectView，不会是纯白色
    // 要处理成纯白色，可以通过在 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    __willDisappear = NO;
    
    __translucent = self.navigationController.navigationBar.translucent;
    self.navigationController.navigationBar.translucent = YES; // 透明
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
