//
//  KVO.m
//  Runtime
//
//  Created by CYKJ on 2019/6/22.
//  Copyright © 2019年 D. All rights reserved.


#import "KVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

/**
    KVO 是基于 Runtime 的。
 
    A 监听 B，系统会创建子类（NSKVONotifying_B）
        - objc_allocateClassPair
        - objc_registerClassPair
    修改 B 的 isa
        - object_setClass
    重写 set 方法
        - class_addMethod
            - 调用父类方法
            - 通知观察者
  */

@implementation KVO

void setterMethod(id self, SEL _cmd, NSString * time)
{
    // 1、调用父类方法
    // 2、通知观察者调用 ObserverValueForKeyPath:
    struct objc_super superClass = {
        self,
        class_getSuperclass([self class])
    };
    objc_msgSendSuper(&superClass, _cmd, time);
    
    // 获取观察者
    id observer = objc_getAssociatedObject(self, (__bridge const void*)@"Observer");
    
    // 通知改变
    NSString * methodName = NSStringFromSelector(_cmd);
    NSString * key = getKey(methodName);
    objc_msgSend(observer,
                 @selector(observeValueForKeyPath:ofObject:change:context:),
                 key,
                 self, @{ key : time }, nil);
}

/**
  *  @brief   由 set 方法获取 key 值，如：setName -》name
  */
NSString * getKey(NSString * setter)
{
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString * key = [setter substringWithRange:range];
    
    NSString * letter = [[key substringToIndex:1] lowercaseString];  // 首字母小写
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:letter];
    
    return key;
}




- (void)cs_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    // 创建一个子类
    NSString * oldClsName = NSStringFromClass(self.class);
    NSString * newClsName = [NSString stringWithFormat:@"CustomKVO_%@", oldClsName];

    Class customCls = objc_allocateClassPair(self.class, newClsName.UTF8String, 0);
    
    // 注册
    objc_registerClassPair(customCls);
    
    // 修改 isa 指针
    object_setClass(self, customCls);
    
    // 重写 set 方法
    NSString * methodName = [NSString stringWithFormat:@"set%@:", keyPath.capitalizedString];
    SEL sel = NSSelectorFromString(methodName);
    class_addMethod(customCls, sel, (IMP)setterMethod, "v@:@");
    
    // 关联观察者
    objc_setAssociatedObject(self, (__bridge const void *)@"Observer", observer, OBJC_ASSOCIATION_ASSIGN);
}

@end
