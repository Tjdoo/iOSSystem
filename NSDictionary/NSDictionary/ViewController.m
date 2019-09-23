//
//  ViewController.m
//  NSDictionary
//
//  Created by CYKJ on 2019/5/15.
//  Copyright © 2019年 D. All rights reserved.


#import "ViewController.h"
#import "NilValue.h"
#import "NilObject.h"


@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [NilValue exe];
    [NilObject exe];
    
    NSDictionary * dict1 = @{ @"name" : @"Jack", @"age" : @"18" };
    NSMutableDictionary * dict2 = [@{ @"name" : @"Tom" } mutableCopy];
    // addEntriesFromDictionary：复制的时候，value 先执行 retain 方法。相反，每个被复制的 value 都是通过 copyWithZone: 复制产生的副本添加到目标字典。如果两个字典都包含同一个键，则接收字典中该键的上一个值对象将发送一条释放消息，新的值对象将取代它。
    [dict2 addEntriesFromDictionary:dict1];  // 类似：addObjectsFromArray
    NSLog(@"%@", dict2);
}

@end
