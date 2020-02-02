//
//  ViewController.m
//  GCD
//
//  Created by CYKJ on 2019/6/22.
//  Copyright © 2019年 D. All rights reserved.


#import "ViewController.h"
#import "pthread.h"
#import "Lock.h"

@interface ViewController ()

@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) NSMutableDictionary * mutableDict;
@property (nonatomic, assign) pthread_rwlock_t rwlock; // 读写锁
@property (nonatomic, strong) UILabel * label;
@property (nonatomic, strong) dispatch_source_t timer;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self demo1];
//    [self demo2];
//    [self demo3];
//    [self demo4];
//    [self demo5];
    [self demo6];
    
    [[Lock alloc] test];
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


#pragma mark -  GCD 对于读写操作的控制
/**
  *  @brief   GCD 对于读写操作的控制
  */
- (void)demo2
{
    // 必须传入 dispatch_queue_create 的并发队列，不能传入 dispatch_get_global_queue 队列。如果传入串行或者是 global  就相当于 dispatch_async，没有栅栏（barrier）效果
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


#pragma mark - 验证线程与队列的关系
/**
  *  @brief   验证线程与队列的关系
  */
- (void)demo4
{
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
    self.label.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.label];
    
    // 主队列是一个特殊的串行队列，异步方式提交任务不会开辟新线程
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"1 --- %@", [NSThread currentThread]);  // <NSThread: 0x6000039a1400>{number = 1, name = main}
        
//        self.label.backgroundColor = [UIColor orangeColor];  // 正常
    });

    // 同步提交任务到并发队列，不会开辟新线程
    dispatch_sync(dispatch_queue_create("queue1", DISPATCH_QUEUE_CONCURRENT), ^{
        NSLog(@"2 --- %@", [NSThread currentThread]);  // <NSThread: 0x6000039a1400>{number = 1, name = main}
        
//        self.label.backgroundColor = [UIColor greenColor];  // 正常
    });
    
    // 同步提交任务到自定义的串行队列，不会开辟新线程
    dispatch_sync(dispatch_queue_create("queue4", DISPATCH_QUEUE_SERIAL), ^{
        NSLog(@"3 --- %@", [NSThread currentThread]);  // <NSThread: 0x6000039a1400>{number = 1, name = main}
        
//        self.label.backgroundColor = [UIColor whiteColor];  // 正常
    });
    
    /**  上面的例子表明：一个线程可以处理多个队列的任务。只要是主线程，不一定要在主队列中刷新 UI  */
    
    
    dispatch_async(dispatch_queue_create("queue2", DISPATCH_QUEUE_SERIAL), ^{
        
        NSLog(@"4 ---- %@", [NSThread currentThread]);
        dispatch_queue_t queue = dispatch_queue_create("queue3", DISPATCH_QUEUE_CONCURRENT);

        dispatch_async(queue, ^{
            NSLog(@"5 ---- %@", [NSThread currentThread]);
        });
        
        dispatch_sync(queue, ^{
            NSLog(@"6 ---- %@", [NSThread currentThread]);
        });
    });
    
    /**   子线程中也可以有多个队列   */
    
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        NSLog(@"111");
//    });
    
//    dispatch_queue_t queue = dispatch_queue_create("CONCURRENT", DISPATCH_QUEUE_SERIAL);
//    dispatch_async(queue, ^{
//        dispatch_sync(queue, ^{
//            NSLog(@"222");
//        });
//    });
    
    /**  dispatch_sync 将任务提交到自身所在的队列中，造成死锁 */
    
    
    static void * key = "mainQueueKey";
    dispatch_queue_set_specific(dispatch_get_main_queue(), key, &key, NULL);

    // 异步添加任务到全局并发队列中
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        // 异步添加任务到主队列中
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"isMainThread: %d", [NSThread isMainThread]);
            NSLog(@"currentThread: %@",[NSThread currentThread]);
            // 判断是否是主队列
            void * value = dispatch_get_specific(key);
            NSLog(@"isMainQueue: %d", value != NULL);
        });
    });

    NSLog(@"dispatch_main 会堵塞主线程");
    // 这个函数会阻塞主线程并且等待提交给主队列的任务 blocks 完成，这个函数永远不会返回。
    // 这个方法会阻塞主线程，然后在其它线程中执行主队列中的任务，这个方法永远不会返回（意思会卡住主线程）。
    dispatch_main();
}


#pragma mark - Demo5
/**
  *  @brief   定时器
  */
- (void)demo5
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    
    /*
                参数 2：多少秒后开始
                参数 3：时间间隔
                参数 4：leewayInSeconds 误差，通常填 0 就可以
            */
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    
    static int i = 0;
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"1111");
        if (++i > 5) {
            dispatch_source_cancel(timer);
        }
    });
    // 启动定时器
    dispatch_resume(timer);
    
    // 要用强引用将 timer 保持住
    self.timer = timer;
}


#pragma mark - 死锁

- (void)demo6
{
    dispatch_queue_t queue = dispatch_queue_create("queue", NULL);
    
    NSLog(@"1");
    dispatch_async(queue, ^{
        NSLog(@"2");
        
        dispatch_sync(queue, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}


#pragma mark - 美团面试题

- (void)demo7
{
    __block int a = 0;
    while (a < 5) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"%@---%d", [NSThread currentThread], a);
            a++;
        });
    }
    
//    NSLog(@"输出：%d", a);
    
    // FIFO  保证输出最后的结果。根据队列的调度，这里的 block 一定是最后被线程执行的
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"输出：%d", a);
    });
}

@end
