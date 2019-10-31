//
//  SQLite3MangerTests.m
//  SQLite3Tests
//
//  Created by CYKJ on 2019/9/2.
//  Copyright © 2019年 D. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SQLiteManager.h"

@interface SQLite3MangerTests : XCTestCase

@end

@implementation SQLite3MangerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [SQLiteManager createTableByClass:NSClassFromString(@"Person")];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
