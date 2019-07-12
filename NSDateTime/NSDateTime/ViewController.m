//
//  ViewController.m
//  NSDateTime
//
//  Created by CYKJ on 2019/7/9.
//  Copyright © 2019年 D. All rights reserved.


#import "ViewController.h"
#import "TimeInterval.h"
#import "TimeStamp.h"
#import "Timer.h"


@interface ViewController ()

@property (nonatomic, strong) Timer * t;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 时间间隔
    [[[TimeInterval alloc] init] done];
    
    // 时间戳
    //    TimeStamp * ts = [[TimeStamp alloc] init];
    //    NSLog(@"%f", ts.upTime1);
    //    NSLog(@"%ld", ts.upTime2);
    
    // 定时器
    _t = [[Timer alloc] init];
    //    [t performAfterDelay];
    //    [t nsTimer];
    //    [t caDisplayLink];
    //    [_t gcd];
}

@end
