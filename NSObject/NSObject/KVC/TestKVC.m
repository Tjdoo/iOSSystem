//
//  TestKVC.m
//  test
//
//  Created by CYKJ on 2019/11/28.


#import "TestKVC.h"

@interface TestKVC_Person : NSObject
{
    NSString * _name;
//    NSString * name;
//    NSString * _isName;
//    NSString * isName;
}
@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) NSInteger age;

@end

@implementation TestKVC_Person
@dynamic name;

+ (BOOL)accessInstanceVariablesDirectly
{
    return NO;
}


#pragma mark - SET

- (void)setName:(NSString *)name
{
    NSLog(@"%s", __func__);
}

//- (void)_setName:(NSString *)name
//{
//    NSLog(@"%s", __func__);
//}


#pragma mark - GET

//- (NSString *)getName
//{
//    NSLog(@"%s", __func__);
//
//    return _name;
//}

//- (NSString *)name
//{
//    NSLog(@"%s", __func__);
//
//    return _name;
//}

//- (NSString *)isName
//{
//    NSLog(@"%s", __func__);
//
//    return _name;
//}

//- (NSString *)_name
//{
//    NSLog(@"%s", __func__);
//
//    return _name;
//}

- (void)setNilValueForKey:(NSString *)key
{
    NSLog(@"%s  %@", __func__, key);
}

@end



@implementation TestKVC

- (void)dowork
{
    TestKVC_Person * p = [[TestKVC_Person alloc] init];
    /*  @dynamic name;（不生成实例变量和 setter 方法）不做处理会直接崩溃 setValue:forUndefinedKey:，处理如下：
     
             1、手动生成 setName: 方法 -》setName: 方法被调用，不崩溃
             2、注释掉 setName: 方法，添加 _setName: 方法 -》_setName: 方法被调用，不崩溃
             3、手动生成 _name 成员变量，+ accessInstanceVariablesDirectly 返回 NO，崩溃：setValue:forUndefinedKey:
             4、+ accessInstanceVariablesDirectly 返回 YES -》不崩溃
             5、依次手动生成 _isName、name、isName 成员变量 -》不崩溃
            */
    [p setValue:@"Tom" forKey:@"name"];
    
    // age 属性的类型时 NSInteger（基础数据类型），触发 setNilValueForKey: 方法
    [p setValue:nil forKey:@"age"];
    
    /* @dynamic name;（不生成实例变量和 getter 方法）不做处理会直接崩溃 valueForUndefinedKey，处理如下：
     
            1、手动生成 - getName 方法 -》- getName 方法被调用，不崩溃；
            2、手动生成 - name 方法 -》- name 方法被调用，不崩溃；
            3、手动生成 - isName 方法 -》-isName 方法被调用，不崩溃；
            4、手动生成 - _name 方法 -》_name 方法被调用，不崩溃；
            5、
            */
    [p valueForKey:@"name"];
}

@end
