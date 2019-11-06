//
//  Person.m
//  Block
//
//  Created by D on 2019/5/4.
//  Copyright © 2019 D. All rights reserved.


#import "Person.h"

// 使用命令：xcrun -sdk iphoneos clang -arch arm64 -rewrite-objc Person.m -o Person.cpp  将 OC 代码转成 C++ 代码

// block 相关代码在当前 Person.cpp 文件中 32659 行

@implementation Person

- (void)test
{
    void(^ block)(void) = ^{
        NSLog(@"%@", self);
        NSLog(@"%@", self.name);
        NSLog(@"%@", _name);
    };
    block();
}

- (instancetype)initWithName:(NSString *)name
{
    if (self = [super init]) {
        self.name = name;
    }
    return self;
}

+ (void)test2
{
    NSLog(@"类方法test2");
}

@end
