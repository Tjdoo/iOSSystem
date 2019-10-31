//
//  SingletonVC.m
//  NSObject
//
//  Created by CYKJ on 2019/10/25.
//  Copyright © 2019年 D. All rights reserved.


#import "SingletonVC.h"
#import "Singleton1.h"
#import "Singleton2.h"

@interface SingletonVC ()

@end


@implementation SingletonVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Singleton1 * s11 = [Singleton1 sharedSingleton];
    Singleton1 * s12 = [Singleton1 sharedSingleton];
    NSLog(@"s11 = %@, s12 = %@", s11, s12); // s11 = <Singleton1: 0x600001350ae0>, s12 = <Singleton1: 0x600001350ae0>
    
//    Singleton2 * s21 = [Singleton2 sharedSingleton];
//    Singleton2 * s22 = [Singleton2 sharedSingleton];
//    NSLog(@"s21 = %@, s22 = %@", s21, s22); // s21 = <Singleton2: 0x600001350ac0>, s22 = <Singleton2: 0x600001350ac0>
//
//    // 销毁单例
//    [Singleton2 deallocSingleton];
    
    Singleton2 * s23 = [Singleton2 sharedSingleton];
    Singleton2 * s24 = [Singleton2 sharedSingleton];
    NSLog(@"s23 = %@, s24 = %@", s23, s24); // s23 = <Singleton2: 0x6000013509d0>, s24 = <Singleton2: 0x6000013509d0>
    
    s23 = nil;

    NSLog(@"s23 = %@, s24 = %@", s23, s24); // s23 = (null), s24 = <Singleton2: 0x6000013509d0>
    
//    [s23 copy];
//    [Singleton2 new];
}

@end
