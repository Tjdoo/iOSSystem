//
//  ViewController.m
//  CFBinaryHeap
//
//  Created by CYKJ on 2019/11/28.
//  Copyright © 2019年 D. All rights reserved.


#import "ViewController.h"
#import "Person.h"

@interface ViewController ()
{
    CFBinaryHeapRef _heap;
}
@end

// 持有
static const void * MyDesignRetain(CFAllocatorRef allocator, const void *ptr) {
    return CFRetain(ptr);
}

// 释放
static void MyDesignRelease(CFAllocatorRef allocator, const void *ptr) {
    CFRelease(ptr);
}

// 确定数据之间的比较规则
CFComparisonResult myDesignCompare(const void *ptr1, const void *ptr2, void *context){
    
    Person * p1 = (__bridge Person *)ptr1;
    Person * p2 = (__bridge Person *)ptr2;
    
    if (p1.no < p2.no)
        return kCFCompareLessThan;
    
    if (p1.no > p2.no)
        return kCFCompareGreaterThan;
    
    return kCFCompareEqualTo;
}


@implementation ViewController

- (void)dealloc
{
    if (_heap) {
        CFRelease(_heap);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CFBinaryHeapCallBacks callBacks = (CFBinaryHeapCallBacks){
        .version = 0,
        .retain = &MyDesignRetain,
        .release = &MyDesignRelease,
        .copyDescription = &CFCopyDescription,
        .compare = &myDesignCompare };
    
    /**
         参数 1：为二叉堆及其值存储分配内存的 cfallocator。此参数可以为空，为空时使用 CFAllocatorDefault。如果此引用不是有效的 CFallocator，则行为未定义
         参数 2：有关 CFBinaryHeap 将要保存的值的数量的提示。传递 0 表示无提示。实现可以忽略这个提示，或者使用它来优化各种操作。堆的实际容量仅限于
         地址空间和可用内存约束）。如果此参数为负，则行为未定义。
         参数 3：初始化 CFBinaryHeapCallbacks 结构的指针，用于二进制堆中的每个值。
     */
    _heap = CFBinaryHeapCreate(kCFAllocatorDefault, 0, &callBacks, NULL);
    
    Person * p1 = [[Person alloc] init];
    p1.no = 0;
    
    Person * p2 = [[Person alloc] init];
    p2.no = 4;
    
    Person * p3 = [[Person alloc] init];
    p3.no = 2;
    
    Person * p4 = [[Person alloc] init];
    p4.no = 1;
    
    // 添加数据
    CFBinaryHeapAddValue(_heap, (__bridge const void *)p1);
    CFBinaryHeapAddValue(_heap, (__bridge const void *)p2);
    CFBinaryHeapAddValue(_heap, (__bridge const void *)p3);
    CFBinaryHeapAddValue(_heap, (__bridge const void *)p4);
    
    // 获取数据
    NSInteger count = CFBinaryHeapGetCount(_heap);
    const void **list = calloc(count, sizeof(const void *));
    CFBinaryHeapGetValues(_heap, list);
    
    // c -》CoreFoundation
    CFArrayRef objects = CFArrayCreate(kCFAllocatorDefault, list, count, &kCFTypeArrayCallBacks);
    
    // CoreFoundation -》Foundation
    NSArray * arr = (__bridge_transfer NSArray *)objects;
    
    [arr enumerateObjectsWithOptions:NSEnumerationReverse
                          usingBlock:^(Person * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                              
                              NSLog(@"%d", obj.no);
                          }];
}

@end
