//
//  KeyObject.m
//  NSDictionary
//
//  Created by CYKJ on 2019/10/30.
//  Copyright © 2019年 D. All rights reserved.


#import "KeyObject.h"

@interface KeyObject ()
{
    NSUInteger _hashValue;
}
@end


@implementation KeyObject

- (instancetype)initWithHashNum:(NSUInteger)num
{
    if (self = [super init]) {
        _hashValue = num;
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    NSLog(@"%s", __func__);
    // 根据 hash 值判断是否是同一个键值
    return ([self hashKeyValue] == [(typeof(self))object hashKeyValue]);
}

- (NSUInteger)hash
{
    NSLog(@"%s", __func__);
    // 返回 hash 值
    return [self hashKeyValue];
}

- (id)copyWithZone:(NSZone *)zone
{
    NSLog(@"%s", __func__);
    
    KeyObject * obj = [KeyObject allocWithZone:zone];
    obj->_hashValue = _hashValue;
    return obj;
}

- (NSUInteger)hashKeyValue
{
    return _hashValue % 3;
}

@end
