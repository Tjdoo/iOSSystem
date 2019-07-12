//
//  MyProxy.h
//  NSProxy
//
//  Created by CYKJ on 2019/7/12.
//  Copyright © 2019年 D. All rights reserved.


#import <Foundation/Foundation.h>

/**
 *  @brief   AOP（Aspect Oriented Programming）是可以通过预编译方式和运行时动态代理实现在不修改源代码的情况下给程序动态添加功能的一种技术。
 
        iOS 中面向切片编程一般有两种方式 ，一种是直接基于 runtime 的 method-Swizzling 机制来实现方法替换从而达到 hook 的目的，另一种就是基于 NSProxy。
 
        OC 的动态语言的核心部分应该就是 objc_msgSend 方法的调用了。该函数的声明大致如下：
 
        参数 1：接受消息的 target
        参数 2：要执行的 selector
        参数 3：要调用的方法
        可变参数：若干个要传给 selector 的参数
 
        id objc_msgSend(id self, SEL _cmd, ...)

        只要我们能够 Hook 到对某个对象的 objc_msgSend 的调用，并且可以修改其参数甚至于修改成任意其他 selector 的 IMP，我们就实现了 AOP。
  */
@interface MyProxy : NSProxy
{
    id _innerObject;  // 在内部持有要 hook 的对象
}
+ (instancetype)proxyWithObject:(id)object;

@end
