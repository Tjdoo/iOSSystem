//
//  BrexTimerTarget.m
//  Date&Time
//
//  Created by CYKJ on 2019/5/21.
//  Copyright © 2019年 D. All rights reserved.


#import "BrexTimerTarget.h"

@implementation BrexTimerTarget

- (void)brexTimerTargetAction:(NSTimer *)timer
{
    if (self.target) {
        [self.target performSelector:self.selector withObject:timer afterDelay:0.0];
    }
    else {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
