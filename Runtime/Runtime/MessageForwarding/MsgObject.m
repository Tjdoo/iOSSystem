//
//  MsgObject.m
//  Runtime
//
//  Created by CYKJ on 2019/6/22.
//  Copyright © 2019年 D. All rights reserved.


#import "MsgObject.h"
#import <objc/runtime.h>
#import "ForwardingObject.h"

/**
   一个函数是由一个 Selector（SEL）和一个 implement（IML）组成的。Selector 相当于门牌号，而 Implement 才是真正的住户（函数实现）。门牌可以随便发，但是不一定都找得到住户。当找不到方法实现时，程序就会进入“消息转发”流程。
 
         https://www.cnblogs.com/biosli/p/NSObject_inherit_2.html
  */






@implementation MsgObject

void dynamicMethodIMP (id self, SEL _cmd)
{
    printf("Resolve DoWork!");
}

/**
  *  @brief   1、动态方法解析。并不能称为“消息转发”，它只是动态增加了一个方法实现
  */
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    NSLog(@"+resolveInstanceMethod:");
    
    // 匹配方法
//    NSString * methodName = NSStringFromSelector(sel);
//    if ([methodName isEqualToString:@"dowork"]) {
//        /*  添加函数
//                        参数 1：添加方法实现的对象
//                        参数 2：方法编号
//                        参数 3：动态增加的方法实现
//                        参数 4：方法信息
//                    */
//        class_addMethod(self, sel, (IMP)dynamicMethodIMP, "v@:");
//    }
    
    return [super resolveInstanceMethod:sel];
}





/**
  *  @brief    2、快速转发。找备用接收者
  */
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    NSLog(@"-forwardingTargetForSelector:");

//    NSString * methodName = NSStringFromSelector(aSelector);
//    if ([methodName isEqualToString:@"dowork"]) {
//        return [ForwardingObject new];  // 由 forwoarding 对象处理方法
//    }
    return [super forwardingTargetForSelector:aSelector];
}





/**
  *  @brief   3、慢速转发。完整的消息转发：方法签名 + 消息转发。
  */
/// 方法签名：方法的具体信息
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSLog(@"-methodSignatureForSelector:");
    
    NSString * methodName = NSStringFromSelector(aSelector);
    if ([methodName isEqualToString:@"dowork"]) {
        // 这里用 [MSMethodSignature methodSignatureForSelector:aSelector] 无效的，因为当前类并没有实现 aSelector，别写错了！
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

/**
  *  @brief   执行从 methodSignatureForSelector: 返回的 NSMethodSignature。NSInvocation 多次转发到多个对象，而 forwardingTargetForSelector: 只能转发到一个对象
  */
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSLog(@"-forwardInvocation:");

    SEL sel = [anInvocation selector];

    ForwardingObject * forwarding = [ForwardingObject new];
    if ([forwarding respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:forwarding];
        return;
    }

    [super forwardInvocation:anInvocation];
}





/**
  *  @brief   4、找不到方法。虽然理论上可以重载这个函数实现保证不抛出异常（不调用 super 实现），但是苹果文档着重提出“一定不能让这个函数就这么结束掉，必须抛出异常”。
  */
- (void)doesNotRecognizeSelector:(SEL)aSelector
{
    NSLog(@"-doesNotRecognizeSelector:");
}

@end
