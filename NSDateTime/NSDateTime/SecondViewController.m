//
//  SecondViewController.m
//  NSDateTime
//
//  Created by CYKJ on 2019/11/18.
//  Copyright © 2019年 D. All rights reserved.


#import "SecondViewController.h"
#import "WeakProxy.h"
#import <objc/runtime.h>
#import "NSTimer+Brex.h"

@interface SecondViewController ()

@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) WeakProxy * weakProxy;  // 解决循环引用
@property (nonatomic, strong) NSObject * objc;  // 解决循环引用

@end


@implementation SecondViewController

- (void)dealloc
{
    NSLog(@"%s", __func__);
    
    [self.timer invalidate];
    self.timer = nil;
    self.objc = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    /* ①、单次执行。
     
                 2019-11-18 21:08:49.298416+0800 NSDateTime[59389:473967] TimerFire
                 2019-11-18 21:08:49.298732+0800 NSDateTime[59389:473967] -[SecondViewController dealloc]
     
                快速 pop 时，如果不销毁 _timer，会等到定时器执行后，再销毁
            */
    _timer = [NSTimer scheduledTimerWithTimeInterval:4.0
                                              target:self
                                            selector:@selector(__timerFire)
                                            userInfo:nil
                                             repeats:NO];
    
    // ②、持续执行。如果不销毁 _timer，则 dealloc 不会执行
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
//                                              target:self
//                                            selector:@selector(__timerFire)
//                                            userInfo:nil
//                                             repeats:YES];
    
    // ③、解决循环引用
//    _weakProxy = [WeakProxy alloc];
//    _weakProxy.target = self;
//
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
//                                              target:_weakProxy
//                                            selector:@selector(__timerFire)
//                                            userInfo:nil
//                                             repeats:YES];
    
    // ④、解决循环引用
//    self.objc = [[NSObject alloc] init];
//    class_addMethod([self.objc class],
//                    @selector(__timerFire),
//                    class_getMethodImplementation(self.class, @selector(__timerFire)),
//                    "v@:");
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
//                                              target:self.objc
//                                            selector:@selector(__timerFire)
//                                            userInfo:nil
//                                             repeats:YES];
    
    // ⑤、解决循环引用
    [NSTimer brexScheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(__timerFire)
                                       userInfo:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 销毁后，dealloc 会执行
//    if (_timer) {
//        [_timer invalidate];
//        _timer = nil;
//    }
}

- (void)__timerFire
{
    NSLog(@"TimerFire");
}

@end
