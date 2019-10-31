//
//  Singleton2.h
//  Singleton
//
//  Created by CYKJ on 2019/5/14.
//  Copyright © 2019年 D. All rights reserved.


#import <Foundation/Foundation.h>

/*   单例实现方式 2 */
@interface Singleton2 : NSObject <NSCopying, NSMutableCopying>

+ (instancetype)sharedSingleton;
+ (void)deallocSingleton;

+ (instancetype)new __attribute__((unavailable("Singleton2类只能初始化一次")));
- (instancetype)copy __attribute__((unavailable("Singleton2类只能初始化一次")));
- (instancetype)mutableCopy __attribute__((unavailable("Singleton2类只能初始化一次")));

@end
