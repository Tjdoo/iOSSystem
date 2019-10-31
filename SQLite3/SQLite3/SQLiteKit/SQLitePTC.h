//
//  SqlitePTC.h
//  SQLite3
//
//  Created by CYKJ on 2019/8/31.
//  Copyright © 2019年 D. All rights reserved.


#import <Foundation/Foundation.h>


@protocol SQLitePTC <NSObject>

@required
/**
  *  @brief   主键
  */
+ (NSString *)primaryKey;

/**
  *  @brief   表名
  */
+ (NSString *)tableName;

/**
  *  @brief   临时表名（在更新表的时候使用）
  */
+ (NSString *)tempTableName;


@optional
/**
  *  @brief   忽略的列名称数组。model 中不需要要映射到数据库的字段名数组
  */
+ (NSArray *)ignoreColumnNames;

/**
  *  @brief   返回字典：key =  类的成员变量名，value =  Sqlite数据类型
  */
+ (NSDictionary *)classIvarNameAndType;

/**
  *  @brief   返回成员变量名数组
  */
+ (NSArray *)allIvarNames;

/**
  *  @brief   更新字段: 新字段名字 -》旧字段名字的映射表。key = 新字段，value = 旧字段
  *  @discussion   因为无法通过代码判断字段是新增的，还是经过修改的
  */
+ (NSDictionary *)updateFieldNewNameReplaceOldName;

@end
