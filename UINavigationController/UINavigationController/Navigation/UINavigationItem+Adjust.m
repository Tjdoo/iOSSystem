//
//  UINavigationItem+Adjust.m
//  CiYunApp
//
//  Created by D on 2018/3/27.
//  Copyright © 2018年 D. All rights reserved.


#import "UINavigationItem+Adjust.h"
#import "Objc/runtime.h"
#import "NavigationConstants.h"


@implementation UINavigationItem (Adjust)
/**
  *  @brief   调换自定义的方法实现与系统的方法实现
  */
+ (void)load
{
    if (iOS11_OR_LATER)
        return;
    
    [self cs_swizzle:@selector(setLeftBarButtonItem:)];
    [self cs_swizzle:@selector(setLeftBarButtonItems:)];
    [self cs_swizzle:@selector(setRightBarButtonItem:)];
    [self cs_swizzle:@selector(setRightBarButtonItems:)];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (iOS11_OR_LATER)
        return;
    
    /*   调用替换后的方法。优先判断 items。
     
                这里不能同时设置两个值：1、先设置 item 后设置 items，会导致 item 添加了 FixedSpace，items 再次添加一次
                                                                2、先设置 items 后设置 item，会导致崩溃
           */
    if (self.leftBarButtonItems) {
        self.leftBarButtonItems  = self.leftBarButtonItems;
    }
    else {
        self.leftBarButtonItem   = self.leftBarButtonItem;
    }
    
    if (self.rightBarButtonItems) {
        self.rightBarButtonItems = self.rightBarButtonItems;
    }
    else {
        self.rightBarButtonItem  = self.rightBarButtonItem;
    }
}

+ (void)cs_swizzle:(SEL)sel
{
    SEL inSel = NSSelectorFromString([NSString stringWithFormat:@"cs_%@", NSStringFromSelector(sel)]); // 自定义方法的 SEL
    
    Method m1 = class_getInstanceMethod(self, sel);
    Method m2 = class_getInstanceMethod(self, inSel);
    method_exchangeImplementations(m1, m2); // 交换方法实现
}

- (void)cs_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    // iOS 11 以上由 UINavigationBar + Adjust 类别处理。此处不处理
    if (iOS11_OR_LATER) {
        [self cs_setLeftBarButtonItem:leftBarButtonItem];
    }
    else if (iOS7_OR_LATER) {
        
        if (leftBarButtonItem && (leftBarButtonItem.customView != nil || leftBarButtonItem.image != nil)) {
            
            [self cs_setLeftBarButtonItem:nil];
            [self cs_setLeftBarButtonItems:@[[self leftFixedSpaceItem], leftBarButtonItem]];
        }
        else {
            [self cs_setLeftBarButtonItems:nil];
            [self cs_setLeftBarButtonItem:leftBarButtonItem];
        }
    }
    else {
        [self cs_setLeftBarButtonItem:leftBarButtonItem];
    }
}

- (void)cs_setLeftBarButtonItems:(NSArray *)leftBarButtonItems
{
    if (iOS7_OR_LATER && leftBarButtonItems && leftBarButtonItems.count > 0 ) {
        
        NSMutableArray * items = [[NSMutableArray alloc] initWithCapacity:leftBarButtonItems.count + 1];
        
        [items addObject:[self leftFixedSpaceItem]];
        [items addObjectsFromArray:leftBarButtonItems];
        
        [self cs_setLeftBarButtonItems:items];
    }
    else {
        [self cs_setLeftBarButtonItems:leftBarButtonItems];
    }
}

- (void)cs_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    // iOS 11 以上由 UINavigationBar + Adjust 类别处理。此处不处理
    if (iOS11_OR_LATER) {
        [self cs_setRightBarButtonItem:rightBarButtonItem];
    }
    else if (iOS7_OR_LATER) {
        
        if (rightBarButtonItem && (rightBarButtonItem.customView != nil || rightBarButtonItem.image != nil)) {
            
            [self cs_setRightBarButtonItem:nil];
            [self cs_setRightBarButtonItems:@[[self rightFixedSpaceItem], rightBarButtonItem]];
        }
        else {
            [self cs_setRightBarButtonItems:nil];
            [self cs_setRightBarButtonItem:rightBarButtonItem];
        }
    }
    else {
        [self cs_setRightBarButtonItem:rightBarButtonItem];
    }
}

- (void)cs_setRightBarButtonItems:(NSArray *)rightBarButtonItems
{
    if (iOS7_OR_LATER && rightBarButtonItems && rightBarButtonItems.count > 0) {
        
        NSMutableArray * items = [[NSMutableArray alloc] initWithCapacity:rightBarButtonItems.count + 1];
        
        [items addObject:[self rightFixedSpaceItem]];
        [items addObjectsFromArray:rightBarButtonItems];
        
        [self cs_setRightBarButtonItems:items];
    }
    else {
        [self cs_setRightBarButtonItems:rightBarButtonItems];
    }
}


#pragma mark - SET & GET
/**
  *  @brief   iOS 11 以下调整导航栏左侧与屏幕间距的 item
  */
- (UIBarButtonItem *)leftFixedSpaceItem
{
    UIBarButtonItem * fixedSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceItem.width = L_SCREEN_MARGIN - 16;
    
    return fixedSpaceItem;
}

/**
  *  @brief   iOS 11 以下调整导航栏右侧与屏幕间距的 item
  */
- (UIBarButtonItem *)rightFixedSpaceItem
{
    UIBarButtonItem * fixedSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceItem.width = R_SCREEN_MARGIN - 16;
    
    return fixedSpaceItem;
}

@end
