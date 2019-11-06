//
//  block4.m
//  Block
//
//  Created by D on 2019/5/4.
//  Copyright © 2019 D. All rights reserved.


#import <Foundation/Foundation.h>


struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
};


struct __block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
};


/**
  *  @brief   模仿系统  __main_block_impl_0 结构体
  */
struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
    int age;
};


/**
  *  @brief   验证 block 的本质确实是 __main_block_impl_0 结构体类型。
 
      按照 .cpp 文件分析的 block 内部结构来自定义结构体，并将 block 内部的结构体强制转化为自定义的结构体，转化成功，即说明底层结构体确实如 .cpp 文件中所分析的那样
  */
int main(int argc, const char * argv[]) {
    @autoreleasepool {

        int age = 10;

        void(^ block)(int, int) = ^(int a, int b){
            NSLog(@"a = %d，b = %d", a, b);
            NSLog(@"age = %d", age);
        };

        // 将底层的结构体强制转化为我们自己写的结构体，通过我们自定义的结构体探寻block底层结构体
        struct __main_block_impl_0 * blockStruct = (__bridge struct __main_block_impl_0 *)block;

        block(3, 5);
    }
    return 0;
}
