//
//  WeakSingleton.m
//  NSObject
//
//  Created by CYKJ on 2019/11/19.
//  Copyright © 2019年 D. All rights reserved.


#import "WeakSingleton.h"

@implementation WeakSingleton

// 如果在 OC 中保证创建的对象始终相同，应该重写 allocWithZone: 和 copyWithZone: 方法
+ (instancetype)sharedInstance
{
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    // 弱引用
    static __weak WeakSingleton * instance;
    // 强引用
    WeakSingleton * strongInstance = instance;
    
    @synchronized(self) {
        if (strongInstance == nil) {
            strongInstance = [super allocWithZone:zone];
            instance = strongInstance;
        }
    }
    return strongInstance;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
