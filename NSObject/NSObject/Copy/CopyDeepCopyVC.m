//
//  CopyDeepCopyVC.m
//  NSObject
//
//  Created by CYKJ on 2019/11/4.
//  Copyright © 2019年 D. All rights reserved.


#import "CopyDeepCopyVC.h"
#import "Copy_Custom.h"


@implementation CopyDeepCopyVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self __testInArcEnvironment];
    [self __testInMrcEnvironment];
}

/**
  *  @brief   ARC 环境测试。https://www.jianshu.com/p/4e5fde48fcda
  */
- (void)__testInArcEnvironment
{
    NSString * s = @"123";
    NSString * copyS = s.copy;
    NSString * mutableCopyS = s.mutableCopy;
    
    NSLog(@"*************************");
    NSLog(@"s           : %@   %p   %@", s, s, [s class]);
    NSLog(@"copyS       : %@   %p   %@", copyS, copyS, [copyS class]);
    NSLog(@"mutableCopyS: %@   %p   %@", mutableCopyS, mutableCopyS, [mutableCopyS class]);
    // 结论：NSString  copy 出来的对象地址和原对象一样，是浅拷贝，而 mutableCopy 后的对象地址和原对象地址不一样，是深拷贝。
    
    NSMutableString * ms = [NSMutableString stringWithFormat:@"123"];
    NSMutableString * copyMS = ms.copy;
    NSMutableString * mutableCopyMS = ms.mutableCopy;
    
    NSLog(@"*************************");
    NSLog(@"ms           : %@   %p   %@", ms, ms, [ms class]);
    NSLog(@"copyMS       : %@   %p   %@", copyMS, copyMS, [copyMS class]);
    NSLog(@"mutableCopyMS: %@   %p   %@", mutableCopyMS, mutableCopyMS, [mutableCopyMS class]);
    // 结论：NSMutableString  copy 和 mutableCopy 出来的对象地址和原对象地址都不是一样的，是深拷贝。
    
    NSLog(@"*************************");
    NSArray * allocArr = [NSArray alloc];
    NSArray * emptyArr = [[NSArray alloc] init];
    NSLog(@"allocArr: %@, emptyArr: %@", [allocArr class], [emptyArr class]);
    // allocArr: __NSPlaceholderArray, emptyArr: __NSArray0
    
    NSArray * arr = [[NSArray alloc] initWithObjects:@"123", nil];
    NSArray * copyArr = arr.copy;
    NSArray * mutableCopyArr = arr.mutableCopy;
    
    NSLog(@"*************************");
    NSLog(@"arr           : %@   %p   %@", arr, arr, [arr class]);
    NSLog(@"copyArr       : %@   %p   %@", copyArr, copyArr, [copyArr class]);
    NSLog(@"mutableCopyArr: %@   %p   %@", mutableCopyArr, mutableCopyArr, [mutableCopyArr class]);
    // 结论：NSArray copy 所得对象地址和原对象地址相同，是浅拷贝；mutableCopy 后的对象地址和原对象地址不一样，是深拷贝。
    
    NSMutableArray * mArr = [[NSMutableArray alloc] initWithObjects:@"123", nil];
    NSArray * copyMArr = mArr.copy;
    NSArray * mutableCopyMArr = mArr.mutableCopy;
    
    NSLog(@"*************************");
    NSLog(@"mArr           : %@   %p   %@", mArr, mArr, [mArr class]);
    NSLog(@"copyMArr       : %@   %p   %@", copyMArr, copyMArr, [copyMArr class]);
    NSLog(@"mutableCopyMArr: %@   %p   %@", mutableCopyMArr, mutableCopyMArr, [mutableCopyMArr class]);
    // 结论：NSMutableArray copy 和 mutableCopy 所得对象地址和原对象地址都不相同，是深拷贝。
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Tom", @"name", nil];
    NSDictionary * copyDict = dict.copy;
    NSDictionary * mutableCopyDict = dict.mutableCopy;
    
    NSLog(@"*************************");
    NSLog(@"dict           : %@   %p   %@", dict, dict, [dict class]);
    NSLog(@"copyDict       : %@   %p   %@", copyDict, copyDict, [copyDict class]);
    NSLog(@"mutableCopyDict: %@   %p   %@", mutableCopyDict, mutableCopyDict, [mutableCopyDict class]);
    // 结论：NSDictionary  copy 所得对象地址和原对象地址相同，是浅拷贝；mutableCopy 后的对象地址和原对象地址不一样，是深拷贝。
    
    NSMutableDictionary * mDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Tom", @"name", nil];
    NSMutableDictionary * copyMDict = mDict.copy;
    NSMutableDictionary * mutableCopyMDict = mDict.mutableCopy;
    
    NSLog(@"*************************");
    NSLog(@"mDict           : %@   %p   %@", mDict, mDict, [mDict class]);
    NSLog(@"copyMDict       : %@   %p   %@", copyMDict, copyMDict, [copyMDict class]);
    NSLog(@"mutableCopyMDict: %@   %p   %@", mutableCopyMDict, mutableCopyMDict, [mutableCopyMDict class]);
    // 结论：NSMutableDictionary  copy 和 mutableCopy 出来的对象地址和原对象地址都不是一样的，是深拷贝。
    
//    [copyMDict setObject:@"qqq" forKey:@"nnn"];   // 会崩溃。-[__NSFrozenDictionaryM setObject:forKey:]: unrecognized selector sent to instance 0x600000490860
    
    Copy_Custom * cc = [[Copy_Custom alloc] init];
    cc.aa = @"aa";
    
    Copy_Custom * copyCC = cc.copy;
    Copy_Custom * mutableCopyCC = cc.mutableCopy;
    
    NSLog(@"cc           : %@   %p   %@", cc, cc, [cc class]);
    NSLog(@"copyCC       : %@   %p   %@", copyCC, copyCC, [copyCC class]);
    NSLog(@"mutableCopyCC: %@   %p   %@", mutableCopyCC, mutableCopyCC, [mutableCopyCC class]);
    // 自定义对象 copy 和 mutableCopy 后的对象地址都不一样，均为深拷贝。
    
}

/**
  *  @brief   MRC 环境测试
  */
- (void)__testInMrcEnvironment
{
//    NSString * s = @"123";
//    NSString * copyS = s.copy;
//    NSString * mutableCopyS = s.mutableCopy;
//
//    NSLog(@"*************************");
//    NSLog(@"s           : %@   %p   %lu   %@", s, s, [s retainCount], [s class]);
//    NSLog(@"copyS       : %@   %p   %lu   %@", copyS, copyS, [copyS retainCount], [copyS class]);
//    NSLog(@"mutableCopyS: %@   %p   %lu   %@", mutableCopyS, mutableCopyS, [mutableCopyS retainCount], [mutableCopyS class]);
//
//    NSMutableString * ms = [NSMutableString stringWithFormat:@"123"];
//    NSMutableString * copyMS = ms.copy;
//    NSMutableString * mutableCopyMS = ms.mutableCopy;
//
//    NSLog(@"*************************");
//    NSLog(@"ms           : %@   %p   %lu   %@", ms, ms, [ms retainCount], [ms class]);
//    NSLog(@"copyMS       : %@   %p   %lu   %@", copyMS, copyMS, [copyMS retainCount], [copyMS class]);
//    NSLog(@"mutableCopyMS: %@   %p   %lu   %@", mutableCopyMS, mutableCopyMS, [mutableCopyMS retainCount], [mutableCopyMS class]);
//
//    NSArray * arr = [NSArray arrayWithObjects:@"123", nil];
//    NSArray * copyArr = arr.copy;
//    NSArray * mutableCopyArr = arr.mutableCopy;
//
//    NSLog(@"*************************");
//    NSLog(@"arr           : %@   %p   %lu   %@", arr, arr, [arr retainCount], [arr class]);
//    NSLog(@"copyArr       : %@   %p   %lu   %@", copyArr, copyArr, [copyArr retainCount], [copyArr class]);
//    NSLog(@"mutableCopyArr: %@   %p   %lu   %@", mutableCopyArr, mutableCopyArr, [mutableCopyArr retainCount], [mutableCopyArr class]);
//
//    NSMutableArray * mArr = [NSMutableArray arrayWithObjects:@"123", nil];
//    NSArray * copyMArr = mArr.copy;
//    NSArray * mutableCopyMArr = mArr.mutableCopy;
//
//    NSLog(@"*************************");
//    NSLog(@"mArr           : %@   %p   %lu   %@", mArr, mArr, [mArr retainCount], [mArr class]);
//    NSLog(@"copyMArr       : %@   %p   %lu   %@", copyMArr, copyMArr, [copyMArr retainCount], [copyMArr class]);
//    NSLog(@"mutableCopyMArr: %@   %p   %lu   %@", mutableCopyMArr, mutableCopyMArr, [mutableCopyMArr retainCount], [mutableCopyMArr class]);
//
//    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Tom", @"name", nil];
//    NSDictionary * copyDict = dict.copy;
//    NSDictionary * mutableCopyDict = dict.mutableCopy;
//
//    NSLog(@"*************************");
//    NSLog(@"dict           : %@   %p   %lu   %@", dict, dict, [dict retainCount], [dict class]);
//    NSLog(@"copyDict       : %@   %p   %lu   %@", copyDict, copyDict, [copyDict retainCount], [copyDict class]);
//    NSLog(@"mutableCopyDict: %@   %p   %lu   %@", mutableCopyDict, mutableCopyDict, [mutableCopyDict retainCount], [mutableCopyDict class]);
//
//    NSMutableDictionary * mDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Tom", @"name", nil];
//    NSDictionary * copyMDict = mDict.copy;
//    NSDictionary * mutableCopyMDict = mDict.mutableCopy;
//
//    NSLog(@"*************************");
//    NSLog(@"mDict           : %@   %p   %lu   %@", mDict, mDict, [mDict retainCount], [mDict class]);
//    NSLog(@"copyMDict       : %@   %p   %lu   %@", copyMDict, copyMDict, [copyMDict retainCount], [copyMDict class]);
//    NSLog(@"mutableCopyMDict: %@   %p   %lu   %@", mutableCopyMDict, mutableCopyMDict, [mutableCopyMDict retainCount], [mutableCopyMDict class]);
}

@end
