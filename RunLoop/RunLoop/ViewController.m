//
//  ViewController.m
//  RunLoop
//
//  Created by CYKJ on 2019/7/9.
//  Copyright © 2019年 D. All rights reserved.


#import "ViewController.h"
#import "Monitor.h"


@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 开启监控
    [[Monitor sharedInstance] startMonitor];
}

- (IBAction)forEvent:(UIButton *)sender
{
    for (int i = 0; i < 10000; i++) {
        NSLog(@"forEvent : %d", i);
    }
}

- (IBAction)logMonitorStack:(id)sender
{
    [[Monitor sharedInstance] logStackInfo];
}

- (IBAction)stopMonitor:(id)sender
{
    [[Monitor sharedInstance] endMonitor];  // TODO
}

@end
