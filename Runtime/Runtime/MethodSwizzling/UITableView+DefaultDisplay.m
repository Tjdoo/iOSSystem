//
//  UITableView+DefaultDisplay.m
//  Runtime
//
//  Created by CYKJ on 2019/6/22.
//  Copyright © 2019年 D. All rights reserved.


#import "UITableView+DefaultDisplay.h"
#import <objc/runtime.h>


const char * ImageViewKey;

@implementation UITableView (DefaultDisplay)

+ (void)load
{
    [UITableView exchangeInstanceMethod:self
                             method1Sel:@selector(reloadData)
                             method2Sel:@selector(cs_reloadData)];
}

- (void)cs_reloadData
{
    // 去掉多余的线条
    self.tableFooterView = [UIView new];
    
    [self cs_reloadData];
    
    [self checkDataSource];
}

- (void)checkDataSource
{
    id<UITableViewDataSource> dataSource = self.dataSource;
    if (dataSource) {
        NSInteger sections = ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)] ? [dataSource numberOfSectionsInTableView:self] : 1);
        
        NSInteger rows = 0;
        for (NSInteger i = 0; i < sections; i++) {
            rows += [dataSource tableView:self numberOfRowsInSection:i];
        }
        
        // 没有内容
        if (rows == 0) {
            [self addSubview:self.imageView];
        }
        else {
            self.imageView.hidden = YES;
        }
    }
}


#pragma mark - Tool
/**
  *   @brief   对象方法的交换
  *
  *   @param   anClass    哪个类
  *   @param   method1Sel   方法1（原本的方法）
  *   @param   method2Sel   方法2（替换后的方法）
  */
+ (void)exchangeInstanceMethod:(Class)anClass method1Sel:(SEL)method1Sel method2Sel:(SEL)method2Sel {
    
    
    Method originalMethod = class_getInstanceMethod(anClass, method1Sel);
    Method swizzledMethod = class_getInstanceMethod(anClass, method2Sel);
    
    BOOL didAddMethod =
    class_addMethod(anClass,
                    method1Sel,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(anClass,
                            method2Sel,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


#pragma mark - GET & SET

- (void)setImageView:(UIImageView *)imageView
{
    // OBJC_ASSOCIATION_RETAIN_NONATOMIC 内存管理语义
    objc_setAssociatedObject(self, &ImageViewKey, imageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)imageView
{
    UIImageView * objc = objc_getAssociatedObject(self, &ImageViewKey);
    if (objc == nil) {
        objc = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        objc.center = self.center;
        objc.image  = [UIImage imageNamed:@"NoData"];
        [self setImageView:objc];
    }
    return objc;
}

@end
