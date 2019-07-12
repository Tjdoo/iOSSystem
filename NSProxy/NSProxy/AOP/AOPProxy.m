//
//  AOPProxy.m
//  NSProxy
//
//  Created by CYKJ on 2019/7/12.
//  Copyright © 2019年 D. All rights reserved.


#import "AOPProxy.h"


@interface AOPProxy ()

@property (nonatomic, strong) id target;
@property (nonatomic, strong) NSMutableDictionary * preSelTaskDic;
@property (nonatomic, strong) NSMutableDictionary * endSelTaskDic;

@end


@implementation AOPProxy

+ (instancetype)proxyWithTarget:(id)target
{
    AOPProxy * proxy = [AOPProxy alloc];
    proxy.target = target;
    return proxy;
}

- (void)inspectSelector:(SEL)selector preSelTask:(proxyBlock)preTask endSelTask:(proxyBlock)endTask
{
    if (selector == nil)
        return;
    
    [self.preSelTaskDic setValue:preTask forKey:NSStringFromSelector(selector)];
    [self.endSelTaskDic setValue:endTask forKey:NSStringFromSelector(selector)];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [_target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    if ([_target respondsToSelector:invocation.selector]) {
        
        // before
        NSString * seletor = NSStringFromSelector(invocation.selector);
        proxyBlock preBlock = [self.preSelTaskDic valueForKey:seletor];
        if (preBlock) {
            preBlock(_target, invocation.selector);
        }
        
        [invocation invokeWithTarget:_target];
        
        // after
        proxyBlock endBlock = [self.endSelTaskDic valueForKey:seletor];
        if (endBlock) {
            endBlock(_target, invocation.selector);
        }
    }
}


#pragma mark - GET

- (NSMutableDictionary *)preSelTaskDic
{
    if (_preSelTaskDic == nil) {
        _preSelTaskDic = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return _preSelTaskDic;
}

- (NSMutableDictionary *)endSelTaskDic
{
    if (_endSelTaskDic == nil) {
        _endSelTaskDic = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return _endSelTaskDic;
}

@end
