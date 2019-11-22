//
//  WeakProxy.m
//  NSDateTime
//
//  Created by CYKJ on 2019/11/18.
//  Copyright © 2019年 D. All rights reserved.


#import "WeakProxy.h"

@implementation WeakProxy

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return _target;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [NSObject methodSignatureForSelector:@selector(init)];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    void * null;
    [invocation setReturnValue:null];
}

@end
