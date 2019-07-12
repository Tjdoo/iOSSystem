//
//  TimeStamp.m
//  Date&Time
//
//  Created by CYKJ on 2019/5/21.
//  Copyright © 2019年 D. All rights reserved.


#import "TimeStamp.h"
#import <sys/sysctl.h>


@implementation TimeStamp

- (NSTimeInterval)upTime1
{
    return [[NSProcessInfo processInfo] systemUptime];  // 系统进程
}

/**
  *  @brief   获取内核 kernel 的时间。
  *
  *     kernel_task 是个系统级的 task，活动监视器 -》CPU，就可以看到 kernel_task。kernel_task 包括多线程调度管理、虚拟内存、系统 IO、线程之间通信等等。所以系统一启动，kernel_task 就会跑起来，kernel_task 运行的时间，就可以作为启动时间来使用。
  */
- (time_t)upTime2
{
    struct timeval boottime;
    int mib[2] = { CTL_KERN, KERN_BOOTTIME };
    size_t size = sizeof(boottime);
    time_t now;
    time_t uptime = -1;
    
    (void)time(&now);
    
    /* sysctl
     
             参数 1：一个数组，按照顺序第一个元素指定本请求定向到内核的哪个子系统，第二个及其后元素依次细化指定该系统的某个部分，类推...
             参数 2：数组的长度 u_int.
             参数 4：当 sysctl 被调用时，size 指向的值指定该缓冲区的大小；函数返回时，该值给出内核存放在该缓冲区中的数据量，如果这个缓冲不够大，函数就返回 ENOMEM 错误
     
              sysctl 函数的结果：成功返回 0； 失败返回 -1
          */
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0) {
        uptime = now - boottime.tv_sec;
    }
    return uptime;
}
@end
