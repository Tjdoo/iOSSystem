//
//  ViewController.m
//  GCD
//
//  Created by CYKJ on 2019/6/22.
//  Copyright © 2019年 D. All rights reserved.


#import "ViewController.h"
#import "pthread.h"

@interface ViewController ()
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) NSMutableDictionary * mutableDict;
@property (nonatomic, assign) pthread_rwlock_t rwlock; // 读写锁
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self demo1];
    [self demo2];
//    [self demo3];
}

- (void)demo1
{
    // 同步 + 并行队列
    dispatch_sync(dispatch_queue_create("com.sync.concurrent", DISPATCH_QUEUE_CONCURRENT), ^{
        NSLog(@"11111");
        NSLog(@"%@", [NSThread currentThread]);  // <NSThread: 0x600002f5ef80>{number = 1, name = main}  未开辟线程
    });
    NSLog(@"22222");
    
    // 异步 + 串行队列
    dispatch_async(dispatch_queue_create("com.async.serial", DISPATCH_QUEUE_SERIAL), ^{
        NSLog(@"33333");
        NSLog(@"%@", [NSThread currentThread]);  // <NSThread: 0x600002f3bcc0>{number = 3, name = (null)}  开辟线程
    });
    NSLog(@"44444");
    
    // 同步 + 串行队列
    dispatch_sync(dispatch_queue_create("com.sync.serial", DISPATCH_QUEUE_SERIAL), ^{
        NSLog(@"55555");
        NSLog(@"%@", [NSThread currentThread]);  // <NSThread: 0x600002f5ef80>{number = 1, name = main}  未开辟线程
    });
    NSLog(@"66666");  // 正常执行
}


#pragma mark -
/**
  *  @brief   GCD 对于读写操作的控制
  */
- (void)demo2
{
    // 必须传入 dispatch_queue_create 的并发队列，不能传入 dispatch_get_global_queue 队列。如果传入串行或者是 global  就相当于dispatch_async，没有栅栏（barrier）效果
    self.queue = dispatch_queue_create("com.afnetworking.concurrent", DISPATCH_QUEUE_CONCURRENT);
    self.mutableDict = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < 10; i ++) {
        dispatch_async(dispatch_queue_create("ss", DISPATCH_QUEUE_SERIAL), ^{
            [self read1];
        });
        dispatch_async(dispatch_queue_create("ss", DISPATCH_QUEUE_SERIAL), ^{
            [self read2];
        });
        dispatch_async(dispatch_queue_create("ss", DISPATCH_QUEUE_SERIAL), ^{
            [self write1];
        });
        dispatch_async(dispatch_queue_create("ss", DISPATCH_QUEUE_SERIAL), ^{
            [self write2];
        });
        dispatch_async(dispatch_queue_create("ss", DISPATCH_QUEUE_SERIAL), ^{
            [self read1];
        });
        dispatch_async(dispatch_queue_create("ss", DISPATCH_QUEUE_SERIAL), ^{
            [self read1];
        });
    }
}

- (void)read1
{
    // 同步
//    dispatch_sync(self.queue, ^{
    // 异步
    dispatch_async(self.queue, ^{
        sleep(1);
        NSLog(@"Read 1");
    });
}

- (void)read2
{
    dispatch_sync(self.queue, ^{
        sleep(1);
        NSLog(@"Read 2");
    });
}

- (void)write1
{
    dispatch_barrier_async(self.queue, ^{
        sleep(1);
        NSLog(@"Write 1");
    });
}

- (void)write2
{
    dispatch_barrier_async(self.queue, ^{
        sleep(1);
        NSLog(@"Write2");
    });
}


#pragma mark - 读写锁
/**
  *  @see   https://cloud.tencent.com/developer/article/1515037
  */
- (void)demo3
{
    pthread_rwlock_init(&_rwlock, NULL);
    
    dispatch_queue_t queue = dispatch_queue_create("rwqueue", DISPATCH_QUEUE_CONCURRENT);
    
    for (int i = 0; i < 10; i ++) {
        // 开辟线程 1
        dispatch_async(queue, ^{
            for (int i = 0; i < 10; i ++) {
                [self __read];
            }
        });
        // 开辟线程 2
        dispatch_async(queue, ^{
            for (int i = 0; i < 10; i ++) {
                [self __read];
            }
        });
        // 开辟线程 3
        dispatch_async(queue, ^{
            [self __write];
        });
    }
}

- (void)__read
{
    pthread_rwlock_rdlock(&_rwlock);
    sleep(1);
    NSLog(@"READ");
    pthread_rwlock_unlock(&_rwlock);
}

- (void)__write
{
    pthread_rwlock_wrlock(&_rwlock);
    sleep(1);
    NSLog(@"WRITE");
    pthread_rwlock_unlock(&_rwlock);
}

@end
