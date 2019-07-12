//
//  WeakProxy.h
//  NSProxy
//
//  Created by CYKJ on 2019/7/12.
//  Copyright © 2019年 D. All rights reserved.


#import <Foundation/Foundation.h>

/**
  *  @brief   NSProxy 用于处理循环引用。PS：iOS10 以上苹果官方给出了 NSTimer 的 block 方式，已经可以解决循环引用的问题。
  */
@interface WeakProxy : NSProxy

+ (instancetype)proxyWithTarget:(id)target;

@end
