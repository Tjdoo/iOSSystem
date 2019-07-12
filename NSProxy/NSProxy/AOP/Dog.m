//
//  Dog.m
//  NSProxy
//
//  Created by CYKJ on 2019/7/12.
//  Copyright © 2019年 D. All rights reserved.


#import "Dog.h"

@implementation Dog

- (NSString *)barking:(NSInteger)months
{
    return months > 3 ? @"汪汪!" : @"鞥鞥!";
}

@end
