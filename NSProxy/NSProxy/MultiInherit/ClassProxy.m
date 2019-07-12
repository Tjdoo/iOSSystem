//
//  ClassProxy.m
//  NSProxy
//
//  Created by CYKJ on 2019/7/12.
//  Copyright © 2019年 D. All rights reserved.


#import "ClassProxy.h"
#import <objc/runtime.h>


@interface ClassProxy()

@property (nonatomic, strong) NSMutableArray * targetArray; // 多个 targets 皆可代理
@property (nonatomic, strong) NSMutableDictionary * methodDic;

@end


@implementation ClassProxy

- (void)target:(id)target
{
    [self.targetArray addObject:target];
    [self registMethodWithTarget:target];
}

- (void)handleTargets:(NSArray *)targets
{
    [self.targetArray addObjectsFromArray:targets];
    for (id target in targets) {
        [self registMethodWithTarget:target];
    }
}

/**
  *  @brief   target 和相对应的 method name 做了一个字典来存储，方便获取
  */
- (void)registMethodWithTarget:(id)target
{
    unsigned int countOfMethods = 0;
    Method * method_list = class_copyMethodList([target class], &countOfMethods);
    
    for (int i = 0; i < countOfMethods; i++) {
        
        Method method = method_list[i];
        //得到方法的符号
        SEL sel = method_getName(method);
        //得到方法的符号字符串
        const char *sel_name = sel_getName(sel);
        //得到方法的名字
        NSString * method_name = [NSString stringWithUTF8String:sel_name];
        
        // 存储 methodName - target 的键值对
        self.methodDic[method_name] = target;
    }
    free(method_list);
}

/**
  *  @brief   methodSignatureForSelector: 得到对应的方法签名
  */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    NSMethodSignature * Method;
    NSString * methodName = NSStringFromSelector(sel);
    
    id target = self.methodDic[methodName];
    if (target) {
        Method =  [target methodSignatureForSelector:sel];
    }
    else{
        Method = [super methodSignatureForSelector:sel];
    }
    return Method;
}

/**
  *  @brief   转发
  */
- (void)forwardInvocation:(NSInvocation *)invocation
{
    NSString * methodName = NSStringFromSelector(invocation.selector);
    
    id target = self.methodDic[methodName];
    if (target) {
        [invocation invokeWithTarget:target];
    }
}


#pragma mark - GET

- (NSMutableArray *)targetArray
{
    if (_targetArray == nil) {
        _targetArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _targetArray;
}

- (NSMutableDictionary *)methodDic
{
    if (_methodDic == nil) {
        _methodDic = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return _methodDic;
}

@end
