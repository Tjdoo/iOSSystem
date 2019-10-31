//
//  Person.m
//  SQLite3
//
//  Created by CYKJ on 2019/8/31.
//  Copyright © 2019年 D. All rights reserved.


#import "Person.h"
#import <objc/runtime.h>


@implementation Person

static NSDictionary * mapDict;

+ (NSString *)tableName
{
    return NSStringFromClass(self);
}

+ (NSString *)tempTableName
{
    return [NSStringFromClass(self) stringByAppendingString:@"tmp"];
}

+ (NSString *)primaryKey
{
    return @"pId";
}

+ (NSArray *)ignoreColumnNames
{
    return @[ @"needIgnore1", @"needIgnore2" ];
}

/**
  *  @brief   返回字典：key =  类的成员变量名，value = Sqlite数据类型
  */
+ (NSDictionary *)classIvarNameAndType
{
    NSMutableDictionary * mDict = [NSMutableDictionary dictionaryWithCapacity:10];
    NSArray * ignoreNamesArray = nil;
    
    // 需要忽略的字段
    ignoreNamesArray = [self ignoreColumnNames];
    
    unsigned int count;
    // 成员变量列表
    Ivar * ivarList = class_copyIvarList(self, &count);
    
    for (int i = 0; i < count; i++) {
        
        Ivar ivar = ivarList[i];
        // ①、获取成员变量的名字
        NSString * ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        if ([ivarName hasPrefix:@"_"]) {
            // 去掉 '_'，读取后面的
            ivarName = [ivarName substringFromIndex:1];
        }
        
        // ②、处理忽略的字段
        if ([ignoreNamesArray containsObject:ivarName]) {
            continue;
        }
        
        // ③、获取成员变量类型
        NSString * ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        
        // 把包含 @\" 的去掉，如  @\"NSString\"  -》 NSString
        ivarType = [ivarType stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];
        
        // ④、将 oc 类型转为 sqlite 数据库类型
        ivarType = [self __switchOCTypeToSqliteType:ivarType];
        
        [mDict setValue:ivarType forKey:ivarName];
    }
    
    return mDict;
}

+ (NSString *)__switchOCTypeToSqliteType:(NSString *)ocType
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapDict = @{ @"d": @"real",     // double
                     @"f": @"real",     // float
                     @"i": @"integer",  // int
                     @"q": @"integer",  // long
                     @"Q": @"integer",  // long long
                     @"B": @"integer",  // bool
                     @"NSData": @"blob",// 二进制
                     @"NSDictionary": @"text",
                     @"NSMutableDictionary": @"text",
                     @"NSArray": @"text",
                     @"NSMutableArray": @"text",
                     @"NSString": @"text"
                     };
    });
    
    if ([mapDict.allKeys containsObject:ocType]) {
        return mapDict[ocType];
    }
    return @"text";
}

/**
  *  @brief   返回所有的成员变量名数组
  */
+ (NSArray *)allIvarNames
{
    return [[self classIvarNameAndType] allKeys];
}

@end
