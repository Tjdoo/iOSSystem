//
//  Person.h
//  SQLite3
//
//  Created by CYKJ on 2019/8/31.
//  Copyright © 2019年 D. All rights reserved.


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SQLitePTC.h"


@interface Person : NSObject <SQLitePTC>

@property (nonatomic, assign) NSInteger pId;  // 证件号
@property (nonatomic, copy) NSString * name;  // 姓名
@property (nonatomic, assign) NSInteger age;  // 年龄
@property (nonatomic, copy) NSString * birth; // 生日
@property (nonatomic, assign) CGFloat height; // 升高
//@property (nonatomic, copy) NSArray * favorites;  // 兴趣爱好

@property (nonatomic, copy) NSString * needIgnore1;  // 待忽略的字段
@property (nonatomic, copy) NSString * needIgnore2;  // 待忽略的字段

@end
