//
//  SQLiteManager.h
//  SQLite3
//
//  Created by CYKJ on 2019/8/31.
//  Copyright © 2019年 D. All rights reserved.


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SQLitePTC;
@interface SQLiteManager : NSObject

/**
  *  @brief   数据库名称机制：未登录时使用统一的公共的数据库；登陆后，根据用户的 id 创建对应的数据库
  */
+ (NSString *)dbName;

/**
  *  @brief   打开/关闭数据库
  */
+ (BOOL)openDB;
+ (BOOL)closeDB;

/**
  *  @brief   创建/删除表。
  *  @param   cls   类名。通过类名可以获得 tableName
  */
+ (BOOL)createTableByClass:(Class<SQLitePTC>)cls;
+ (BOOL)deleteTableByClass:(Class<SQLitePTC>)cls;

/**
  *  @brief   判断是否更新表。例如：表有新增或修改字段
  */
+ (BOOL)needUpdateTable:(Class<SQLitePTC>)cls;
+ (BOOL)doUpdateTable:(Class<SQLitePTC>)cls;

/**
  *  @brief   执行'增'、'删'、'改' sql 语句
  */
+ (BOOL)execute:(NSString *)sql;
/**
  *  @brief   执行多条 sql 语句
  */
+ (BOOL)executeSqls:(NSArray<NSString *> *)sqls;
/**
  *  @brief   执行'查' sql 语句
  */
+ (NSMutableArray<NSMutableDictionary *> *)query:(NSString *)sql;

/**
  *  @brief   插入数据
  */
+ (BOOL)insertData:(id<SQLitePTC>)obj;

@end
