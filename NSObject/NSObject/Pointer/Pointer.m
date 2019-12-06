//
//  Pointer.m
//  NSObject
//
//  Created by CYKJ on 2019/12/2.
//  Copyright © 2019年 D. All rights reserved.
//

#import "Pointer.h"

@implementation Pointer

/**
 *  @brief   测试指针
 */
- (void)testPointer
{
    NSLog(@"*************************");
    
    NSArray * arr = [[NSArray alloc] initWithObjects:@"1", nil];
    NSLog(@"%lu", (unsigned long)arr.retainCount);  // 1
    
    NSArray * arr2 = [[NSArray alloc] initWithObjects:@"2", nil];
    NSLog(@"%p", arr2);  // 0x6000012f09e0
    arr2 = [arr retain];
    
    NSLog(@"%lu", (unsigned long)arr.retainCount);  // 2
    
    NSLog(@"%p   %p", arr, arr2);  // 0x6000012ec1b0   0x6000012ec1b0
    
    // 总结：变量存储着指针地址，地址内存储着内容，当多个变量指向同一片内存时，实际上变量的指针地址是相同的，引用计数值并不等同于印象里的“多根线”。
    
    int a = 2;
    int *p = &a;
    int **pa = &p; // 二级指针：指向指针的指针
    
    // %p  输出十六进制形式的指针地址；%x  输出十六进制无符号整数，没有 0x 前缀
    NSLog(@"%p  %p  %p  %d", pa, *pa, p, *p);
}

@end
