//
//  KVO.m
//  NSObject
//
//  Created by CYKJ on 2019/11/18.
//  Copyright © 2019年 D. All rights reserved.
//

#import "KVO.h"
#import "KVO_Person.h"

@interface KVO ()
{
    __block KVO_Person * p;
}
@end


@implementation KVO

- (void)dowork
{
//    [self __testKVOInThread];
//    [self __testCSKVO];
//    [self __testAffectingKVO];
    [self __testCollectObjc];
}

/**
 *  @brief   测试 kvo 受线程的影响：监听回调线程与添加监听的线程相同
 */
- (void)__testKVOInThread
{
    NSLog(@"**********************");
    
    p = [[KVO_Person alloc] init];
    [p addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2);
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"AsyncThread: %@", [NSThread currentThread]);
        strongSelf->p.name = @"aa";
    });
    NSLog(@"%@", [NSThread currentThread]);
    p.name = @"bb";
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    NSLog(@"currentThread: %@", [NSThread currentThread]);
//    NSLog(@"mainThread: %@", [NSThread mainThread]);
//    NSLog(@"%@", change[NSKeyValueChangeNewKey]);
//    NSLog(@"**********************");
//}


/**
  *  @brief   测试自定义 kvo
  */
- (void)__testCSKVO
{
    p = [[KVO_Person alloc] init];
    [p addObserver:self forKeyPath:@"age" options:(NSKeyValueObservingOptionNew) context:nil];
    
    [p willChangeValueForKey:@"age"];
    p.age = @"18";  // 不改变 name 属性值也会触发
    [p didChangeValueForKey:@"age"];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    NSLog(@"%@", change[NSKeyValueChangeNewKey]);
//    NSLog(@"**********************");
//}

/**
  *  @brief   测试关联的观察字段
  */
- (void)__testAffectingKVO
{
    Dog * dog = [[Dog alloc] init];
    dog.name = @"Tom";
    dog.age  = 6;
    
    p = [[KVO_Person alloc] init];
    p.dog = dog;
    
    [p addObserver:self forKeyPath:@"dog" options:(NSKeyValueObservingOptionNew) context:nil];
    dog.name = @"Jack";
    dog.age = 8;
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    Dog * dog = change[NSKeyValueChangeNewKey];
//    NSLog(@"狗的名称是：%@，狗的年龄是：%d", dog.name, dog.age);
//    NSLog(@"**********************");
//}

/**
  *  @brief  集合类监听
  */
- (void)__testCollectObjc
{
    p = [[KVO_Person alloc] init];
    p.students = @[ @"Tom" ];
    
    [p addObserver:self forKeyPath:@"students" options:(NSKeyValueObservingOptionNew) context:nil];

    NSMutableArray * tmpArr = [p mutableArrayValueForKey:@"students"];
    [tmpArr addObject:@"Rusi"];
    [tmpArr addObject:@"Jack"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"%@", change[NSKeyValueChangeNewKey]);
    NSLog(@"**********************");
}

@end
