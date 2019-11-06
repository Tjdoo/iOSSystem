//
//  ViewController.m
//  Block
//
//  Created by D on 2019/5/3.
//  Copyright © 2019 D. All rights reserved.


#import "ViewController.h"

typedef void(^ Block)(void);
typedef void(^ UnRetainBlock)(ViewController *);

@interface ViewController ()
@property (nonatomic, strong) Block block;
@property (nonatomic, strong) UnRetainBlock unReatinBlock;
@property (nonatomic, copy) NSString * name;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // block 的分类
    [self typeOfBlock];
    
    
    // 循环引用
//    [self retainCircle];

//    [self unReatinCircle1];
//    [self unReatinCircle2];
//    [self unReatinCircle3];
    
    // 跨域调用
    [self blockSolve];
    
    // 总结：
    // 分析问题：block 的分类 -》内存五大区
    // 循环引用：__weak 和 __strong、__block、传递参数
    // __block 的变量为什么能操作？   打印指针 / clang -》底层 objc、block、结构体
    // gcc 编译
}


#pragma mark - block 的分类
/**
  *  @brief   block 的分类
  */
- (void)typeOfBlock
{
    // ①、<__NSGlobalBlock__: 0x108d75230>   全局 block
    void(^ block1)(void) = ^ {
        NSLog(@"haha");
    };
    NSLog(@"%@", block1);  // %@ -》 block 也是一个对象 -》NSObject -》objc_obejct
    
    NSLog(@"%@", [block1 class]);  // __NSGlobalBlock__
    NSLog(@"%@", [[block1 class] superclass]);  // __NSGlobalBlock
    NSLog(@"%@", [[[block1 class] superclass] superclass]);  // NSBlock
    NSLog(@"%@", [[[[block1 class] superclass] superclass] superclass]);  // NSObject

    // ！！！！block 最终都是继承自 NSBlock 类型，而 NSBlock 继承于 NSObjcet。那么 block 其中的 isa 指针其实是来自 NSObject 中的。这也更加印证了 block 的本质其实就是 OC 对象。
    
    
    // ②、<__NSMallocBlock__: 0x6000024d8f90>  堆 block
    int a = 180;
    void (^ block2)(void) = ^ {
        NSLog(@"haha --- %d", a);
    };
    NSLog(@"%@", block2);
    
    
    // ③、<__NSStackBlock__: 0x7ffee86ba878>  栈 block
    NSLog(@"%@", ^{
        NSLog(@"haha --- %d", a);
    });
    
    
    /* 整个流程：
    
                    全局（data 段）-》引入一个定义在栈上的变量 a -》跨域请求 -》将 block 定义在栈上 -》重写 “=” 操作符 -》ARC 编译器执行 copy（objc_retainBlock） -》将 block 复制到堆上
     
              objc 源码：
                     id objc_retainBlock(id x) {
                            return (id)_Block_copy(x);
                     }
     
                     // Create a heap based copy of a Block or simply add a reference to an existing one.
                     // This must be paired with Block_release to recover memory, even when running under Objective-C Garbage Collection.
                     BLOCK_EXPORT void *_Block_copy(const void *aBlock)
                     __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_3_2);
         */
    
    // ！！！！在 ARC 下系统会自动执行 copy 操作
    
    
    /*
                数据段中的 __NSGlobalBlock__ 直到程序结束才会被回收，不过我们很少使用到 __NSGlobalBlock__ 类型的 block，因为这样使用 block 并没有什么意义。
     
                __NSStackBlock__ 类型的 block 存放在栈中，我们知道栈中的内存由系统自动分配和释放，作用域执行完毕之后就会被立即释放，而在相同的作用域中定义 block 并且调用 block 似乎也多此一举。
     
               __NSMallocBlock__ 是在平时编码过程中最常使用到的。存放在堆中需要我们自己进行内存管理。
          */
}


#pragma mark - 循环引用问题

- (void)retainCircle
{
    self.block = ^{
        NSLog(@"%@", self.name); // 警告：Capturing 'self' strongly in this block is likely to lead to a retain cycle
    };
    self.block();
}

/**
  *  @brief   方式 1
  */
- (void)unReatinCircle1
{
    // __weak 双下划线，让编译器知道这是一个特殊的符号
    __weak typeof(self) weakSelf = self;
    
    self.block = ^ {
        weakSelf.name = @"Block Project";
        __strong typeof(weakSelf) strongSelf = weakSelf;  // 局部变量，作用域为 block 函数
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            /* ❎错误。在 2s 之前界面返回时，这句代码将打印 null
             
                                     2019-05-03 17:23:58.166405+0800 Block[2041:123160] dealloc 被调用
                                     2019-05-03 17:23:58.913736+0800 Block[2041:123160] (null)
                              */
//            NSLog(@"%@", weakSelf.name);
            
            
            /*  ✅正确。析构函数会等待 block 执行完
             
                                     2019-05-03 17:25:06.639017+0800 Block[2062:124209] Block Project
                                     2019-05-03 17:25:06.639305+0800 Block[2062:124209] dealloc 被调用
                             */
            NSLog(@"%@", strongSelf.name);
        });
    };
    self.block();
}

/**
  *  @brief   方式 2
  */
- (void)unReatinCircle2
{
    // __block 将栈区变量拷贝到堆区
    __block ViewController * blkVC = self; // 拷贝到堆区
    
    // blkVC -》self -》block -》blkVC
    
    self.block = ^{
        blkVC.name = @"Block Project";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%@", blkVC.name);
            blkVC = nil;  // 如果不将 blkVC 置为 nil，因为 blkVC 还持有 self，所以 dealloc 不会被调用
        });
    };
    self.block();
}

/**
  *  @brief   方式 3
  */
- (void)unReatinCircle3
{
    // self -》block -》self   循环引用圈，问题的本质：使用 vc 里面的 name 属性
    
    self.unReatinBlock = ^(ViewController * vc) {
        vc.name = @"Block Project";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            /*
                                 2019-05-03 17:52:41.706616+0800 Block[2371:148004] Block Project
                                 2019-05-03 17:52:41.706918+0800 Block[2371:148004] dealloc 被调用
                            */
            NSLog(@"%@", vc.name);
        });
    };
    self.unReatinBlock(self);
}

- (void)dealloc
{
    NSLog(@"dealloc 被调用");
}


#pragma mark - 跨域调用

- (void)blockError
{
    int a = 10;  // 栈
    
    // block 因为捕获了 a，所以定义在栈，然后在 ARC 下，调用 objc_retainBlock、_Block_copy 方法，复制到堆上
    self.block = ^{
        NSLog(@"%d", a);
//        a++;   // 提示错误：Variable is not assignable (missing __block type specifier)
    };
    self.block();
}

- (void)blockSolve
{
    __block int a = 10;
    NSLog(@"被捕获前，地址：%p", &a);  // 2019-05-03 18:03:28.280228+0800 Block[2491:156619] 被捕获前，地址：0x7ffee9dae208
    
    self.block = ^{
        a++;
        NSLog(@"被捕获后，地址：%p", &a);  // 2019-05-03 18:03:28.280338+0800 Block[2491:156619] 被捕获后，地址：0x6000015b0618
    };
    self.block();
    NSLog(@"调用结束后，地址：%p", &a);  // 2019-05-03 18:03:28.280459+0800 Block[2491:156619] 调用结束后，地址：0x6000015b0618
    
    // ！！！！经验：0x7（栈）、0x6（堆）、0x1（全局区）
}

@end
