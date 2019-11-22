//
//  Inline.m
//  NSObject
//
//  Created by CYKJ on 2019/11/21.
//  Copyright © 2019年 D. All rights reserved.


#import "Inline.h"

// 内联函数。
// GCC 在不进行优化时不内联任何函数，除非为该函数指定 always_inline 属性
// Debug 环境优化等级为 None，Release 环境优化等级为 Fastest，Smallest。在 Release 环境下，getLog 方法也会被优化
inline static NSString * getLog(void)
{
    return @"Success!";
}

inline static NSString * getLog2(void) __attribute__((always_inline))
{
    return @"Fail!";
}

// 普通的 c 函数
void sayHello(void)
{
    NSLog(@"Hello world!");
}

NSString * getWeekday(int type)
{
    switch (type) {
        case 1:
            return @"星期一";
        case 2:
            return @"星期二";
        case 3:
            return @"星期三";
        default:
            return @"";
    }
}


@implementation Inline

- (void)dowork
{
    NSString * log = getLog();
    NSLog(@"%@", log);

    NSString * log2 = getLog2();
    NSLog(@"%@", log2);
    
    sayHello();
    
    NSString * weekday = getWeekday(2);
    NSLog(@"%@", weekday);
}

@end
