//
//  NilValue.m
//  NSDictionary
//
//  Created by CYKJ on 2019/5/15.
//  Copyright © 2019年 D. All rights reserved.


#import "NilValue.h"

@implementation NilValue

+ (void)exe
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setValue:nil forKey:@"AA"];
}

@end
