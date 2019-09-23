//
//  ViewController.m
//  NSPointerArray
//
//  Created by CYKJ on 2019/9/23.
//  Copyright © 2019年 D. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSPointerArray * weakPointerArray;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 【NSPointerArray实现数组的弱引用】（https://www.jianshu.com/p/551ece41b42b）
    
    // 初始化一个弱引用数组对象
    _weakPointerArray = [NSPointerArray weakObjectsPointerArray];
    
    for(int i = 0; i < 10; i++) {
        NSObject * obj = [NSObject new];
        // 往数组中添加对象
        [_weakPointerArray addPointer:(__bridge void * _Nullable)(obj)];
    }
    NSLog(@"%@", _weakPointerArray);

    // 输出数组中的所有对象，如果没有对象会输出一个空数组
    NSArray * array = [_weakPointerArray allObjects];
    NSLog(@"%@", array);  // 输出：()
    
    // 输出数组中的元素个数，包括 NULL
    NSLog(@"%zd", _weakPointerArray.count);  // 输出：10。NSObject 在 for 循环之后就被释放了，_weakPointerArray 内都是 NULL
    
    // 先数组中添加一个NULL
    [_weakPointerArray addPointer:NULL];
    NSLog(@"%zd",_weakPointerArray.count);   // 输出：11
    
    // 清空数组中的所有 NULL
    // 注意：经过测试，如果直接 compact 无法清空 NULL，需要在 compact 之前，调用一次 [_weakPointerArray addPointer:NULL] 才可以清空
    [_weakPointerArray compact];
    NSLog(@"%zd",_weakPointerArray.count);   // 输出：0
    
    //注意：如果直接往 _weakPointerArray 中添加对象，那么 addPointer 方法执行完毕之后，NSObject 会直接被释放掉
    [_weakPointerArray addPointer:(__bridge void * _Nullable)([NSObject new])];
    NSLog(@"%@", [_weakPointerArray allObjects]);  // 输出：()
    
    // 应该这样添加对象
    NSObject * obj = [NSObject new];
    [_weakPointerArray addPointer:(__bridge void * _Nullable)obj];
    NSLog(@"%@",[_weakPointerArray allObjects]); //输出:NSPointArray[7633:454561] ("<NSObject: 0x6000000078c0>")
    
    
    /*  同样的：NSMapTable 对应 NSDictionary，NSHashTable 对应 NSSet  */
    
    // ⚠️ 如果在 MRC（手动管理内容）环境下，输出不同 ⚠️
}


@end
