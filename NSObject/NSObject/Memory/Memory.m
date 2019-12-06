//
//  Memory.m
//  NSObject
//
//  Created by CYKJ on 2019/12/2.
//  Copyright © 2019年 D. All rights reserved.


#import "Memory.h"
#import <malloc/malloc.h>
#import "MainPerson.h"
#import <objc/runtime.h>


@implementation Memory

/**
 *  @brief   测试开辟内存空间
 */
- (void)testMemory
{
    NSLog(@"*************************");
    
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

int a = 11;   // 已初始化的全局变量，0x107166cd0
int b;        // 未初始化的全局变量，0x107166f30
static int c = 12; // 已初始化的静态全局变量，0x107166cd8
static int d;      // 未初始化的静态全局变量，0x107166dac

- (void)demo1
{
    NSLog(@"*************************");

    static int e = 13;  // 0x107166cd4
    static int f;  // 0x107166da8
    
    // 已初始化的静态变量、全局变量
    NSLog(@"a = %p, c = %p, e = %p", &a, &c, &e);
    // 未初始化的静态变量、全局变量
    NSLog(@"b = %p, d = %p, f = %p", &b, &d, &f);

    int g = 14;  // 0x7ffee8aa14a0
    int h;  // 0x7ffee8aa14a4
    
    // 局部变量
    NSLog(@"g = %p, h = %p", &g, &h);
    
    const int  i = 10;
    //
    NSLog(@"i = %p", &i);
    
    
    NSString * s1 = @"a";
    NSString * s2 = @"b";
    
    // &s1 = 0x7ffee8aa14a8, s1 = 0x107162fa0, &s2 = 0x7ffee8aa14b0, s2 = 0x107162fc0
    NSLog(@"&s1 = %p, s1 = %p, &s2 = %p, s2 = %p", &s1, s1, &s2, s2);
    
    NSObject * obj1 = [[NSObject alloc] init];
    NSObject * obj2 = [[NSObject alloc] init];
    
    // 局部变量自身的所在地址、指向的地址
    // &obj1 = 0x7ffee8aa1490, obj1 = 0x6000020897d0, &obj2 = 0x7ffee8aa1498, obj2 = 0x600002089ae0
    NSLog(@"&obj1 = %p, obj1 = %p, &obj2 = %p, obj2 = %p", &obj1, obj1, &obj2, obj2);
}

- (void)demo2
{
    NSLog(@"*************************");

    // char
    NSLog(@"char :           %zd 字节", sizeof(char));
    // unsigned char
    NSLog(@"unsigned char :  %zd 字节", sizeof(unsigned char));
    // short
    NSLog(@"short :          %zd 字节", sizeof(short));
    // unsigned short
    NSLog(@"unsigned short : %zd 字节", sizeof(unsigned short));
    // int
    NSLog(@"int :            %zd 字节", sizeof(int));
    // unsigned int
    NSLog(@"unsigned int :   %zd 字节", sizeof(unsigned int));
    // long
    NSLog(@"long :           %zd 字节", sizeof(long));
    // unsigned long
    NSLog(@"unsigned long :  %zd 字节", sizeof(unsigned long));
    // long long
    NSLog(@"long long:       %zd 字节", sizeof(long long));
    // unsigned long long
    NSLog(@"unsigned long long: %zd 字节", sizeof(unsigned long long));
    // float
    NSLog(@"float :          %zd 字节", sizeof(float));
    // double
    NSLog(@"double :         %zd 字节", sizeof(double));
    // 对象
    NSLog(@"NSObject :       %zd 字节", sizeof(NSObject *));
}

struct s {
    short a;
    MainPerson * mp;
    short b;
};

- (void)demo3
{
    struct s s1;
    s1.a = 1;
    MainPerson * _mp = [[MainPerson alloc] init];
    _mp->_name = @"Tom";
    _mp->_age = 16;
    s1.mp = _mp;
    s1.b = 2;
    NSLog(@"%zd, &p = %p", sizeof(s1), &s1);
}


//#pragma pack(1)

struct Struct1 {
    char a;         // 1 字节
    double b;       // 8 字节
    int c;          // 4 字节
    short d;        // 2 字节
} MyStruct1;

struct Struct2 {
    double b;       // 8 字节
    char a;         // 1 字节
    int c;          // 4 字节
    short d;        // 2 字节
} MyStruct2;

struct Struct3 {
    double b;       // 8 字节
    char a;         // 1 字节
    short d;        // 2 字节
    int c;          // 4 字节
} MyStruct3;

struct Struct4 {
    double b;       // 8 字节
    char a;         // 1 字节
    short d;        // 2 字节
    struct Struct3 c;
} MyStruct4;


- (void)demo4
{
    NSLog(@"%zd  %zd  %zd  %zd", sizeof(MyStruct1), sizeof(MyStruct2), sizeof(MyStruct3), sizeof(MyStruct4));  // 24   24   16   40
    
    NSLog(@"%zd", sizeof(MyStruct1));
    NSLog(@"%ld, %ld, %ld, %ld", (long)&MyStruct1.a, (long)&MyStruct1.b, (long)&MyStruct1.c, (long)&MyStruct1.d);
}

@end
