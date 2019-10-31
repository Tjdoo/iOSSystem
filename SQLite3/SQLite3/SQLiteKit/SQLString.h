//
//  SQLString.h
//  SQLite3
//
//  Created by CYKJ on 2019/8/31.
//  Copyright © 2019年 D. All rights reserved.


#import <Foundation/Foundation.h>

@protocol SQLitePTC;
@interface SQLString : NSObject

/**
  *  @brief   创建表/临时表的 sql 语句
  */
+ (NSString *)createTableSQL:(Class<SQLitePTC>)cls;
+ (NSString *)createTempTableSQL:(Class<SQLitePTC>)cls;

/**
  *  @brief   删除表/临时表的 sql 语句
  */
+ (NSString *)deleteTableSQL:(Class<SQLitePTC>)cls;
+ (NSString *)deleteTempTableSQL:(Class<SQLitePTC>)cls;

/**
  *  @brief   将原表的主键移到临时表
  */
+ (NSString *)movePrimaryKeyToTempTableSQL:(Class<SQLitePTC>)cls;

/**
  *  @brief   重命名临时表，隐式改为旧表
  */
+ (NSString *)renameTempTable:(Class<SQLitePTC>)cls;

/**
  *  @brief   查询表字段名的 sql 语句
  */
+ (NSString *)queryTableColumnNamesSQL:(Class<SQLitePTC>)cls;

/**
  *  @brief   插入数据 sql 语句
  */
+ (NSString *)insertDataSQL:(Class<SQLitePTC>)cls;

@end
