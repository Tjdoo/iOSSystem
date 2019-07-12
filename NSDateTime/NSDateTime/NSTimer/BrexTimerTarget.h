//
//  BrexTimerTarget.h
//  Date&Time
//
//  Created by CYKJ on 2019/5/21.
//  Copyright © 2019年 D. All rights reserved.


#import <Foundation/Foundation.h>

@interface BrexTimerTarget : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer * timer;

@end
