//
//  Singleton1.h
//  Singleton
//
//  Created by CYKJ on 2019/5/14.
//  Copyright © 2019年 D. All rights reserved.


#import <Foundation/Foundation.h>

/*   单例实现方式 1 */
@interface Singleton1 : NSObject

+ (instancetype)sharedSingleton;
+ (void)deallocSingleton;

@end
