//
//  NilObject.m
//  NSDictionary
//
//  Created by CYKJ on 2019/5/15.
//  Copyright © 2019年 D. All rights reserved.


#import "NilObject.h"

@implementation NilObject

+ (void)exe
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:1];
    
    /*
             断点 -》Debug -》Debug workflow -》Always Show Disassembly
     
             0x106caf8f2 <+66>:  leaq   0x3927(%rip), %rsi        ; @"AA"
             0x106caf8f9 <+73>:  movq   %rax, -0x18(%rbp)
             ->  0x106caf8fd <+77>:  movq   -0x18(%rbp), %rax
             0x106caf901 <+81>:  movq   0x47e0(%rip), %rdi        ; "setObject:forKeyedSubscript:"
             0x106caf908 <+88>:  movq   %rdi, -0x28(%rbp)
     
             从上可以看出：[] 赋值方式，底层是调用了 setObject:forKeyedSubscript: 方法
          */
    dict[@"AA"] = nil;
    
    // obj 参数是 nullable，可为空
    [dict setObject:nil forKeyedSubscript:@"AA"];
    
    // obj 参数没有指明，但方法声明包裹在 NS_ASSUME_NONNULL_BEGIN 和 NS_ASSUME_NONNULL_END 中间，所以是 nonnull
    // 警告：Null passed to a callee that requires a non-null argument
//    [dict setObject:nil forKey:@"AA"];  // 运行崩溃
}

@end
