//
//  TreeTableVC.m
//  UITableView
//
//  Created by CYKJ on 2019/10/25.
//  Copyright © 2019年 D. All rights reserved.


#import "TreeTableVC.h"
#import "Node.h"

@interface TreeTableVC ()

@property (nonatomic, copy) NSArray * allData;    // 全数据
@property (nonatomic, copy) NSArray * dataArray; // 用于列表显示的数据源

@end


@implementation TreeTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    
    // 初始时只展示一级数据
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"parentId = -1"];
    self.dataArray = [self.allData filteredArrayUsingPredicate:predicate];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    
    Node * node = self.dataArray[indexPath.row];
    
    cell.textLabel.text   = node.nodeName;
    
    // 缩进方式 ①
//    cell.indentationLevel = node.depth;  // 缩进等级，从 0 开始
//    cell.indentationWidth = 30;  // 每级缩进 30pt
    
    // 缩进方式 ②
    cell.separatorInset = UIEdgeInsetsMake(0, 15 + 40 * node.depth, 0, 0);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Node * node = self.dataArray[indexPath.row];
    
    if (node.isOpen) {
        // 移除谓词（找到自己的同级）
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"parentId = %d", node.parentId];
        NSArray * brotherArr = [self.dataArray filteredArrayUsingPredicate:predicate];
        
        // 移除数据
        NSInteger idx = [brotherArr indexOfObject:node];
        
        NSMutableArray * mArr = [NSMutableArray arrayWithArray:self.dataArray];
        if (idx == brotherArr.count - 1) {
            // 当下面没有自己的同级时（上面可能有），找到自己的下级
            predicate = [NSPredicate predicateWithFormat:@"parentId = %d", node.nodeId];
            NSArray * needRemoveArr = [self.dataArray filteredArrayUsingPredicate:predicate];
            [mArr removeObjectsInArray:needRemoveArr];
        }
        else {
            Node * nextNode = [brotherArr objectAtIndex:idx + 1];
            [mArr removeObjectsInRange:NSMakeRange(indexPath.row + 1, [self.dataArray indexOfObject:nextNode] - indexPath.row - 1)];
        }
        NSInteger count = self.dataArray.count - mArr.count;
        self.dataArray = mArr;
        
        // 刷新界面
        NSMutableArray * indexPaths = [NSMutableArray arrayWithCapacity:count];
        for (NSInteger i = 0; i < count; ++i) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:(i + indexPath.row + 1) inSection:0]];
        }
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }
    else {
        // 添加谓词（找到自己的下级）
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"parentId = %d", node.nodeId];
        NSArray * needAddArr = [self.allData filteredArrayUsingPredicate:predicate];
        // 添加数据
        NSMutableArray * mArr = [NSMutableArray arrayWithArray:self.dataArray];
        [mArr insertObjects:needAddArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, needAddArr.count)]];
        self.dataArray = mArr;
        
        // 刷新界面
        NSMutableArray * indexPaths = [NSMutableArray arrayWithCapacity:needAddArr.count];
        for (NSInteger i = 0; i < needAddArr.count; ++i) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:(i + indexPath.row + 1) inSection:0]];
        }
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }
    
    // 修改打开状态
    node.open = !node.isOpen;
    
//    [self.tableView reloadData];
}


#pragma mark - GET

- (NSArray *)allData
{
    if (_allData == nil) {
        
        _allData = @[
                       //----------------------------------中国的省地市关系图 --------------------------------------------
                       [[Node alloc] initWithParentId:-1 nodeId:0 nodeName:@"中国🇨🇳" depth:0 isOpen:NO],
                       [[Node alloc] initWithParentId:0 nodeId:1 nodeName:@"江苏" depth:1 isOpen:NO],
                       [[Node alloc] initWithParentId:1 nodeId:2 nodeName:@"南通" depth:2 isOpen:NO],
                       [[Node alloc] initWithParentId:1 nodeId:3 nodeName:@"南京" depth:2 isOpen:NO],
                       [[Node alloc] initWithParentId:1 nodeId:4 nodeName:@"苏州" depth:2 isOpen:NO],
                       [[Node alloc] initWithParentId:0 nodeId:5 nodeName:@"广东" depth:1 isOpen:NO],
                       [[Node alloc] initWithParentId:5 nodeId:6 nodeName:@"深圳" depth:2 isOpen:NO],
                       [[Node alloc] initWithParentId:5 nodeId:7 nodeName:@"广州" depth:2 isOpen:NO],
                       [[Node alloc] initWithParentId:0 nodeId:8 nodeName:@"浙江" depth:1 isOpen:NO],
                       [[Node alloc] initWithParentId:8 nodeId:9 nodeName:@"杭州" depth:2 isOpen:NO],
                        
                        
                       //----------------------------------美国的州市关系图 --------------------------------------------
                       [[Node alloc] initWithParentId:-1 nodeId:10 nodeName:@"美国🇺🇸" depth:0 isOpen:NO],
                       [[Node alloc] initWithParentId:10 nodeId:11 nodeName:@"纽约" depth:1 isOpen:NO],
                       [[Node alloc] initWithParentId:10 nodeId:12 nodeName:@"德州" depth:1 isOpen:NO],
                       [[Node alloc] initWithParentId:12 nodeId:13 nodeName:@"休斯顿" depth:2 isOpen:NO],
                       [[Node alloc] initWithParentId:10 nodeId:14 nodeName:@"加州" depth:1 isOpen:NO],
                       [[Node alloc] initWithParentId:14 nodeId:15 nodeName:@"洛杉矶" depth:2 isOpen:NO],
                       [[Node alloc] initWithParentId:14 nodeId:16 nodeName:@"旧金山" depth:2 isOpen:NO],
                       
                       
                       //----------------------------------日本的省地市关系图 --------------------------------------------
                       [[Node alloc] initWithParentId:-1 nodeId:17 nodeName:@"日本🇯🇵" depth:0 isOpen:NO],
                       [[Node alloc] initWithParentId:17 nodeId:18 nodeName:@"京东" depth:1 isOpen:NO],
                       [[Node alloc] initWithParentId:17 nodeId:19 nodeName:@"大阪" depth:1 isOpen:NO],
                       [[Node alloc] initWithParentId:17 nodeId:20 nodeName:@"神户" depth:1 isOpen:NO]
                       
                       
                       ];
    }
    return _allData;
}

@end
