//
//  Monitor2.h
//  RunLoop
//
//  Created by CYKJ on 2019/11/25.
//  Copyright © 2019年 D. All rights reserved.


#import <Foundation/Foundation.h>

/**
  *  @brief   卡顿检测工具类（二）
  */
@interface Monitor2 : NSObject

+ (instancetype)sharedInstance;

- (void)startMonitor;

- (void)endMonitor;

- (void)logStackInfo;

@end
