//
//  SQLiteManager.m
//  SQLite3
//
//  Created by CYKJ on 2019/8/31.
//  Copyright © 2019年 D. All rights reserved.


#import "SQLiteManager.h"
#import "SQLString.h"
#import "SQLitePTC.h"
#import "SQLiteTable.h"
#import <sqlite3.h>


static NSString * sqliteDBName = @"D_Common_DataBase.sqlite";
static sqlite3 * db = nil;


#define CachePath   [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Caches"]


@implementation SQLiteManager

/// 返回数据库名称
+ (NSString *)dbName
{
    if ([self __isLogin]) {
        return [NSString stringWithFormat:@"D_%@_DataBase.sqlite", [self __userID]];
    }
    return sqliteDBName;
}

/// 打开数据库
+ (BOOL)openDB
{
    NSString * sqlitePath = [self __sqlitePath];
    NSLog(@"SQlite DB path = %@", sqlitePath);
    
    // 打开数据库，不存在的情况下自动创建
    BOOL result = (sqlite3_open(sqlitePath.UTF8String, &db) == SQLITE_OK);
    
    if (result) {
        NSLog(@"打开数据库成功!😁");
    }
    else {
        NSLog(@"打开数据库失败!😭");
    }
    
    return result;
}

/// 关闭数据库
+ (BOOL)closeDB
{
    return (sqlite3_close(db) == SQLITE_OK);
}

/// 建表
+ (BOOL)createTableByClass:(Class<SQLitePTC>)cls
{
    NSString * sql = [SQLString createTableSQL:cls];
    
    NSLog(@"%@", sql);
    
    return [self execute:sql];
}

/// 删表
+ (BOOL)deleteTableByClass:(Class<SQLitePTC>)cls
{
    NSString * sql = [SQLString deleteTableSQL:cls];
    
    NSLog(@"%@", sql);
    
    return [self execute:sql];
}

/// 判断是否要更新表
+ (BOOL)needUpdateTable:(Class<SQLitePTC>)cls
{
    // 类中所有的成员变量
    NSArray * modelNames = [cls allIvarNames];
    modelNames = [modelNames sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    // 表中所有的字段名称
    NSArray * tableNames = [SQLiteTable tableColumnNames:cls];
    tableNames = [tableNames sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];

    BOOL result = [modelNames isEqual:tableNames];
    
    if (result) {
        NSLog(@"%@表不需要更新", [cls tableName]);
    }
    else {
        NSLog(@"%@表有字段更新", [cls tableName]);
    }
    return !result;
}

/// 更新表
+ (BOOL)doUpdateTable:(Class<SQLitePTC>)cls
{
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"模型类需要遵守协议，实现 +(NSString *)primaryKey;，从而得到主键信息");
        return NO;
    }
    NSString * primaryKey = [cls primaryKey];

    NSString * tempTableName = [cls tempTableName]; // 新
    NSString * oldTableName = [cls tableName];  // 旧
    
    // 创建多条 SQL 语句数组
    NSMutableArray * sqlList = [NSMutableArray arrayWithCapacity:2];
    
    // ①、删临时表 sql
    [sqlList addObject:[SQLString deleteTempTableSQL:cls]];
    // ②、创建临时表 sql
    [sqlList addObject:[SQLString createTempTableSQL:cls]];
    // ③、把旧表的主键插入临时表 sql
    [sqlList addObject:[SQLString movePrimaryKeyToTempTableSQL:cls]];
    
    // ④、根据主键把所有旧表中的数据更新到临时表
    {
        NSArray * tempModelNames = [cls allIvarNames];  // 新
        NSArray * oldColumnNames = [SQLiteTable tableColumnNames:cls]; // 旧
        
        NSDictionary * newNameReplaceOldNameDict = @{};
        if ([cls respondsToSelector:@selector(updateFieldNewNameReplaceOldName)]) {
            newNameReplaceOldNameDict = [cls updateFieldNewNameReplaceOldName];
        }
        
        for (NSString * columnName in tempModelNames) {
            // 找旧表的名称
            NSString * name = columnName;
            // 存在映射
            if (newNameReplaceOldNameDict[name] != nil) {
                name = newNameReplaceOldNameDict[name];
            }
            
            // 过滤掉主键（第 ③ 个已经处理）和旧表中没有的字段。注意：这里存在删除了旧表字段的情况
            if ([oldColumnNames containsObject:primaryKey] && ![oldColumnNames containsObject:name] && ![oldColumnNames containsObject:columnName]) {
                continue;
            }
            
            // 根据主键在临时表中插入和旧表一样的数据
            NSString * updateSQL = [NSString stringWithFormat:@"update %@ set %@ = (select %@ from %@ where %@.%@ = %@.%@)", tempTableName, columnName, name, oldTableName, tempTableName, primaryKey, oldTableName, primaryKey];
            
            [sqlList addObject:updateSQL];
        }
    }
    
    // ⑤、删除旧表
    [sqlList addObject:[SQLString deleteTableSQL:cls]];
    
    // ⑥、将临时表改为新表
    [sqlList addObject:[SQLString renameTempTable:cls]];
    
    return [self executeSqls:sqlList];
}

+ (BOOL)insertData:(id)obj
{
    if (![SQLiteManager openDB]) {
        return NO;
    }
    
    Class<SQLitePTC> cls = [obj class];
    
    sqlite3_stmt * stmt = 0x00;
    
    if (sqlite3_prepare_v2(db, [SQLString insertDataSQL:cls].UTF8String, -1, &stmt, nil) != SQLITE_OK) {
        NSLog(@"准备语句编译失败");
        return NO;
    }

    NSArray * modelNames = [cls allIvarNames];
    for (int i = 0; i < modelNames.count; i++) {
        NSString * value = [obj valueForKey:modelNames[i]];
        
        if (value) {
            // 从 1 开始
            [self bindObject:value toColumn:i + 1 inStatement:stmt];
        }
        else {
            return NO;
        }
    }
    
    int result = sqlite3_step(stmt);
    
    if (result == SQLITE_DONE) {
        // all is well, let's return.
    }
    else {
        NSLog(@"%d", result);
    }

    // 释放资源
    sqlite3_finalize(stmt);

    [SQLiteManager closeDB];
    
    return YES;
}

+ (void)bindObject:(id)obj toColumn:(int)idx inStatement:(sqlite3_stmt *)pStmt
{
    if ((!obj) || ((NSNull *)obj == [NSNull null])) {
        sqlite3_bind_null(pStmt, idx);
    }
    // FIXME - someday check the return codes on these binds.
    else if ([obj isKindOfClass:[NSData class]]) {
        const void *bytes = [obj bytes];
        if (!bytes) {
            // it's an empty NSData object, aka [NSData data].
            // Don't pass a NULL pointer, or sqlite will bind a SQL null instead of a blob.
            bytes = "";
        }
        sqlite3_bind_blob(pStmt, idx, bytes, (int)[obj length], SQLITE_STATIC);
    }
    else if ([obj isKindOfClass:[NSDate class]]) {
        sqlite3_bind_double(pStmt, idx, [obj timeIntervalSince1970]);
    }
    else if ([obj isKindOfClass:[NSNumber class]]) {
        
        if (strcmp([obj objCType], @encode(char)) == 0) {
            sqlite3_bind_int(pStmt, idx, [obj charValue]);
        }
        else if (strcmp([obj objCType], @encode(unsigned char)) == 0) {
            sqlite3_bind_int(pStmt, idx, [obj unsignedCharValue]);
        }
        else if (strcmp([obj objCType], @encode(short)) == 0) {
            sqlite3_bind_int(pStmt, idx, [obj shortValue]);
        }
        else if (strcmp([obj objCType], @encode(unsigned short)) == 0) {
            sqlite3_bind_int(pStmt, idx, [obj unsignedShortValue]);
        }
        else if (strcmp([obj objCType], @encode(int)) == 0) {
            sqlite3_bind_int(pStmt, idx, [obj intValue]);
        }
        else if (strcmp([obj objCType], @encode(unsigned int)) == 0) {
            sqlite3_bind_int64(pStmt, idx, (long long)[obj unsignedIntValue]);
        }
        else if (strcmp([obj objCType], @encode(long)) == 0) {
            sqlite3_bind_int64(pStmt, idx, [obj longValue]);
        }
        else if (strcmp([obj objCType], @encode(unsigned long)) == 0) {
            sqlite3_bind_int64(pStmt, idx, (long long)[obj unsignedLongValue]);
        }
        else if (strcmp([obj objCType], @encode(long long)) == 0) {
            sqlite3_bind_int64(pStmt, idx, [obj longLongValue]);
        }
        else if (strcmp([obj objCType], @encode(unsigned long long)) == 0) {
            sqlite3_bind_int64(pStmt, idx, (long long)[obj unsignedLongLongValue]);
        }
        else if (strcmp([obj objCType], @encode(float)) == 0) {
            sqlite3_bind_double(pStmt, idx, [obj floatValue]);
        }
        else if (strcmp([obj objCType], @encode(double)) == 0) {
            sqlite3_bind_double(pStmt, idx, [obj doubleValue]);
        }
        else if (strcmp([obj objCType], @encode(BOOL)) == 0) {
            sqlite3_bind_int(pStmt, idx, ([obj boolValue] ? 1 : 0));
        }
        else {
            sqlite3_bind_text(pStmt, idx, [[obj description] UTF8String], -1, SQLITE_STATIC);
        }
    }
    else {
        sqlite3_bind_text(pStmt, idx, [[obj description] UTF8String], -1, SQLITE_STATIC);
    }
}


#pragma mark - DDL

/// 执行 sql 语句，操作数据库（增删改）
+ (BOOL)execute:(NSString *)sql
{
    if (![self openDB]) {
        return NO;
    }
    /**
            参数 1：已打开的数据库对象
            参数 2：sql 语句
            参数 3：查询时候用到的一个结果集闭包，sqlite3_callback 是回调，当这条语句运行之后，sqlite3 会去调用你提供的这个函数
            参数 4：void * 是你所提供的指针，你能够传递不论什么一个指针参数到这里，这个参数最终会传到回调函数里面。假设不需要传递指针给回调函数，可以传 NULL
            参数 5：报错信息。注意是指针的指针。sqlite3 里面有非常多固定的错误信息。
     
            说明：通常，sqlite3_callback 和它后面的 void * 这两个位置都能够填 NULL。填 NULL 表示不需要回调。比方做 insert、delete、update 操作，就没有必要使用回调。而当你做 select 时，就要使用回调。由于 sqlite3 把数据查出来，得通过回调告诉你查出了什么数据。
         */
    
    BOOL result = (sqlite3_exec(db, sql.UTF8String, nil, nil, nil) == SQLITE_OK);
    
    [self closeDB];
    
    return result;
}

/// 执行多条 sql 语句
+ (BOOL)executeSqls:(NSArray<NSString *> *)sqls
{
    // 开启事务
    [self __beginTransaction];
    
    for (NSString * sql in sqls) {
        BOOL result = [self execute:sql];
        
        // sql 执行失败
        if (!result) {
            // 回滚
            [self __rollBackTransaction];
            return NO;
        }
    }
    
    // 提交事务
    [self __commitTransaction];
    
    // 关闭数据库
    [self closeDB];
    
    return YES;
}


#pragma mark - DQL

/// 执行 sql 语句，操作数据库（查）
+ (NSMutableArray<NSMutableDictionary *> *)query:(NSString *)sql
{
    if (![self openDB]) {
        return nil;
    }
    
    // 准备语句，预处理语句
    sqlite3_stmt * stmt = 0x00;
    
    /**
                参数 1：已打开的数据库对象
                参数 2：sql 语句
                参数 3：参数 2 中取出多少字节的长度。-1 自动计算，\0 停止取出
                参数 4：准备语句
                参数 5：通过参数 3，取出参数 2的长度字节之后，剩下的字符串
            */
    if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, nil) != SQLITE_OK) {
        NSLog(@"准备语句编译失败");
        return nil;
    }
    
    NSMutableArray * result = [NSMutableArray array];
    
    // SQLITE_ROW 代表数据的不断向下查找
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        
        // 存储记录值的字典。数据库中每一行内容转成一个字典
        NSMutableDictionary * mDict = [NSMutableDictionary dictionary];
        
        // 获取所有列数
        NSInteger count = sqlite3_column_count(stmt);
        
        // 遍历所有的列
        for (int i = 0; i < count; i++) {
            // 获取所有列的名称，也就是表中字段的名称
            const char * columnNameC = sqlite3_column_name(stmt, i);
            // C 字符串 -》OC 字符串
            NSString * columnNameOC = [NSString stringWithUTF8String:columnNameC];
            
            /* 获取列的值，不同的数据类型使用不同的获取方法。使用的是 SQLite3，所以是：
             
                                                 SQLITE_INTEGER  1
                                                 SQLITE_FLOAT    2
                                                 SQLITE3_TEXT    3（注意：这里是 SQLITE3_）
                                                 SQLITE_BLOB     4
                                                 SQLITE_NULL     5
                                */
            // 获取列的类型
            int sqliteType = sqlite3_column_type(stmt, i);
            
            id value = nil;
            
            switch (sqliteType) {
                case SQLITE_INTEGER:
                    value = @(sqlite3_column_int(stmt, i));
                    break;
                    
                case SQLITE_FLOAT:
                    value = @(sqlite3_column_double(stmt, i));
                    break;
                    
                case SQLITE_TEXT:
                    value = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, i)];
                    break;
                    
                case SQLITE_BLOB:
                    value = CFBridgingRelease(sqlite3_column_blob(stmt, i));
                    break;
                    
                case SQLITE_NULL:
                    value = @"";
                    break;
                default:
                    break;
            }
            
            [mDict setValue:value forKey:columnNameOC];
        }
        
        [result addObject:mDict];
    }
    
    // 释放资源
    sqlite3_finalize(stmt);
    
    [self closeDB];
    
    return result;
}


#pragma mark - Transaction

/// 开启事务
+ (void)__beginTransaction
{
    [self execute:@"begin transaction"];
}

/// 提交事务
+ (void)__commitTransaction
{
    [self execute:@"commit transaction"];
}

/// 回滚事务
+ (void)__rollBackTransaction
{
    [self execute:@"rollback transaction"];
}


#pragma mark - Tool Func

/// 获取 app 登录状态
+ (BOOL)__isLogin
{
    return NO;
}

/// 获取用户的 id
+ (NSString *)__userID
{
    return @"p128474992495";
}

/// 数据库的路径
+ (NSString *)__sqlitePath
{
    return [CachePath stringByAppendingPathComponent:[self dbName]];
}

@end
