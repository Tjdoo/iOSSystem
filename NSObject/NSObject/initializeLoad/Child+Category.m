//
//  Child+Category.m
//  initializeLoad
//
//  Created by CYKJ on 2019/5/14.
//  Copyright © 2019年 D. All rights reserved.


#import "Child+Category.h"

@implementation Child (Category)

+ (void)load
{
    NSLog(@"Category Load!");
}

+ (void)initialize
{
    NSLog(@"Category Initialize!");
}

@end
