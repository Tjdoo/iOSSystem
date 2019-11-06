//
//  MainVC.m
//  NSObject
//
//  Created by CYKJ on 2019/10/25.
//  Copyright © 2019年 D. All rights reserved.


#import "MainVC.h"


@interface KVO_Person : NSObject
@property (nonatomic, copy) NSString * name;
@end

@implementation KVO_Person
@end



@interface MainVC ()

@property (nonatomic, copy) NSArray * dataArray;

@end


@implementation MainVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];

    [self __testKVO];
}

/**
  *  @brief   测试 kvo 受线程的影响
  */
- (void)__testKVO
{
    NSLog(@"**********************");

    KVO_Person * p = [[KVO_Person alloc] init];
    [p addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2);
        NSLog(@"AsyncThread: %@", [NSThread currentThread]);
        p.name = @"aa";
    });
    NSLog(@"%@", [NSThread currentThread]);
    p.name = @"bb";
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"**********************");
    NSLog(@"currentThread: %@", [NSThread currentThread]);
    NSLog(@"mainThread: %@", [NSThread mainThread]);
    NSLog(@"%@", change[NSKeyValueChangeNewKey]);
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
