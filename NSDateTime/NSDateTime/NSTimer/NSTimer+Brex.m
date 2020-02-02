//
//  NSTimer+Brex.m
//  Date&Time
//
//  Created by CYKJ on 2019/5/21.
//  Copyright © 2019年 D. All rights reserved.


#import "NSTimer+Brex.h"
#import "BrexTimerTarget.h"
#import <objc/runtime.h>


@implementation NSTimer (Brex)

+ (instancetype)brexScheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(NSObject *)aTarget selector:(SEL)aSelector userInfo:(id)userInfo
{
    BrexTimerTarget * timerTarget = [[BrexTimerTarget alloc] init];
    timerTarget.target   = aTarget;
    timerTarget.selector = aSelector;
    class_addMethod(timerTarget.class,
                    @selector(brexTimerTargetAction:),
                    class_getMethodImplementation(aTarget.class, aSelector),
                    "v@:");
    
    NSTimer * timer = [NSTimer timerWithTimeInterval:ti
                                              target:timerTarget
                                            selector:@selector(brexTimerTargetAction:)
                                            userInfo:userInfo
                                             repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    timerTarget.timer = timer;
    
    return timerTarget.timer;
}

@end
