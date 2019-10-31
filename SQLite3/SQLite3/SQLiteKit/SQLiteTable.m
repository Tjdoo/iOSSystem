//
//  SQLiteTable.m
//  SQLite3
//
//  Created by CYKJ on 2019/9/2.
//  Copyright © 2019年 D. All rights reserved.


#import "SQLiteTable.h"
#import "SQLitePTC.h"
#import "SQLString.h"
#import "SQLiteManager.h"
#import <Sqlite3.h>


@implementation SQLiteTable

+ (NSArray<NSString *> *)tableColumnNames:(Class<SQLitePTC>)cls
{
    // 获取通过查询数据库中所有的表的来获取相应的模型对应表的 sql 语句
    NSString * sql = [SQLString queryTableColumnNamesSQL:cls];
    
    NSDictionary * dict = [SQLiteManager query:sql].firstObject;
    
    NSLog(@"%@", dict);
    
    if (dict == nil) {
        return nil;
    }
    
    // 对应 SQLiteString 中的方式 ②，根据 key（@"sql"） 取出创建表的 sql 语句
    NSString * createTableSQLString = dict[@"sql"];
    
    // 过滤 \"
    createTableSQLString = [createTableSQLString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    // 过滤 \t
    createTableSQLString = [createTableSQLString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    // 过滤 \n
    createTableSQLString = [createTableSQLString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if (createTableSQLString.length == 0) {
        return nil;
    }
    
    // 分割 createTableSQLString 语句取出相应的字段名
    NSString * nameTypeStr = [createTableSQLString componentsSeparatedByString:@"("][1];
    NSArray * nameTypeArray = [nameTypeStr componentsSeparatedByString:@","];
    
    // 存放字段名的数组
    NSMutableArray * namesArray = [NSMutableArray array];
    
    for (NSString *nameType in nameTypeArray) {
        
        // 根据实际情况处理主键
        if ([nameType containsString:@"primary"]) {
            continue;
        }
        
        // 去除首尾空格
        NSString *nameType2 = [nameType stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        
        // 取出类型名字
        NSString *name = [nameType2 componentsSeparatedByString:@" "].firstObject;
        // 放进数组
        [namesArray addObject:name];
    }
    
    return namesArray;
}

@end
