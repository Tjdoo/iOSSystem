//
//  NSObject+MyKVO.m
//  NSObject
//
//  Created by CYKJ on 2019/11/18.
//  Copyright © 2019年 D. All rights reserved.
//

#import "NSObject+MyKVO.h"
#import <objc/message.h>


@implementation NSObject (MyKVO)

- (void)my_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context
{
    // 创建一个类
    NSString * oldClassName = NSStringFromClass(self.class);
    NSString * newClassName = [@"MyKVO_" stringByAppendingString:oldClassName];
    
    Class newClass = objc_allocateClassPair(self.class, newClassName.UTF8String, 0);
    // 注册类
    objc_registerClassPair(newClass);
    
    // 修改 isa 指针
    object_setClass(self, newClass);
    
    // 重写 setter 方法
    // 参数一：要添加方法的类
    // 参数二：方法编号
    // 参数三：方法实现
    // 参数四：方法签名
    class_addMethod(newClass, @selector(setName:), (IMP)setName, "v@:@");
    
    // 将观察者保存起来
    objc_setAssociatedObject(self, @"observer", observer, OBJC_ASSOCIATION_ASSIGN);
}

void setName (id self, SEL _cmd, NSString * name)
{
    NSLog(@"来了！！");
    
    // 调用父类的 setName 方法
    Class class = [self class];  // 拿到当前类型
    object_setClass(self, class_getSuperclass(class));
    objc_msgSend(self, @selector(setName:), name);
    
    id observer = objc_getAssociatedObject(self, @"observer");
    if (observer) {
        objc_msgSend(observer, @selector(observeValueForKeyPath:ofObject:change:context:), @"name", self, @{@"new" : name}, @(1));
    }
    
    // 改回子类
    object_setClass(self, class);
}

@end
