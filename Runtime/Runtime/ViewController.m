//
//  ViewController.m
//  Runtime
//
//  Created by CYKJ on 2019/6/22.
//  Copyright © 2019年 D. All rights reserved.


#import "ViewController.h"
#import "Person.h"
#import <objc/message.h>
#import "MsgObject.h"
#import "Model.h"
#import "KVO.h"
#import <objc/runtime.h>


@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSArray * data;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    Person * p = [[Person alloc] init];
//    [p setName:@"Hello"];
    // 发送消息。类似于查字典的过程，在 Person 类里面查，根据 SEL（方法编号） 去查
    ((void(*)(id, SEL, id))objc_msgSend)(p, @selector(setName:), @"Hello MsgSend!");
    
    NSLog(@"%@", p.name);
    NSLog(@"");
    //------------------------------------------------------------------------------------------------------------
 
    // ①、消息转发
//    MsgObject * msg = [[MsgObject alloc] init];
//    [msg dowork];
    [[MsgObject new] dowork];
    
    
    // ③、字典转模型
    Model * model = [[Model alloc] initWithDictionary:@{ @"name" : @"D" }];
    NSLog(@"");
    NSLog(@"name = %@", model.name);
    NSLog(@"");
    
    // ④、系统 KVO
    Person * p1 = [Person new];
    Person * p2 = [Person new];
    
    p1.name = @"D";

    SEL sel = @selector(setName:);
    NSLog(@"Before Observer -- p1: %p, p2: %p", [p1 methodForSelector:sel], [p2 methodForSelector:sel]);
    [p2 addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    
    p2.name = @"Z";
    
    NSLog(@"After Observer -- p1: %p, p2: %p", [p1 methodForSelector:sel], [p2 methodForSelector:sel]);
    NSLog(@"p1 = %@", object_getClass(p1));
    NSLog(@"p2 = %@", object_getClass(p2));
    
    // 自定义 KVO
    KVO * kvo = [[KVO alloc] init];
    [kvo cs_addObserver:self forKeyPath:@"time" options:NSKeyValueObservingOptionNew context:NULL];
    kvo.time = @"2019-06-20";
    
    // HOOk
    Person * pp = [[Person alloc] init];
    Method methodP = class_getInstanceMethod(Person.class, @selector(test));
    Method methodVC = class_getInstanceMethod(self.class, @selector(hook_test));
    method_exchangeImplementations(methodP, methodVC);
    [pp test];
}

- (void)hook_test
{
    [self hook_test];  // [Person hook_test]: unrecognized selector sent to instance 0x600000df4360'
    
    // 此时的 self 是 pp，Person 类中并没有名为 hook_test 的方法
    // 解决方法 ①：addMethod
    // 解决方法 ②：method_setImplementation()
    
    NSLog(@"%@ test", self);
}


#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = self.data[indexPath.section][indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.0f;
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"time"]) {
        NSLog(@"%@ - %@:%@", [object class], keyPath, change[@"time"]);
    }
}


#pragma mark - GET

- (NSArray *)data
{
    if (_data == nil) {
        _data = @[ @[], @[ @"1", @"2" ], @[] ];
    }
    return _data;
}

@end
