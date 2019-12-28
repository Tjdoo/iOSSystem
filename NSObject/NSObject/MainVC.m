//
//  MainVC.m
//  NSObject
//
//  Created by CYKJ on 2019/10/25.
//  Copyright © 2019年 D. All rights reserved.


#import "MainVC.h"
#import "KVO.h"
#import "Inline.h"
#import "Static.h"
#import "TestKVC.h"
#import "Memory.h"


@interface MainVC ()

@property (nonatomic, copy) NSArray * dataArray;
@property (nonatomic, strong) KVO * kvo;
@property (nonatomic, copy) NSString * name;

@end


@implementation MainVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    
//    _kvo = [[KVO alloc] init];
//    [_kvo dowork];
    
//    inlineFunc(@"inline func");
//    [[[Inline alloc] init] dowork];
//
//    staticFunc();
    
//    [[TestKVC alloc] dowork];
    
//    Memory * m = [[Memory alloc] init];
//    [m demo1];

//    [self test2];
}

- (void)test1
{
    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 1000; i++) {
        dispatch_async(queue, ^{
            self.name = [NSString stringWithFormat:@"abcde"];
        });
    }
}

- (void)test2
{
    // 会崩溃
    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 1000; i++) {
        dispatch_async(queue, ^{
            self.name = [NSString stringWithFormat:@"abcdefghjsfdasdfas"];
        });
    }
}

static NSInteger i = 0;

- (void)setName:(NSString *)name
{
    if (_name != name) {
        
        id pre = _name;
        
        // 1.先保留新值
        [name retain];
        
        // 2.再进行赋值
        _name = name;
        
        // 3.释放旧值
        [pre release];
        NSLog(@"%ld", (long)i++);
    }
}


#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataArray[indexPath.row][@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:self.dataArray[indexPath.row][@"vcSBID"]];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - GET

- (NSArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = @[ @{ @"title" : @"1. 单例类", @"vcSBID" : @"SingletonVC_SBID" },
                        @{ @"title" : @"2. +initialize 和 +load", @"vcSBID" : @"InitializedLoadVC_SBID" },
                        @{ @"title" : @"3. 分类", @"vcSBID" : @"ProtocolVC_SBID" },
                        @{ @"title" : @"4. 深浅拷贝", @"vcSBID" : @"CopyDeepCopyVC_SBID" } ];
    }
    return _dataArray;
}

@end
