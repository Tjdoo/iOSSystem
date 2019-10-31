//
//  ViewController.m
//  SQLite3
//
//  Created by CYKJ on 2019/8/31.
//  Copyright © 2019年 D. All rights reserved.


#import "ViewController.h"
#import "SQLiteManager.h"
#import "SQLiteTable.h"
#import "Person.h"


@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Class cls = NSClassFromString(@"Person");
    
    // 建表
    [SQLiteManager createTableByClass:cls];
    
    // 插入数据
    Person * p = [[Person alloc] init];
    p.pId = 11;
    p.name = @"Tom";
    p.age = 28;
    p.birth = @"1997-1-1";
    p.height = 187.0;
//    p.favorites = @[ @"Basketball", @"football" ];
    [SQLiteManager insertData:p];
    
    // 更新表
    if ([SQLiteManager needUpdateTable:cls]) {
        [SQLiteManager doUpdateTable:cls];
    }
    
    // 删除表
    [SQLiteManager deleteTableByClass:NSClassFromString(@"Person")];
}

@end
