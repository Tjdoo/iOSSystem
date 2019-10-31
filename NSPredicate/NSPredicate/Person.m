//
//  Person.m
//  Predicate
//
//  Created by CYKJ on 2019/8/31.
//  Copyright © 2019年 D. All rights reserved.
//

#import "Person.h"

@implementation Person

- (NSString *)description
{
    return [NSString stringWithFormat:@"name = %@, age = %ld", _name, (long)_age];
}

@end
