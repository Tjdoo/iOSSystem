//
//  ViewController.m
//  NSDictionary
//
//  Created by CYKJ on 2019/5/15.
//  Copyright © 2019年 D. All rights reserved.


#import "ViewController.h"
#import "NilValue.h"
#import "NilObject.h"
#import "Person.h"
#import "KeyObject.h"


@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [NilValue exe];
    [NilObject exe];
    
    [self __testAddEntriesFromDictionary];
    [self __testCustomKey];
    [self __testHash];
    [self __testCluster];
}

- (void)__testAddEntriesFromDictionary
{
    NSLog(@"*****************************");
    
    NSDictionary * dict1 = @{ @"name" : @"Jack", @"age" : @"18" };
    NSMutableDictionary * dict2 = [@{ @"name" : @"Tom" } mutableCopy];
    // addEntriesFromDictionary：复制的时候，value 先执行 retain 方法。相反，每个被复制的 value 都是通过 copyWithZone: 复制产生的副本添加到目标字典。如果两个字典都包含同一个键，则接收字典中该键的上一个值对象将发送一条释放消息，新的值对象将取代它。
    [dict2 addEntriesFromDictionary:dict1];  // 类似：addObjectsFromArray
    NSLog(@"%@", dict2);
}

/**
  *  @brief   测试自定义对象 key
  */
- (void)__testCustomKey
{
    NSLog(@"*****************************");

    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    /* 当 Person 没有遵守 NSCoping 协议时，报错 ：
                -[Person lengthOfBytesUsingEncoding:]: unrecognized selector sent to instance 0x600000482d40
                *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[Person lengthOfBytesUsingEncoding:]: unrecognized selector sent to instance 0x600000482d40'
     
             官方解释：
                 Using Custom Keys
     
                 In most cases, Cocoa-provided objects such as NSString objects should be sufficient for use as keys. In some cases, however, it may be necessary to use custom objects as keys in a dictionary. When using custom objects as keys, there are some important points to keep in mind.
     
                 Keys must conform to the NSCopying protocol. Methods that add entries to dictionaries—whether as part of initialization (for all dictionaries) or during modification (for mutable dictionaries)— don’t add each key object to the dictionary directly. Instead, they copy each key argument and add the copy to the dictionary. After being copied into the dictionary, the dictionary-owned copies of the keys should not be modified.
     
                 Keys must implement the hash and isEqual: methods because a dictionary uses a hash table to organize its storage and to quickly access contained objects. In addition, performance in a dictionary is heavily dependent on the hash function used. With a bad hash function, the decrease in performance can be severe. For more information on the hash and isEqual: methods see NSObject.
     
                 Important: Because the dictionary copies each key, keys must conform to the NSCopying protocol. Bear this in mind when choosing what objects to use as keys. Although you can use any object that adopts the NSCopying protocol and implements the hash and isEqual: methods, it is typically bad design to use large objects, such as instances of NSImage, because doing so may incur performance penalties.
            */
    Person * p1 = [[Person alloc] init];
    [dict setObject:@"A" forKey:p1];
    NSLog(@"%@", dict);
    NSLog(@"%@", [dict objectForKey:p1]);  // null

    Person * p2 = [[Person alloc] init];
    [dict setObject:@"B" forKey:p2];
    NSLog(@"%@", dict);
}

/**
  *  @brief   修改 hash 方法，实现 NSCoping 协议方法
  */
- (void)__testHash
{
    NSLog(@"*****************************");
    
    NSMutableDictionary * mDict = [NSMutableDictionary dictionaryWithCapacity:3];
    
    KeyObject * key1 = [[KeyObject alloc] initWithHashNum:1];
    [mDict setObject:@"value1" forKey:key1];
    NSLog(@"字典 key1 - value1 添加完毕!");
    
    KeyObject * key2 = [[KeyObject alloc] initWithHashNum:4];
    [mDict setObject:@"value2" forKey:key2];
    NSLog(@"字典 key2 - value2 添加完毕!");

    KeyObject * key3 = [[KeyObject alloc] initWithHashNum:8];
    [mDict setObject:@"value3" forKey:key3];
    NSLog(@"字典 key3 - value3 添加完毕!");
    
    NSLog(@"key1 = %@", key1);
    NSLog(@"key2 = %@", key2);
    NSLog(@"key3 = %@", key3);

    NSLog(@"value1 = %@", [mDict objectForKey:key1]); // value1 被同 value2 覆盖
    NSLog(@"value2 = %@", [mDict objectForKey:key2]);
    NSLog(@"value3 = %@", [mDict objectForKey:key3]);
    
    NSLog(@"allKeys ---> %@", [mDict allKeys]);  // 值与 key1、key2、key3 不同，因为使用 key 时调用了 NSCoping 协议方法
    NSLog(@"allValues ---> %@", [mDict allValues]);
}

/**
  *  @brief   字典的类簇
  */
- (void)__testCluster
{
    // 不可变
    NSDictionary * allocDictionary = [NSDictionary alloc];
    NSLog(@"%@", [allocDictionary class]); // __NSPlaceholderDictionary
    
    NSDictionary * initDictionary = [[NSDictionary alloc] init];
    NSLog(@"%@", [initDictionary class]);  // __NSDictionary0
    
    NSDictionary * singleObjectDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"Tom", @"name", nil];
    NSLog(@"%@", [singleObjectDictionary class]);  // __NSSingleEntryDictionaryI
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Tom", @"name", @"11", @"age", nil];
    NSLog(@"%@", [dict class]);  // __NSDictionaryI
    
    
    // 可变
    NSMutableDictionary * allocMutableDictionary = [NSMutableDictionary alloc];
    NSLog(@"%@", [allocMutableDictionary class]);  // __NSPlaceholderDictionary
    
    NSMutableDictionary * initMutableDictionary = [[NSMutableDictionary alloc] init];
    NSLog(@"%@", [initMutableDictionary class]);  // __NSDictionaryM
    
    NSMutableDictionary * singleObjectMutableDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Tom", @"name", nil];
    NSLog(@"%@", [singleObjectMutableDictionary class]);  // __NSDictionaryM
    
    NSMutableDictionary * mutableDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Tom", @"name", @"11", @"age", nil];
    NSLog(@"%@", [mutableDict class]);  // __NSDictionaryM
    
    
    // 拷贝
    NSDictionary * copyDict = [dict copy];
    NSLog(@"%@", [copyDict class]);  // __NSDictionaryI

    NSDictionary * mutableCopyDict = [dict mutableCopy];
    NSLog(@"%@", [mutableCopyDict class]);  // __NSDictionaryM

    NSMutableDictionary * copyMutableDict = [mutableDict copy];
    NSLog(@"%@", [copyMutableDict class]);  // __NSFrozenDictionaryM
    
    NSMutableDictionary * mutableCopyMutableDict = [mutableDict mutableCopy];
    NSLog(@"%@", [mutableCopyMutableDict class]);  // __NSDictionaryM
}

@end
