//
//  ViewController.m
//  NSArray
//
//  Created by CYKJ on 2019/9/24.
//  Copyright © 2019年 D. All rights reserved.


#import "ViewController.h"
#import "CustomModel.h"


@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self nscopyDemo];
    [self nscodingDemo];
}

/**
  *  @brief   演示 NSCopy 的作用
  *  @see   【iOS对象数组的深copy】（https://www.jianshu.com/p/921f35d81e00）
  *  @see   【NSCopying和NSMutableCopying协议】（https://www.jianshu.com/p/f84803356cbb）
  */
- (void)nscopyDemo
{
    NSLog(@"******************  NSCoping  *****************\n");
    
    CustomPerson * person1 = [[CustomPerson alloc] init];
    person1.name = @"A";
    CustomPerson * person2 = [[CustomPerson alloc] init];
    person2.name = @"B";
    CustomThing * thing1 = [[CustomThing alloc] init];
    thing1.name = @"Bed";
    CustomThing * thing2 = [[CustomThing alloc] init];
    thing2.name = @"Cup";
    
    CustomModel * model = [[CustomModel alloc] init];
    model.persons = (NSArray<CustomPerson> *)@[ person1, person2 ];
    model.things  = (NSArray<CustomThing> *)@[ thing1, thing2 ];
    
    // 未拷贝
    CustomModel * model2 = model;
    // 深拷贝
    CustomModel * copyedModel = model.copy;
    
    person1.name = @"C";
    
    NSLog(@"%@ , person1 = %@", model, [ model.persons.firstObject name]);
    NSLog(@"%@ , person1 = %@", model2, [ model2.persons.firstObject name]);
    NSLog(@"%@ , person1 = %@", copyedModel, [copyedModel.persons.firstObject name]);
}

- (void)nscodingDemo
{
    NSLog(@"******************  NSCoding  *****************\n");

    CustomPerson * person1 = [[CustomPerson alloc] init];
    person1.name = @"A";
    CustomPerson * person2 = [[CustomPerson alloc] init];
    person2.name = @"B";
    CustomThing * thing1 = [[CustomThing alloc] init];
    thing1.name = @"Bed";
    CustomThing * thing2 = [[CustomThing alloc] init];
    thing2.name = @"Cup";
    
    CustomModel * model = [[CustomModel alloc] init];
    model.persons = (NSArray<CustomPerson> *)@[ person1, person2 ];
    model.things  = (NSArray<CustomThing> *)@[ thing1, thing2 ];
    
    CustomModel * codingModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:model]];
    
    person1.name = @"C";

    NSLog(@"%@ , person1 = %@", model, [model.persons.firstObject name]);
    NSLog(@"%@ , person1 = %@", codingModel, [codingModel.persons.firstObject name]);
}

@end
