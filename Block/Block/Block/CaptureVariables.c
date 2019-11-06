//
//  CaptureVariables.m
//  Block
//
//  Created by D on 2019/5/4.
//  Copyright © 2019 D. All rights reserved.


#include <stdio.h>

/**
  *  @brief   为了保证 block 内部能够正常访问外部的变量，block 有一个变量捕获机制。
 
        变量的捕获：①、局部变量：auto 变量、static 变量
                                ②、全局变量：
  */
int c = 10;
static int d = 11;

int main() {

    auto int a   = 10;
    static int b = 11;

    void(^ block)(void) = ^{
        printf("a = %d，b = %d\n", a, b);  // a = 10，b = 1
        printf("c = %d，d = %d", c, d);    // c = 1，d = 1
    };
    a = 1;
    b = 1;
    c = 1;
    d = 1;

    // block 中 a 的值没有被改变，b 的值随外部变化而变化。

    block();

    return 0;
}
