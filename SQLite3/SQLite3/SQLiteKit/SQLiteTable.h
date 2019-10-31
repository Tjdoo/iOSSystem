//
//  SQLiteTable.h
//  SQLite3
//
//  Created by CYKJ on 2019/9/2.
//  Copyright © 2019年 D. All rights reserved.


#import <Foundation/Foundation.h>

@protocol SQLitePTC;
@interface SQLiteTable : NSObject

/**
  *  @brief   获取表中的所有字段名
  */
+ (NSArray<NSString *> *)tableColumnNames:(Class<SQLitePTC>)cls;

@end
