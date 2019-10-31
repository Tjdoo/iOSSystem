//
//  Singleton2.m
//  Singleton
//
//  Created by CYKJ on 2019/5/14.
//  Copyright © 2019年 D. All rights reserved.


#import "Singleton2.h"

@implementation Singleton2

static Singleton2 * singleton2;
static dispatch_once_t onceToken1;  // typedef long dispatch_once_t，默认为 0
static dispatch_once_t onceToken2;

/**
 *  @brief    单例的创建。采用 GCD 创建：

            初始时，onceToken = 0，线程执行 dispatch_once 的 block 中代码
                            onceToken = -1，线程不执行 dispatch_once 的 block 中代码
                            onceToken = 其他值，线程被阻塞，等待 onceToken 值改变
 
            用途：限制创建、提供全局调用、节约资源和提高性能。参考：https://links.jianshu.com/go?to=https%3A%2F%2Fjuejin.im%2Fpost%2F5b15020a5188257d4f0d7c53
 
            常见的应用场景：
                 •   UIApplication
                 •   NSNotificationCenter
                 •   NSFileManager
                 •   NSUserDefaults
                 •   NSURLCache
                 •   NSHTTPCookieStorage
  */
+ (instancetype)sharedSingleton
{
    dispatch_once(&onceToken1, ^{
        singleton2 = [[self alloc] init];
    });
    return singleton2;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    dispatch_once(&onceToken2, ^{
        singleton2 = [super allocWithZone:zone];
    });
    return singleton2;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return [Singleton2 sharedSingleton];
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone
{
    return [Singleton2 sharedSingleton];
}

/**
  *  @brief    单例的销毁
  */
+ (void)deallocSingleton
{
    onceToken1 = 0; // 只有置成 0，GCD 才会认为它从未执行过，这样才能保证下次再次调用 shareInstance 的时候能够再次创建对象
    onceToken2 = 0;
//    [singleton release];  // MRC
    singleton2 = nil;
}

- (void)dealloc
{
    // 当 Singleton2 对象赋值为 nil 时，dealloc 方法会被调用
    NSLog(@"%s", __func__);
}

@end
