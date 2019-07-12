//
//  Timer.m
//  Date&Time
//
//  Created by CYKJ on 2019/5/21.
//  Copyright © 2019年 D. All rights reserved.


#import "Timer.h"
#import <QuartzCore/CADisplayLink.h>


@interface Timer ()

@property (nonatomic, strong) CADisplayLink * displayLink;
@property (nonatomic, strong) dispatch_source_t timer;  // 注意：将定时器写成属性，是因为内存管理的原因，使用了dispatch_source_create 方法，GCD 是不会帮你管理内存的。

@end


@implementation Timer

- (void)dealloc
{
    NSLog(@"dealloc");
}

/**
  *  @brief   这个方法在 Foundation 框架的 NSRunLoop.h 文件内声明。当我们调用 NSObject 这个方法的时候，在 runloop 的内部是会创建一个Timer 并添加到当前线程的 RunLoop 中。所以如果当前线程没有 RunLoop，则这个方法会失效。而且还有几个很大的缺陷：
 
         ①、这个方法必须在 NSDefaultRunLoopMode 下才能运行；
         ②、因为它基于 RunLoop 实现，所以可能会造成精确度上的问题。
         ③、内存管理上非常容易出问题。当执行 [self performSelector: withObject:afterDelay:] 时，系统会将 self 的引用计数 +1，执行完这个方法时，还会将 self 的引用计数 -1，当方法还没有执行的时候，要返回父视图释放当前视图的时候，self的计数没有减少到 0，而导致无法调用 dealloc 方法，出现了内存泄露。

         Invokes a method of the receiver on the current thread using the default mode after a delay.
 
         This method sets up a timer to perform the aSelector message on the current thread’s run loop. The timer is configured to run in the default mode (NSDefaultRunLoopMode). When the timer fires, the thread attempts to dequeue the message from the run loop and perform the selector. It succeeds if the run loop is running and in the default mode; otherwise, the timer waits until the run loop is in the default mode.
         If you want the message to be dequeued when the run loop is in a mode other than the default mode, use the performSelector:withObject:afterDelay:inModes: method instead. If you are not sure whether the current thread is the main thread, you can use the performSelectorOnMainThread:withObject:waitUntilDone: or performSelectorOnMainThread:withObject:waitUntilDone:modes:method to guarantee that your selector executes on the main thread. To cancel a queued message, use the cancelPreviousPerformRequestsWithTarget: or cancelPreviousPerformRequestsWithTarget:selector:object:method.
  */
- (void)performAfterDelay
{
    NSThread * thread = [[NSThread alloc] initWithBlock:^{
        [self performSelector:@selector(log) withObject:nil afterDelay:3.0];
//        [[NSRunLoop currentRunLoop] run];  // 如果没有启动 runLoop，则 log 方法不会被执行
//        [[NSRunLoop currentRunLoop] runMode:NSRunLoopCommonModes beforeDate:[NSDate distantFuture]];  // log 方法不会被执行
    }];
    [thread start];
}

- (void)log
{
    NSLog(@"performAfterDelay!");
}








/**
  *  @brief   这个方法在 Foundation 框架的 NSTimer.h 文件内声明。一个 NSTimer 的对象只能注册在一个 RunLoop 当中，但是可以添加到多个RunLoop Mode 当中。
 
              NSTimer 其实就是 CFRunLoopTimerRef，他们之间是  Toll-Free Bridging 的。它的底层是由 XNU 内核的 mk_timer 来驱动的。一个 NSTimer 注册到 RunLoop 后，RunLoop 会为其重复的时间点注册好事件。例如 10:00、10:10、10:20 这几个时间点。RunLoop为了节省资源，并不会在非常准确的时间点回调这个 Timer。Timer 有个属性叫做 Tolerance（宽容度），标示了当时间点到后，容许有多少最大误差。
 
              在文件中，系统提供了一共 8 个方法，其中三个方法是直接将 timer 添加到了当前 runloop 的 DefaultMode，而不需要我们自己操作，当然这样的代价是 runloop 只能是当前 runloop，模式是 DefaultMode。
 
             A timer that fires after a certain time interval has elapsed, sending a specified message to a target object.
 
             Timers work in conjunction with run loops. Run loops maintain strong references to their timers, so you don’t have to maintain your own strong reference to a timer after you have added it to a run loop.
 
             To use a timer effectively, you should be aware of how run loops operate. See Threading Programming Guidefor more information.
 
             A timer is not a real-time mechanism. If a timer’s firing time occurs during a long run loop callout or while the run loop is in a mode that isn't monitoring the timer, the timer doesn't fire until the next time the run loop checks the timer. Therefore, the actual time at which a timer fires can be significantly later. See also Timer Tolerance.
 
             NSTimer is toll-free bridged with its Core Foundation counterpart, CFRunLoopTimerRef. See Toll-Free Bridgingfor more information.
 
             NSTimer 和 PerformSelecter 有很多类似的地方，比如说两者的创建和撤销都必须要在同一个线程上，内存管理上都有泄露的风险，精度上都有问题。
  */
- (void)nsTimer
{
    // 当前 runloop、defaultMode。
    // 没持有 self
//    [NSTimer scheduledTimerWithTimeInterval:3 repeats:NO block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"NSTimer!");
//    }];
    
    
//    NSTimer * timer = [NSTimer timerWithTimeInterval:3
//                                          invocation:[NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(logTimer)]]
//                                             repeats:NO];
    
    
    NSTimer * timer = [NSTimer timerWithTimeInterval:3
                                              target:self
                                            selector:@selector(logTimer)
                                            userInfo:nil
                                             repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)logTimer
{
    NSLog(@"NSTimer!");
}








/**
  *  @brief   CADisplayLink 是一个能让我们以和屏幕刷新率同步的频率将特定的内容画到屏幕上的定时器类。它和 NSTimer 在实现上有些类似。区别在于每当屏幕显示内容刷新结束的时候，runloop 就会向 CADisplayLink 指定的 target 发送一次指定的 selector 消息，而 NSTimer 以指定的模式注册到 runloop 后，每当设定的周期时间到达后，runloop 会向指定的 target 发送一次指定的 selector 消息。
 
            当然，和 NSTimer 类似，CADisplayLink 也会因为同样的原因出现精度问题，不过单就精度而言，CADisplayLink 会更高一点。这里的表现就是画面掉帧了。
            我们通常情况下会把它使用在界面的不停重绘，比如视频播放的时候需要不停地获取下一帧用于界面渲染，还有动画的绘制等地方。
  */
- (void)caDisplayLink
{
    count = 0;
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(handleDisplayLink:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

static NSInteger count;
- (void)handleDisplayLink:(CADisplayLink *)link
{
    if (count < 10) {
        count++;
        NSLog(@"CADisplayLink!");
    }
    else {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}






/**
 *  @brief   GCD 中除了主要的 Dispatch Queue 外，还有较次要的 Dispatch Source。它是 BSD 系内核惯有功能 kqueue 的包装。
 *
 *              kqueue 是在 XUN 内核中发生各种事件时，在应用程序编程方执行处理的技术。其 CPU 负荷非常小，尽量不占用资源。kqueue 可以说是应用程序处理 XUN 内核中发生的各种事件的方法中最优秀的一种。
  */
- (void)gcd
{
    dispatch_queue_t queue = dispatch_queue_create("com.datetime.queue", DISPATCH_QUEUE_CONCURRENT);
    
    /* 为一个 dispatch_source_t 类型的结构体 ds 做了分配内存和初始化操作，然后将其返回。
     
                 dispatch_source_t ds = NULL;
                 ds = _dispatch_alloc(DISPATCH_VTABLE(source), sizeof(struct dispatch_source_s));
                 _dispatch_queue_init((dispatch_queue_t)ds);
                 ds->do_suspend_cnt = DISPATCH_OBJECT_SUSPEND_INTERVAL;
                 ds->do_targetq = &_dispatch_mgr_q;
                 dispatch_set_target_queue(ds, q);
                 return ds;
          */
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 每 3 秒触发 timer，误差 0 秒
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        NSLog(@"dispatch_source_set_timer!");
    });
    dispatch_resume(_timer);
    
    // 2019-05-21 16:56:37.312815+0800
    // 2019-05-21 16:56:40.312967+0800
    // 2019-05-21 16:56:43.313867+0800
    // 2019-05-21 16:56:46.314090+0800
    // 近似为 3 秒钟
}

@end

