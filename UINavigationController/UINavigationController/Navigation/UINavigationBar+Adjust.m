//
//  UINavigationBar+Adjust.m
//  Demo
//
//  Created by D on 2018/3/23.
//  Copyright © 2018年 D. All rights reserved.


#import "UINavigationBar+Adjust.h"
#import <objc/runtime.h>
#import "NavigationConstants.h"


@implementation UINavigationBar (Adjust)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethodWithOriginSel:@selector(layoutSubviews)
                                     swizzledSel:@selector(cs_layoutSubviews)];
    });
}

-(void)cs_layoutSubviews
{
    [self cs_layoutSubviews];
    
    /*
                iOS 11 下视图的结构:
                        UINavigationBar -》UINavigationBarContentView -》 leftBarButtonItems / rightBarButtonItems -》item
     
                UINavigationBarContentView 平铺在导航栏中，是各个按钮（item）的父视图。该视图的所有的子视图都会有一个 layoutMargins 被占，也就是系统调整的占位，我们只要把这个置空就行了。
             */
    
    if (iOS11_OR_LATER) {
        
        // 将 UINavigationBar 的 layoutMargins 置为 zero，这样整个 bar 就跟一个普通视图一样
        self.layoutMargins = UIEdgeInsetsZero;
        
        [self.subviews enumerateObjectsUsingBlock:^( __kindof UIView * _Nonnull obj,
                                                     NSUInteger idx,
                                                     BOOL * _Nonnull stop) {
            // 查找 'UINavigationBarContentView'
            if ([NSStringFromClass(obj.class) containsString:@"ContentView"]) {
                
                obj.layoutMargins = UIEdgeInsetsMake( 0,
                                                      self.lMarginToScreen,
                                                      0,
                                                      self.rMarginToScreen);
                *stop = YES;
            }
        }];
    }
}

+ (void)swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel
{
    Method originMethod   = class_getInstanceMethod(self, oriSel);
    Method swizzledMethod = class_getInstanceMethod(self, swiSel);
    
    [self swizzleMethodWithOriginSel:oriSel oriMethod:originMethod swizzledSel:swiSel swizzledMethod:swizzledMethod class:self];
}

/// 交换方法的实现
+ (void)swizzleMethodWithOriginSel:(SEL)oriSel
                         oriMethod:(Method)oriMethod
                       swizzledSel:(SEL)swizzledSel
                    swizzledMethod:(Method)swizzledMethod
                             class:(Class)cls
{
    BOOL didAddMethod = class_addMethod(cls, oriSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    }
    else {
        method_exchangeImplementations(oriMethod, swizzledMethod);
    }
}


#pragma mark - SET & GET
/// 左侧间距
- (void)setLMarginToScreen:(CGFloat)lMarginToScreen
{
    objc_setAssociatedObject( self,
                              @selector(lMarginToScreen),
                              @(lMarginToScreen),
                              OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)lMarginToScreen
{
    NSNumber * margin = (NSNumber *)objc_getAssociatedObject( self,
                                                              @selector(lMarginToScreen));
    if(margin == nil) {
        return L_SCREEN_MARGIN;
    }
    return [margin floatValue];
}

/// 右侧间距
- (void)setRMarginToScreen:(CGFloat)rMarginToScreen
{
    objc_setAssociatedObject( self,
                              @selector(rMarginToScreen),
                              @(rMarginToScreen),
                              OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)rMarginToScreen
{
    NSNumber * margin = (NSNumber *)objc_getAssociatedObject( self,
                                                              @selector(rMarginToScreen));
    if(margin == nil) {
        return R_SCREEN_MARGIN;
    }
    return [margin floatValue];
}

@end
