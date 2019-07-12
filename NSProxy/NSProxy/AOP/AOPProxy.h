//
//  AOPProxy.h
//  NSProxy
//
//  Created by CYKJ on 2019/7/12.
//  Copyright © 2019年 D. All rights reserved.


#import <Foundation/Foundation.h>

typedef void(^ proxyBlock)(id target, SEL selector);

@interface AOPProxy : NSProxy

+ (instancetype)proxyWithTarget:(id)target;
- (void)inspectSelector:(SEL)selector preSelTask:(proxyBlock)preTask endSelTask:(proxyBlock)endTask;

@end
