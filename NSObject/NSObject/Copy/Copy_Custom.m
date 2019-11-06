//
//  Copy_Custom.m
//  NSObject
//
//  Created by CYKJ on 2019/11/4.
//  Copyright © 2019年 D. All rights reserved.
//

#import "Copy_Custom.h"

@implementation Copy_Custom

- (instancetype)copyWithZone:(NSZone *)zone
{
    Copy_Custom * cc = [[Copy_Custom allocWithZone:zone] init];
    cc.aa = self.aa;
    
    return cc;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone
{
    Copy_Custom * cc = [[Copy_Custom allocWithZone:zone] init];
    cc.aa = self.aa;
    
    return cc;
}

@end
