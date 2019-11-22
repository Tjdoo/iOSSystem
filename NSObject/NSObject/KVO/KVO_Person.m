//
//  KVO_Person.m
//  NSObject
//
//  Created by CYKJ on 2019/11/18.
//  Copyright © 2019年 D. All rights reserved.
//

#import "KVO_Person.h"

@implementation KVO_Person

/**   模式调整   **/
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    if ([key isEqualToString:@"age"]) {
        return NO; // for custom
    }
    return YES;
}

+ (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet * keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    if ([key isEqualToString:@"dog"]) {
        keyPaths = [NSSet setWithObjects:@"_dog.name", @"_dog.age", nil];
    }
    return keyPaths;
}

@end
