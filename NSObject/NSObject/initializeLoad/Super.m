//
//  Super.m
//  initializeLoad
//
//  Created by CYKJ on 2019/5/14.
//  Copyright © 2019年 D. All rights reserved.


#import "Super.h"

@implementation Super

+ (void)load
{
    NSLog(@"Super Load!");
}

+ (void)initialize
{
    NSLog(@"Super Initialize!");
}

@end
