//
//  UIImageTests.m
//  UIImageTests
//
//  Created by CYKJ on 2019/7/8.
//  Copyright © 2019年 D. All rights reserved.


#import <XCTest/XCTest.h>
#import "ScaleTool.h"

@interface UIImageTests : XCTestCase

@end

@implementation UIImageTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testDoScale1
{
    UIImage * image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image"
                                                                                       ofType:@"jpg"]];
    [self measureBlock:^{
        [ScaleTool doScale1:image ratio:100.0/3600];
    }]; // 0.014 sec
}

- (void)testDoScale2
{
    UIImage * image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image"
                                                                                       ofType:@"jpg"]];
    [self measureBlock:^{
        [ScaleTool doScale2:image ratio:100.0/3600];
    }]; // 0.019 sec、0.016sec
}

- (void)testDoScale3
{
    UIImage * image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image"
                                                                                       ofType:@"jpg"]];
    [self measureBlock:^{
        [ScaleTool doScale3:image ratio:100.0/3600];
    }]; // 0.228 sec
}

- (void)testDoScaleWithImagePath3
{
    [self measureBlock:^{
        [ScaleTool doScaleWithImagePath3:[[NSBundle mainBundle] pathForResource:@"image" ofType:@"jpg"]
                                   ratio:100.0/3600];
    }];  // 0.025 sec、0.021 sec
}

- (void)testDoScale4
{
    UIImage * image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image"
                                                                                       ofType:@"jpg"]];
    [self measureBlock:^{
        [ScaleTool doScale4:image ratio:100.0/3600];
    }];  // 0.067 sec
}

@end
