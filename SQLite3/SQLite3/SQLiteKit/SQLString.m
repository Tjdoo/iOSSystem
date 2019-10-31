//
//  SQLString.m
//  SQLite3
//
//  Created by CYKJ on 2019/8/31.
//  Copyright © 2019年 D. All rights reserved.


#import "SQLString.h"
#import "SQLitePTC.h"
#import "SQLiteManager.h"


@implementation SQLString

+ (NSString *)createTableSQL:(Class<SQLitePTC>)cls
{
    if ([cls respondsToSelector:@selector(classIvarNameAndType)]) {
        
        NSMutableArray * resultArr = [NSMutableArray array];
        
        NSDictionary * dict = [cls classIvarNameAndType];
        
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key,
                                                  NSString * _Nonnull obj,
                                                  BOOL * _Nonnull stop) {
            [resultArr addObject:[NSString stringWithFormat:@"%@ %@", key, obj]];
        }];
        
        // create table if not exists 表名 (字段 数据类型(约束), ... , primary key (字段))
        return [NSString stringWithFormat:@"create table if not exists %@ (%@, primary key(%@));", [cls tableName], [resultArr componentsJoinedByString:@","], [cls primaryKey]];
    }
    
    return nil;
}

+ (NSString *)createTempTableSQL:(Class<SQLitePTC>)cls
{
    if ([cls respondsToSelector:@selector(classIvarNameAndType)]) {
        
        NSMutableArray * resultArr = [NSMutableArray array];
        
        NSDictionary * dict = [cls classIvarNameAndType];
        
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key,
                                                  NSString * _Nonnull obj,
                                                  BOOL * _Nonnull stop) {
            [resultArr addObject:[NSString stringWithFormat:@"%@ %@", key, obj]];
        }];
        
        // create table if not exists 表名 (字段 数据类型(约束), ... , primary key (字段))
        return [NSString stringWithFormat:@"create table if not exists %@ (%@, primary key(%@));", [cls tempTableName], [resultArr componentsJoinedByString:@","], [cls primaryKey]];
    }
    
    return nil;
}

+ (NSString *)deleteTableSQL:(Class<SQLitePTC>)cls
{
    return [NSString stringWithFormat:@"drop table if exists %@", [cls tableName]];
}

+ (NSString *)deleteTempTableSQL:(Class<SQLitePTC>)cls
{
    return [NSString stringWithFormat:@"drop table if exists %@", [cls tempTableName]];
}

+ (NSString *)movePrimaryKeyToTempTableSQL:(Class<SQLitePTC>)cls
{
    // 需要判断各个协议方法是否实现了
    return [NSString stringWithFormat:@"insert into %@(%@) select %@ from %@;", [cls tempTableName], [cls primaryKey], [cls primaryKey], [cls tableName]];
}

+ (NSString *)renameTempTable:(Class<SQLitePTC>)cls
{
    return [NSString stringWithFormat:@"alter table %@ rename to %@;", [cls tempTableName], [cls tableName]];
}

+ (NSString *)queryTableColumnNamesSQL:(Class<SQLitePTC>)cls
{
    /*  获取建表的 sql 语句。注意：sqlite_master，SQLite 数据库中的一个内置表。这里要添加反斜杆。
             {
                    sql = "CREATE TABLE Person (height real,age integer,pId integer,birth text,name text, primary key(pId))";
             }
            */
    return [NSString stringWithFormat:@"select sql from sqlite_master where type = \'table\' and tbl_name = \'%@\'", [cls tableName]];
}

+ (NSString *)insertDataSQL:(Class<SQLitePTC>)cls
{
    NSArray * arr = [cls allIvarNames];

    NSMutableArray * mArr = [NSMutableArray arrayWithCapacity:arr.count];
    for (int i = 0; i < arr.count; i++) {
        [mArr addObject:@"?"];
    }
    
    return [NSString stringWithFormat:@"insert into %@(%@) values (%@)", [cls tableName], [arr componentsJoinedByString:@","], [mArr componentsJoinedByString:@","]];
}

@end
