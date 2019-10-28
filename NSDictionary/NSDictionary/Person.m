//
//  Person.m
//  NSDictionary
//
//  Created by CYKJ on 2019/10/25.
//  Copyright © 2019年 D. All rights reserved.
//

#import "Person.h"

@implementation Person

//- (instancetype)copyWithZone:(NSZone *)zone
//{
//    return self;   // https://www.jianshu.com/p/66174593b836
//}

- (instancetype)copyWithZone:(NSZone *)zone
{
    Person * p = [[Person allocWithZone:zone] init];
    if (p) {
        
    }
    return p;
}

//- (BOOL)isEqual:(id)object
//{
//    return (self == object);
//}
//
//- (NSUInteger)hash
//{
//    return Person.hash;
//}

@end
