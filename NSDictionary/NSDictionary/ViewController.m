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


@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [NilValue exe];
    [NilObject exe];

    
//*****************************

    
    NSDictionary * dict1 = @{ @"name" : @"Jack", @"age" : @"18" };
    NSMutableDictionary * dict2 = [@{ @"name" : @"Tom" } mutableCopy];
    // addEntriesFromDictionary：复制的时候，value 先执行 retain 方法。相反，每个被复制的 value 都是通过 copyWithZone: 复制产生的副本添加到目标字典。如果两个字典都包含同一个键，则接收字典中该键的上一个值对象将发送一条释放消息，新的值对象将取代它。
    [dict2 addEntriesFromDictionary:dict1];  // 类似：addObjectsFromArray
    NSLog(@"%@", dict2);
    
    
//*****************************
    

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

@end
