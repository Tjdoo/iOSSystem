//
//  Son.m
//  NSObject
//
//  Created by CYKJ on 2019/10/28.
//  Copyright © 2019年 D. All rights reserved.


#import "Son.h"

@implementation Son

- (instancetype)init
{
    if (self = [super init]) {
        NSLog(@"%@", __a);
        NSLog(@"%@", self.b);
//        NSLog(@"%@", __c);  // 子类无法访问 .m 中的成员变量
//        NSLog(@"%@", self.d);   // 子类无法继承 .m 中的属性
//        NSLog(@"%@", __e);  // 子类无法访问 .m 中 @implementation 中的 @private 成员变量
//        NSLog(@"%@", __f);  // 子类无法访问 .m 中 @implementation 中的 @public 成员变量
    }
    return self;
}

- (void)sayHello
{
    NSLog(@"Son Class Override SayHello Func!");
}

@end
