//
//  Monitor1.h
//  RunLoop
//
//  Created by CYKJ on 2019/7/9.
//  Copyright © 2019年 D. All rights reserved.


#import <Foundation/Foundation.h>

@interface Monitor1 : NSObject
/**
  *  @brief   单例方法
  */
+ (instancetype)sharedInstance;
/**
  *  @brief   开始监控
  */
- (void)startMonitor;
/**
  *  @brief   结束监控
  */
- (void)endMonitor;

- (void)logStackInfo;

@end
