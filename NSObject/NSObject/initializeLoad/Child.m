//
//  Child.m
//  initializeLoad
//
//  Created by CYKJ on 2019/5/14.
//  Copyright © 2019年 D. All rights reserved.


#import "Child.h"

@implementation Child

+ (void)load
{
    NSLog(@"Child Load!");
}

+ (void)initialize
{
    NSLog(@"Child Initialize!");
}

@end
