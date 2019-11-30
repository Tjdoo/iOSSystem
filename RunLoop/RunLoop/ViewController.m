//
//  ViewController.m
//  RunLoop
//
//  Created by CYKJ on 2019/7/9.
//  Copyright © 2019年 D. All rights reserved.


#import "ViewController.h"
#import "Monitor1.h"
#import "Monitor2.h"


@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 开启监控
//    [[Monitor1 sharedInstance] startMonitor];
    [[Monitor2 sharedInstance] startMonitor];
}

- (IBAction)forEvent:(UIButton *)sender
{
    for (int i = 0; i < 10000; i++) {
        NSLog(@"forEvent : %d", i);
    }
}

- (IBAction)logMonitorStack:(id)sender
{
//    [[Monitor1 sharedInstance] logStackInfo];
    [[Monitor2 sharedInstance] logStackInfo];
}

- (IBAction)stopMonitor:(id)sender
{
//    [[Monitor1 sharedInstance] endMonitor];  // TODO
    [[Monitor2 sharedInstance] endMonitor];
}

@end
