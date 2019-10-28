//
//  ProtocolVC.m
//  NSObject
//
//  Created by CYKJ on 2019/10/25.
//  Copyright © 2019年 D. All rights reserved.


#import "ProtocolVC.h"

@interface ProtocolVC ()

@end


@implementation ProtocolVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    /*
             ProtocolA --- (null)
             ProtocolB --- (null)
             ProtocolC --- <Protocol: 0x10438aaa8>
     
             ProtocolA、ProtocolB 竟然是 null。为什么会取不到值呢?
             */
    NSLog(@"ProtocolA --- %@", NSProtocolFromString(@"ProtocolA"));
    NSLog(@"ProtocolB --- %@", NSProtocolFromString(@"ProtocolB"));
    NSLog(@"ProtocolC --- %@", NSProtocolFromString(@"ProtocolC"));
}

@end
