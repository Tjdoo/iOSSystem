//
//  WeakProxy.m
//  NSProxy
//
//  Created by CYKJ on 2019/7/12.
//  Copyright © 2019年 D. All rights reserved.


#import "WeakProxy.h"

@interface WeakProxy()
@property (nonatomic, weak) id target;  // 设定为弱引用。
@end


@implementation WeakProxy

+ (instancetype)proxyWithTarget:(id)target
{
    WeakProxy * proxy = [WeakProxy alloc];
    proxy.target = target;
    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL seletor = invocation.selector;
    if ([self.target respondsToSelector:seletor]) {
        [invocation invokeWithTarget:self.target];
    }
}

@end
