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

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self __copyStrongString];
    
    NSLog(@"银行卡号：%@s", [self getNewBankNum:@"6227273827638465" whiteSpaceCount:1]);
    
    [self __nsDataAppendString];
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

- (void)__nsDataAppendString
{
    NSString * string = @"hello, this is a test\n";
    NSData * data1 = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData * data2 = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData * data3 = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"data1 address: %zd", [data1 bytes]);
    NSLog(@"data2 address: %zd", [data2 bytes]);
    NSLog(@"data3 address: %zd", [data3 bytes]);
}

@end
