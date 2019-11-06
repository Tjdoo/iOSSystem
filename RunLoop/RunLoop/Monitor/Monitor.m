//
//  Monitor.m
//  RunLoop
//
//  Created by CYKJ on 2019/7/9.
//  Copyright © 2019年 D. All rights reserved.


#import "Monitor.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>


@interface Monitor ()
{
    CFRunLoopObserverRef _observer;  // 观察对象
    dispatch_semaphore_t _semaphore; // 信号量
    CFRunLoopActivity _activity;  // runloop 活动
    NSInteger _countTime;  // 记录超时次数
    NSMutableArray * _backTrace;  // 记录堆栈数组
}
@end


@implementation Monitor

static Monitor * instance;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

/**
  *  @brief   监听监听方法
  */
static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    Monitor * monitor = [Monitor sharedInstance];
    monitor->_activity = activity;
    dispatch_semaphore_signal(monitor->_semaphore);
}

- (void)startMonitor
{
    CFRunLoopObserverContext context = { 0, (__bridge void *)self, NULL, NULL };
    /*
             参数 1：默认的生成器
             参数 2：监听 runloop 的哪些活动
             参数 3：是否重复监听
             参数 5：监听回调
             参数 6：上下文
         */
    _observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                        kCFRunLoopAllActivities,
                                        YES,
                                        0,
                                        &runLoopObserverCallBack,
                                        &context);
    // 添加 main runloop 监听事件
    CFRunLoopAddObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
    
    _semaphore = dispatch_semaphore_create(0);
    
    // 开启子线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 持续处理
        while (1) {
            // 超时时间设为 50 毫秒
            long result = dispatch_semaphore_wait(self->_semaphore, dispatch_time(DISPATCH_TIME_NOW, 50 *     NSEC_PER_MSEC));
            
            // 发生超时
            if (result != 0) {
                // kCFRunLoopBeforeSources ：Inside the event processing loop before any sources are processed.
                // kCFRunLoopAfterWaiting ：Inside the event processing loop after the run loop wakes up, but before processing the event that woke it up. This activity occurs only if the run loop did in fact go to sleep during the current loop.
                if (self->_activity == kCFRunLoopBeforeSources
                    || self->_activity == kCFRunLoopAfterWaiting) {
                    // 连续五次超时 50ms 认为是卡顿
                    if (++self->_countTime < 5) {
                        continue;
                    }
                    [self storeStackInfo];
                }
                self->_countTime = 0;
            }
        }
    });
}

/**
  *  @brief   存储堆栈信息
  */
- (void)storeStackInfo
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    // 每次重新存储
    _backTrace = [NSMutableArray arrayWithCapacity:frames];
    
    for (int i = 0; i < frames; i++){
        [_backTrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    NSLog(@"Store Stack Info!");
}

/**
  *  @brief   打印堆栈信息
  */
- (void)logStackInfo
{
    NSLog(@"\n %@ \n", _backTrace);
}


- (void)endMonitor
{
    if (_observer == nil)
        return;
    
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
    CFRelease(_observer);
    _observer = nil;
}

@end
