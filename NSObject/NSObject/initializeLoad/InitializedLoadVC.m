//
//  InitializedLoadVC.m
//  NSObject
//
//  Created by CYKJ on 2019/10/25.
//  Copyright © 2019年 D. All rights reserved.


#import "InitializedLoadVC.h"
#import "Child.h"
#import "Person.h"


@interface InitializedLoadVC ()

@end


@implementation InitializedLoadVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"***************************");
    
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
    [Child initialize];  // 分类会覆盖本类的 initialize 实现
    
    // +load 启动时调用，+initialize 初始时调用，只调用一次
    Person * p1 = [[Person alloc] init];
    Person * p2 = [[Person alloc] init];
    
//    NSLog(@"%d", p1->__a);  // Instance variable '__a' is protected
//    NSLog(@"%@", p1.b);
}

@end
