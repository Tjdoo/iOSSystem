//
//  WeakProxy.h
//  NSDateTime
//
//  Created by CYKJ on 2019/11/18.
//  Copyright © 2019年 D. All rights reserved.


#import <Foundation/Foundation.h>

/**  利用中间者处理 NSTimer  循环引用m，打破 NSTimer 对 self 的强引用   **/
@interface WeakProxy : NSProxy

@property (nonatomic, weak) id target;

@end
