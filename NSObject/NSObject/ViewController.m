//
//  ViewController.m
//  NSObject
//
//  Created by CYKJ on 2019/7/9.
//  Copyright © 2019年 D. All rights reserved.


#import "ViewController.h"
#import "Singleton1.h"
#import "Singleton2.h"
#import "Child.h"


@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Singleton1 * s11 = [Singleton1 sharedSingleton];
    Singleton1 * s12 = [Singleton1 sharedSingleton];
    NSLog(@"s11 = %@, s12 = %@", s11, s12); // s11 = <Singleton1: 0x600001350ae0>, s12 = <Singleton1: 0x600001350ae0>
    
    Singleton2 * s21 = [Singleton2 sharedSingleton];
    Singleton2 * s22 = [Singleton2 sharedSingleton];
    NSLog(@"s21 = %@, s22 = %@", s21, s22); // s21 = <Singleton2: 0x600001350ac0>, s22 = <Singleton2: 0x600001350ac0>
    
    // 销毁单例
    [Singleton2 deallocSingleton];
    
    Singleton2 * s23 = [Singleton2 sharedSingleton];
    Singleton2 * s24 = [Singleton2 sharedSingleton];
    NSLog(@"s23 = %@, s24 = %@", s23, s24); // s23 = <Singleton2: 0x6000013509d0>, s24 = <Singleton2: 0x6000013509d0>
    
    
    /*
                 2019-05-14 10:37:48.014861+0800 initializeLoad[58526:502689] Super Load!
                 2019-05-14 10:37:48.015433+0800 initializeLoad[58526:502689] Child Load!
                 2019-05-14 10:37:48.015501+0800 initializeLoad[58526:502689] Category Load!
                 2019-05-14 10:37:48.015630+0800 initializeLoad[58526:502689] main()
                 2019-05-14 10:37:48.125029+0800 initializeLoad[58526:502689] Super Initialize!
                 2019-05-14 10:37:48.125190+0800 initializeLoad[58526:502689] Category Initialize!
                 2019-05-14 10:37:48.125351+0800 initializeLoad[58526:502689] Category Initialize!
          */
    [Child instancesRespondToSelector:@selector(sel)];
    [Child initialize];
}

@end
