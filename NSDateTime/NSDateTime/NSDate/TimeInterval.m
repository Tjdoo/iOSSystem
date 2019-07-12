//
//  TimeInterval.m
//  Date&Time
//
//  Created by CYKJ on 2019/5/21.
//  Copyright © 2019年 D. All rights reserved.


#import "TimeInterval.h"
#import <QuartzCore/CABase.h>
#import <mach/mach_time.h>
#import <sys/time.h>


@implementation TimeInterval

- (void)done
{
    int i = 0;
    NSString * s;
    
    // ①、NSDate
    NSDate * now = [NSDate date];
    for (i = 0; i < 10000; i++) {
        s = [NSString stringWithFormat:@"%d", i];
    }
    NSTimeInterval nsTi = [now timeIntervalSinceNow];  // typedef double NSTimeInterval;
    NSLog(@"%f", -1 * nsTi);
    
    
    // ②、CFAbsoluteTimeGetCurrent()
    CFAbsoluteTime before = CFAbsoluteTimeGetCurrent(); // 相当于 [[NSDate date] timeIntervalSinceReferenceDate];
    for (i = 0; i < 10000; i++) {
        s = [NSString stringWithFormat:@"%d", i];
    }
    CFAbsoluteTime after  = CFAbsoluteTimeGetCurrent();
    NSLog(@"%f", after - before);
    
    
    // ③、CACurrentMediaTime() 常用于测试代码的效率
    CFTimeInterval cfTi1 = CACurrentMediaTime();
    for (i = 0; i < 10000; i++) {
        s = [NSString stringWithFormat:@"%d", i];
    }
    CFTimeInterval cfTi2 = CACurrentMediaTime();
    NSLog(@"%f", cfTi2 - cfTi1);
    
    
    // ④、mach_absolute_time()      https://www.cnblogs.com/zpsoe/p/6994811.html
    /* mach_absolute_time()  是一个 CPU/总线依赖函数，返回一个基于系统启动后的时钟"嘀嗒"数。在 macOS 上可以确保它的行为，并且，它包含系统时钟所包含的所有时间区域。其可获取纳秒级的精度。
    
             使用 mac_absolute_time 时需要考虑两个因素：
     
                    1、如何获取当前的 Mach 绝对时间；
                    2、如何将其转换为有意义的数字。
     
             如果系统处于休眠状态，那么 mach_absolute_time() 这个值也是停止的，所以它本质是进程运行的时钟计数器(run())，而非整个系统的(run() + sleep())时钟计数器。这样严格来说，是完全不准确的数据，不可用。
            */
    double begin = getTickCount();
    for (i = 0; i < 10000; i++) {
        s = [NSString stringWithFormat:@"%d", i];
    }
    double end  = getTickCount();
    NSLog(@"%f", end - begin);
    
    
    
    // ⑤、gettimeofday() 获得的值是 Unix time。Unix time是以 UTC 1970年1月1号 00：00：00为基准时间，当前时间距离基准点偏移的秒数。
    struct timeval tv1;
    struct timezone zone;
    gettimeofday(&tv1, &zone);
    for (i = 0; i < 10000; i++) {
        s = [NSString stringWithFormat:@"%d", i];
    }
    struct timeval tv2;
    gettimeofday(&tv2, &zone);
    NSLog(@"%f", (tv2.tv_usec - tv1.tv_usec)/ USEC_PER_SEC * 1.0);
    
    
    
    /*  总结：
     
            NSDate、CFAbsoluteTimeGetCurrent() 常用于日常时间、时间戳的表示，与服务器进行数据交互；返回的时钟时间将会与网络时间同步。

            CACurrentMediaTime() 与 mach_absolute_time() 用于计算时间间隔是最准确的。mach_absolute_time() 和 CACurrentMediaTime() 是基于内建时钟的，能够更精确更原子化的测量，并且不会因为外部时间变化而变化（例如时区变化、夏时制、秒突变等），但它和系统的 upTime 有关，系统重启后 CACurrentMediaTime() 会被重置。
     
            每次系统重启后会一直记录启动至今的时间。这个时间称之为 upTime。https://www.jianshu.com/p/82475b5a7e19
          */
}





/**
  *  @brief  将 mach_absolute_time() 的时间转换为毫秒数，这需要获得 mach_absolute_time() 所基于的系统时间基准。
  *
  *     这里最重要的是调用 mach_timebase_info() 函数，传递一个结构体以返回时间基准值。最后，一旦获取到了系统的时间心跳，我们便能够生成一个转换因子。通常，转换是通过分子（info.numer）除以分母（info.denom），这里乘以一个 1e-9 来获取秒数。
  */
double getTickCount(void)
{
    static mach_timebase_info_data_t info;
    
    uint64_t machTime = mach_absolute_time();
    
    // Convert to nanoseconds - if this is the first time we've run, get the timebase.
    if (info.denom == 0) {
        (void) mach_timebase_info(&info);
    }
    // mach time（纳秒） -》秒
    double millis = (machTime * 1e-9 * (double)info.numer) / (double)info.denom;
    
    return millis;
}

double TimeBlock (void (^block)(void))
{
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS) return -1.0;
    
    uint64_t start = mach_absolute_time ();
    block ();
    uint64_t end = mach_absolute_time ();
    uint64_t elapsed = end - start;
    
    uint64_t nanos = elapsed * info.numer / info.denom;
    return (CGFloat)nanos / NSEC_PER_SEC;
}

@end
