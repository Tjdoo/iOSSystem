//
//  Monitor2.m
//  RunLoop
//
//  Created by CYKJ on 2019/11/25.
//  Copyright © 2019年 D. All rights reserved.


#import "Monitor2.h"
#import <QuartzCore/CABase.h>
#include <execinfo.h>


@interface Monitor2 ()
{
    CFRunLoopObserverRef __observer;
    CFRunLoopTimerRef __timer;  // 定时器
    NSMutableArray * __backTrace;  // 记录堆栈数组
    NSInteger __countTime;  // 记录超时次数
}
@property (nonatomic, strong) NSThread * monitorThread;
@property (nonatomic, assign) NSTimeInterval ti;
@property (nonatomic, assign, getter=isExcuting) BOOL excuting;  // 是否正在执行任务

@end


@implementation Monitor2

static Monitor2 * __instance__;

+ (instancetype)sharedInstance
{
    return  [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance__ = [super allocWithZone:zone];
        __instance__.monitorThread = [[NSThread alloc] initWithTarget:self
                                                             selector:@selector(monitorThreadEntry)
                                                               object:nil];
        [__instance__.monitorThread start];
    });
    return __instance__;
}

/**
  *  @brief   启动子线程的 runloop
  */
+ (void)monitorThreadEntry
{
    @autoreleasepool {
        [[NSThread currentThread] setName:@"Monitor"];
        NSRunLoop * runloop = [NSRunLoop currentRunLoop];
        [runloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runloop run];
    }
}

- (void)startMonitor
{
    // 已经启动检测
    if (__observer) {
        return;
    }
    
    // 创建 observer
    CFRunLoopObserverContext ctx = { 0, (__bridge void *)self, NULL, NULL, NULL };
    /*
            参数 1：用于分配 observer 对象的内存
            参数 2：用于设置 observer 所要关注的事件
            参数 3：用于标识 observer 是在第一次进入 runloop 时执行还是每次进入 runloop 处理时都执行
            参数 4：用于设置 observer 的优先级
            参数 5：用于设置 observer 的回调函数
            参数 6：用于设置 observer 的运行环境
         */
    __observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                         kCFRunLoopAllActivities,
                                         YES,
                                         0,
                                         &runLoopObserverCallBack,
                                         &ctx);
    // 将 observer 添加到主线程的 runloop 中
    CFRunLoopAddObserver(CFRunLoopGetMain(), __observer, kCFRunLoopCommonModes);
    // 创建一个 timer，并添加到子线程的 runloop 中
    [self performSelector:@selector(addTimerToMonitorThread)
                 onThread:self.monitorThread
               withObject:nil
            waitUntilDone:NO
                    modes:@[ NSRunLoopCommonModes ]];
}

/**
  *  @brief   observer 回调
 
 1、因为主线程的 block、交互事件以及其他任务都是在 kCFRunLoopBeforeSources -》 kCFRunLoopBeforeWaiting 之前执行；
 2、所以在开始执行 Sources 时，即 kCFRunLoopBeforeSources 状态时，记录一下时间，并把正在执行任务的标记置为 YES；
 3、将要进入睡眠状态时，即 kCFRunLoopBeforeWaiting 状态时，将正在执行任务的标记置为 NO。
 
 【Run Loop Observer Activities】
 
    typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
            kCFRunLoopEntry = (1UL << 0),    // 进入RunLoop循环(这里其实还没进入)
            kCFRunLoopBeforeTimers = (1UL << 1),       // RunLoop 要处理timer了
            kCFRunLoopBeforeSources = (1UL << 2),     // RunLoop 要处理source了
            kCFRunLoopBeforeWaiting = (1UL << 5),    // RunLoop 要休眠了
            kCFRunLoopAfterWaiting = (1UL << 6),      // RunLoop 醒了
            kCFRunLoopExit = (1UL << 7),                     // RunLoop 退出（和 kCFRunLoopEntry 对应）
            kCFRunLoopAllActivities = 0x0FFFFFFFU
    };
  */
void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void * info)
{
    Monitor2 * monitor = (__bridge Monitor2 *)info;
    switch (activity) {
        //The entrance of the run loop, before entering the event processing loop.
        //This activity occurs once for each call to CFRunLoopRun and CFRunLoopRunInMode
        case kCFRunLoopEntry:  // 即将进入 runloop
        {
            
        }
            break;
          
        //Inside the event processing loop before any timers are processed
        case kCFRunLoopBeforeTimers:  // 即将处理 Timer
        {
            
        }
            break;
            
        //Inside the event processing loop before any sources are processed
        case kCFRunLoopBeforeSources:  // 即将处理 Source
        {
            monitor.ti = CACurrentMediaTime();
            monitor.excuting = YES;
        }
            break;
            
        //Inside the event processing loop before the run loop sleeps, waiting for a source or timer to fire.
        //This activity does not occur if CFRunLoopRunInMode is called with a timeout of 0 seconds.
        //It also does not occur in a particular iteration of the event processing loop if a version 0 source fires
        case kCFRunLoopBeforeWaiting:  // 即将进入休眠。这个时候处理 UI 操作
        {
            monitor.excuting = NO;
        }
            break;
            
        //Inside the event processing loop after the run loop wakes up, but before processing the event that woke it up.
        //This activity occurs only if the run loop did in fact go to sleep during the current loop
        case kCFRunLoopAfterWaiting:  // 从休眠中醒来开始做事情了
        {

        }
            break;
            
        //The exit of the run loop, after exiting the event processing loop.
        //This activity occurs once for each call to CFRunLoopRun and CFRunLoopRunInMode
        case kCFRunLoopExit:  // 即将退出 runloop
        {
            
        }
            break;
            
        case kCFRunLoopAllActivities:
        {
            
        }
            break;
        default:
            break;
    }
}

/**
  *  @brief    添加定时器到 runloop（子线程） 中
  */
- (void)addTimerToMonitorThread
{
    if (__timer) {
        return;
    }
    
    // 创建 timer
    CFRunLoopRef currentRunLoop = CFRunLoopGetCurrent();
    CFRunLoopTimerContext ctx = { 0, (__bridge void *)self, NULL, NULL, NULL };
    
    __timer = CFRunLoopTimerCreate(kCFAllocatorDefault,
                                   0.1,
                                   0.1,
                                   0,
                                   0,
                                   &runLoopTimerCallBack,
                                   &ctx);
    // 添加到子线程的 runloop 中
    CFRunLoopAddTimer(currentRunLoop, __timer, kCFRunLoopCommonModes);
}

void runLoopTimerCallBack(CFRunLoopTimerRef timer, void *info)
{
    Monitor2 * monitor = (__bridge Monitor2 *)info;
    
    // 即 runloop 已经进入休眠。kCFRunLoopBeforeWaiting
    if (!monitor.isExcuting) {
        return;
    }
    
    // 如果主线程正在执行任务，并且这一次 loop 执行到现在还没有执行完，需要计算时间差
    NSTimeInterval excute = CACurrentMediaTime() - monitor.ti;
    
    // timer 每 0.01 秒执行一次，如果当前正在执行任务的状态为 YES，并且从开始执行到现在的时间大于阙值，则把堆栈信息保存下来，便于后面处理
    // 为了能够捕获到堆栈信息，这里把  timer 的间隔设置很小（0.01），而评定为卡顿的阙值也设置得很小（0.01）
    if (excute > 0.01) {
        NSLog(@"主线程执行了%f秒", excute);
        [monitor handleStackInfo];
    }
}

- (void)handleStackInfo
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    // 每次重新存储
    __backTrace = [NSMutableArray arrayWithCapacity:frames];
    
    for (int i = 0; i < frames; i++){
        [__backTrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    NSLog(@"Store Stack Info!");
}

/**
  *  @brief   打印堆栈信息
  */
- (void)logStackInfo
{
    NSLog(@"\n %@ \n", __backTrace);
}


- (void)endMonitor
{
    if (__observer == nil)
        return;
    
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), __observer, kCFRunLoopCommonModes);
    CFRelease(__observer);
    __observer = nil;
}


@end
