//
//  ViewController.m
//  NSString
//
//  Created by CYKJ on 2019/5/22.
//  Copyright © 2019年 D. All rights reserved.


#import "ViewController.h"
#import "NSMutableData+Extension.h"


@interface ViewController ()

@property (nonatomic, strong) NSString * sString;
@property (nonatomic, copy) NSString * cString;

@property (nonatomic, copy) NSString * s1;
@property (nonatomic, weak) NSString * s2;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self __copyStrongString];
    
    NSLog(@"银行卡号：%@s", [self getNewBankNum:@"6227273827638465" whiteSpaceCount:1]);
    
    [self __testNSDataAppendString];
    [self __testCluster];
    [self __testFormat];
    [self __testNilString];
    [self __testStringLength];
}

/**
  *  @brief    copy、strong 修饰的区别
  */
- (void)__copyStrongString
{
    NSMutableString * mString = [NSMutableString string];
    [mString appendFormat:@"AA"];
    
    self.sString = mString;
    self.cString = mString;
    
    // mString -> 0x600002565b30
    //  sString  -> 0x600002565b30
    // cString -> 0xcac34ab7cb397e8b
    NSLog(@"mString -> %p, sString -> %p, cString -> %p", mString, _sString, _cString);
    
    NSLog(@"%@", self.sString);  // 2019-05-22 18:33:53.953437+0800 NSString[26247:855407] AA
    NSLog(@"%@", self.cString);  // 2019-05-22 18:33:53.953437+0800 NSString[26247:855407] AA
    
    [mString appendFormat:@"BB"];
    
    NSLog(@"%@", self.sString);  // 2019-05-22 18:33:53.953580+0800 NSString[26247:855407] AABB
    NSLog(@"%@", self.cString);  // 2019-05-22 18:33:53.953437+0800 NSString[26247:855407] AA
    
    // 结论：strong 指针地址相同，指向同一份内存，copy 复制了一份内存
}

/**
  *  @brief   银行卡号增加间隔
  */
- (NSString *)getNewBankNum:(NSString *)bankNum whiteSpaceCount:(NSInteger)count
{
    NSCharacterSet * cs = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    
    NSMutableString * whiteSpace = [NSMutableString string];
    for (NSInteger i = 0; i < count; i++) {
        [whiteSpace appendString:@" "];
    }
    
    // 去掉“空格”
    bankNum = [bankNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString * newString = @"";
    
    while (bankNum.length > 0) {
        
        NSString * subString = [bankNum substringToIndex:MIN(bankNum.length, 4)];
        
        newString = [newString stringByAppendingString:subString];
        
        if (subString.length == 4) {
            newString = [newString stringByAppendingString:whiteSpace];
        }
        bankNum = [bankNum substringFromIndex:MIN(bankNum.length, 4)];
    }
    
    // 去掉末尾的空格
    return [newString stringByTrimmingCharactersInSet:[cs invertedSet]];
}

/**
  *  @brief   测试高效添加 String
  */
- (void)__testNSDataAppendString
{
    NSLog(@"*********************");

    NSString * string = @"hello, this is a test\n";
    NSData * data1 = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData * data2 = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData * data3 = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"data1 address: %ld", (long)[data1 bytes]);
    NSLog(@"data2 address: %ld", (long)[data2 bytes]);
    NSLog(@"data3 address: %ld", (long)[data3 bytes]);
}

/**
  *  @brief   NSString 类簇
  */
- (void)__testCluster
{
    NSLog(@"*********************");
    
    NSString * str1 = @"1234567890";
    NSLog(@"str1: %@", [str1 class]);  // str1: __NSCFConstantString
    
    NSString * str2 = @"123456789";
    NSLog(@"str2: %@", [str2 class]);  //str2: __NSCFConstantString
    
    NSString * str3 = [NSString stringWithFormat:@"123456789"];
    NSLog(@"str3: %@", [str3 class]);  // str3: NSTaggedPointerString
    
    NSString * str4 = [NSString stringWithFormat:@"1234567890"];
    NSLog(@"str4: %@", [str4 class]);  // str4: __NSCFString
}

/**
  *  @brief   测试 appendFormat: 和 appendString:
  */
- (void)__testFormat
{
    NSLog(@"*********************");

    NSMutableString * mString = [NSMutableString stringWithCapacity:10];
    NSString * string = nil;
    
    [mString appendFormat:@"%@", string];
    
//    [mString appendString:string]; // 崩溃原因 *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[__NSCFString appendString:]: nil argument'
    
    NSLog(@"%@", mString);
}

/**
  *  @brief   测试指针设置 nil 后的现象
 *  @discussion  【解释 1】
             temp 字符串常量是由系统创建管理的，通常情况下存放在内存的常量区。不管有多少对象引用，它本身都不受程序的影响，直到程序结束，由系统进行回收。
              即使 s1 设置为 nil， temp 本身只要没有出这个程序，或者函数，都不会被释放，所以 s2 仍然有值。
 
             另外 s2 = s1 并不是把 s2 指向了 s1，而是 s2 指向了s1 的值。要想 s2 指向 s1 差不多是下边这个样子：
                            NSString ** s2 = s1;    // 需要关闭 arc 才能使用二级指针
             这样 s1 = nil 后 s2 也是 nil 了。
 
    【解释 2】
 
             @"AAAA"; 是个字符串常量，既然是个常量，这块内存不可修改，不可修改就谈不上所谓的释放不释放
 
             self.s1 = nil; 本意是将 @"AAAA" 置为 nil ，但由于没办法修改字符串常量，那么指针只能指向 nil 地址，对原来地址所存内容无修改。
 
             字符串在 c 系语言里面是个很特殊的存在，特殊到什么程度呢，它在编译阶段就已经确定了，所以运行时是没办法修改的。
 
             致于为什么搞成这样，我觉得是因为 c 语言里面没有专门用来存储字符串变量的类型，不过可以退而求其次的使用数组，比如：char a[10] = "abcd" 来保存，但是这种写法既浪费空间效率又低。
  */
- (void)__testNilString
{
    NSLog(@"*********************");
    
    NSString * temp = @"AAAA";
    
    self.s1 = temp;
    NSLog(@"temp -> %p", temp);  // temp -> 0x10313f320
    
    self.s2 = self.s1;
    self.s1 = nil;
    
    NSLog(@"s1 = %@，s2 = %@", self.s1, self.s2);  // s1 = (null)，s2 = AAAA
    NSLog(@"s1 -> %p，s2 -> %p", self.s1, self.s2);  // s1 -> 0x0，s2 -> 0x10313f320
    
    NSLog(@"retainCount = %@", [temp valueForKey:@"retainCount"]);  // retainCount = 18446744073709551615
}

/**
  *  @brief   测试不同长度的字符串
 *  @discussion   通过 [[NSString alloc] initWithFormat:@""] 创建的 NSString 对象存储在内存中的堆区：

             如果字符串长度在 10 以下，那么如果字符串内容一致，内存中只会有一份；
             如果字符串长度在 10 以上，那么就算字符串内容一致，内存中也会有多份。
 
    1、== 是判断内存地址；
    2、NSObject 默认的 isEqual: 底层用的是 ==，NSString 重写了，判断内容；
    3、isEqualToString: 是判断内容
  */
- (void)__testStringLength
{
    NSLog(@"*********************");

    NSString * temp1 = [[NSString alloc] initWithFormat:@"%@", @"AAAAAAA"];
    NSString * temp2 = [[NSString alloc] initWithFormat:@"%@", @"AAAAAAA"];
    NSString * temp3 = [[NSString alloc] initWithFormat:@"%@", @"BBBBBBBBBBBB"];
    NSString * temp4 = [[NSString alloc] initWithFormat:@"%@", @"BBBBBBBBBBBB"];
    
    NSLog(@"%p   %p", temp1, temp2);  // 0xccc41fbf6e72caee   0xccc41fbf6e72caee
    NSLog(@"%p   %p", temp3, temp4);  // 0x6000032a4820   0x6000032a4840
    
    NSLog(@"%d   %d   %d", temp1 == temp2, [temp1 isEqual:temp2], [temp1 isEqualToString:temp2]);
    NSLog(@"%d   %d   %d", temp3 == temp4, [temp3 isEqual:temp4], [temp3 isEqualToString:temp4]);
}

@end
