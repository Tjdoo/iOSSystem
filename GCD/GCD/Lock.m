//
//  Lock.m
//  GCD
//
//  Created by CYKJ on 2019/12/4.
//  Copyright © 2019 D. All rights reserved.


#import "Lock.h"
#import <libkern/OSAtomic.h>
#import <os/lock.h>
#import <pthread.h>

@interface Lock ()

@property (nonatomic, assign) NSInteger totalTicket;
@property (nonatomic, assign) OSSpinLock osspinLock;
@property (nonatomic, assign) os_unfair_lock unfairlock;
@property (nonatomic, assign) pthread_mutex_t mutexLock;
@property (nonatomic, strong) NSLock * lock;
@end


@implementation Lock

- (void)test
{
    self.totalTicket = 10;
    
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    
    // 创建锁
    self.osspinLock = OS_SPINLOCK_INIT;
    
    if (@available(iOS 10.0, *)) {
        self.unfairlock = OS_UNFAIR_LOCK_INIT;
    }
    
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_NORMAL); // pthread_mutex普通锁
    pthread_mutex_init(&_mutexLock, &attr);
    
    self.lock = [[NSLock alloc] init];
    
    // 数据竞争
    for (int i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
//            [self saleTicketByOSSpinLock];
//            [self saleTicketByOSunfairlock];
//            [self saleTicketByPthreadMutexLock];
//            [self saleTicketByNSLock];
        });
    }
}

- (void)saleTicketByOSSpinLock
{
    // 加锁
    OSSpinLockLock(&_osspinLock);
    
    self.totalTicket--;
    NSLog(@"ticket = %ld", (long)self.totalTicket);
    
    // 解锁
    OSSpinLockUnlock(&_osspinLock);
}

- (void)saleTicketByOSunfairlock
{
    if (@available(iOS 10.0, *)) {
        // 加锁
        os_unfair_lock_lock(&_unfairlock);
        
        self.totalTicket--;
        NSLog(@"ticket = %ld", (long)self.totalTicket);
        
        // 解锁
        os_unfair_lock_unlock(&_unfairlock);
    }
}

- (void)saleTicketByPthreadMutexLock
{
    // 加锁
    pthread_mutex_lock(&_mutexLock);
    
    self.totalTicket--;
    NSLog(@"ticket = %ld", (long)self.totalTicket);

    // 解锁
    pthread_mutex_unlock(&_mutexLock);
}

- (void)saleTicketByNSLock
{
    // 加锁
    [self.lock lock];
    
    self.totalTicket--;
    NSLog(@"ticket = %ld", (long)self.totalTicket);
    
    // 解锁
    [self.lock unlock];
}



@end
