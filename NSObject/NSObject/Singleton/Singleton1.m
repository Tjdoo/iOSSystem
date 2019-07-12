//
//  Singleton1.m
//  Singleton
//
//  Created by CYKJ on 2019/5/14.
//  Copyright © 2019年 D. All rights reserved.


#import "Singleton1.h"

@implementation Singleton1

static Singleton1 * singleton;

/**
  *  @brief   单例的创建
  */
+ (instancetype)sharedSingleton
{
    @synchronized (self) {
        if (singleton == nil) {
            singleton = [[self alloc] init];
        }
    }
    return singleton;
}

/**
  *  @brief    单例的销毁
  */
+ (void)deallocSingleton
{
//    [singleton release]; // MRC
    singleton = nil;
}

@end
