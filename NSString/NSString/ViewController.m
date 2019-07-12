//
//  ViewController.m
//  NSString
//
//  Created by CYKJ on 2019/5/22.
//  Copyright © 2019年 D. All rights reserved.


#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSString * sString;
@property (nonatomic, copy) NSString * cString;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

@end
