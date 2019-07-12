//
//  ViewController.m
//  NSProxy
//
//  Created by CYKJ on 2019/7/12.
//  Copyright © 2019年 D. All rights reserved.


#import "ViewController.h"
#import "ClassA.h"
#import "ClassB.h"
#import "ClassProxy.h"
#import "WeakProxy.h"
#import "Dog.h"
#import "MyProxy.h"
#import "AOPProxy.h"


@interface ViewController ()
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) Dog * dog;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1、多继承
    [self classInheritance];
    
    // 2、循环引用
    self.timer = [NSTimer timerWithTimeInterval:1
                                         target:[WeakProxy proxyWithTarget:self]
                                       selector:@selector(invoked:)
                                       userInfo:nil
                                        repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    // 3、AOP。_dog 实际为 MyProxy 对象
    _dog = [MyProxy proxyWithObject:[Dog alloc]];
    [_dog barking:4];
    
    [self inspect];
    
    /* 4、实现延迟初始化（Lazy Initialization）
    
                使用场景：
     
                ①、在 [SomeClass lazy] 之后调用 doSomthing，首先进入 forwardingTargetForSelector，_object 为 nil 并且不是 init 开头的方法的时候会调用 init 初始化对象，然后将消息转发给代理对象 _object；
     
                ②、在 [SomeClass lazy] 之后调用 initWithXXX:，首先进入 forwardingTargetForSelector 返回 nil，然后进入 methodSignatureForSelector: 和 forwardInvocation: 保存自定义初始化方法的调用，最后调用 doSomthing，进入 forwardingTargetForSelector，_object 为 nil 并且不是 init 开头的方法的时候会调用自定义初始化方法，然后将消息转发给代理对象 _object。
     
                SomeClass *object = [SomeClass lazy];
                // other thing ...
                [object doSomething];  // 在这里 object 才会调用初始化方法，然后调用 doSomething
            */
}

/**
  * @brief   多继承
  */
-(void)classInheritance
{
    ClassA * A = [[ClassA alloc]init];
    ClassB * B = [[ClassB alloc]init];
    
    ClassProxy * proxy = [ClassProxy alloc];
    [proxy handleTargets:@[A, B]];
    // 调用 proxy 类的方法，实际上被转发
    [proxy performSelector:@selector(infoA)];
    [proxy performSelector:@selector(infoB)];
}

- (void)invoked:(NSTimer *)timer
{
    NSLog(@"1");
}

- (void)inspect
{
    NSMutableArray * targtArray = [AOPProxy proxyWithTarget:[NSMutableArray arrayWithCapacity:1]];

    [(AOPProxy *)targtArray inspectSelector:@selector(addObject:)
                                 preSelTask:^(id target, SEL selector) {
        [target addObject:@"-------"];
        NSLog(@"%@ 我加进来之前", target);
                                     
    } endSelTask:^(id target, SEL selector) {
        
        [target addObject:@"-------"];
        NSLog(@"%@ 我加进来之后", target);
    }];
    [targtArray addObject:@"我是一个元素"];
}

@end
