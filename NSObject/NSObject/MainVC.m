//
//  MainVC.m
//  NSObject
//
//  Created by CYKJ on 2019/10/25.
//  Copyright © 2019年 D. All rights reserved.


#import "MainVC.h"
#import "KVO.h"
#import "Inline.h"
#import "Static.h"
#import "TestKVC.h"
#import <objc/runtime.h>
#import "MainPerson.h"
#import <malloc/malloc.h>


@interface MainVC ()

@property (nonatomic, copy) NSArray * dataArray;
@property (nonatomic, strong) KVO * kvo;

@end


@implementation MainVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    
//    _kvo = [[KVO alloc] init];
//    [_kvo dowork];
    
//    inlineFunc(@"inline func");
//    [[[Inline alloc] init] dowork];
//
//    staticFunc();
    
//    [[TestKVC alloc] dowork];
    
    [self __testMemory];
    [self __testPointer];
}

/**
  *  @brief   测试开辟内存空间
  */
- (void)__testMemory
{
    NSLog(@"*************************");

    NSLog(@"%zd  %zd  %zd  %zd  %zd  %zd", sizeof(int), sizeof(long), sizeof(long long), sizeof(float), sizeof(double), sizeof(NSString *));
    
    NSLog(@"NSObject Memory = %zd", class_getInstanceSize([NSObject class]));
    //类对象实际需要内存大小
    NSLog(@"Person Memory = %zd", class_getInstanceSize([MainPerson class]));
    MainPerson  * p = [MainPerson alloc];
    //系统分配
    NSLog(@"Person System = %zd", malloc_size((__bridge const void *)p));
    
    //类对象实际需要内存大小
    NSLog(@"Man Memory = %zd", class_getInstanceSize([Man class]));
    Man * m = [Man alloc];
    //系统分配
    NSLog(@"Man System = %zd", malloc_size((__bridge const void *)m));
    
    //类对象实际需要内存大小
    NSLog(@"Student Memory = %zd", class_getInstanceSize([Student class]));
    Student * stu = [Student alloc];
    //系统分配
    NSLog(@"Student System = %zd", malloc_size((__bridge const void *)stu));
    
    Class studentMetaClass = object_getClass([Student class]);
    NSLog(@"Student MetaClass = %@ %p", studentMetaClass, studentMetaClass);
    NSLog(@"isMetaClass : %d", class_isMetaClass(studentMetaClass));
}

/**
  *  @brief   测试指针
  */
- (void)__testPointer
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


#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataArray[indexPath.row][@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:self.dataArray[indexPath.row][@"vcSBID"]];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - GET

- (NSArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = @[ @{ @"title" : @"1. 单例类", @"vcSBID" : @"SingletonVC_SBID" },
                        @{ @"title" : @"2. +initialize 和 +load", @"vcSBID" : @"InitializedLoadVC_SBID" },
                        @{ @"title" : @"3. 分类", @"vcSBID" : @"ProtocolVC_SBID" },
                        @{ @"title" : @"4. 深浅拷贝", @"vcSBID" : @"CopyDeepCopyVC_SBID" } ];
    }
    return _dataArray;
}

@end
