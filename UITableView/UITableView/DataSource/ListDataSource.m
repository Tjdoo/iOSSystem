//
//  ListDataSource.m
//  UITableView
//
//  Created by CYKJ on 2019/6/18.
//  Copyright © 2019年 D. All rights reserved.


#import "ListDataSource.h"

@interface ListDataSource ()

@property (nonatomic, assign) BOOL isComplexArray;  // 双层数组
@property (nonatomic, assign) NSInteger sections;   // 组数
@property (nonatomic, copy) NSString * cellIdentifier;  // 复用标识
@property (nonatomic, copy) ListConfigureBlock aBlock;

@end


@implementation ListDataSource

- (id)initWithItems:(NSArray *)items cellIdentifier:(NSString *)aIdentifier configureBlock:(ListConfigureBlock)aBlock
{
    if (self = [super init]) {
        self.items = items;
        self.isComplexArray = NO;
        self.sections = 1;
        self.cellIdentifier = aIdentifier;
        self.aBlock = aBlock;
        
        if (items && items.count > 0 && [[items firstObject] isKindOfClass:NSArray.class]) {
            self.isComplexArray = YES;
            self.sections = items.count;
        }
    }
    return self;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    
    if (items && items.count > 0 && [[items firstObject] isKindOfClass:NSArray.class]) {
        self.isComplexArray = YES;
        self.sections = items.count;
    }
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    // 双层数组
    if (self.isComplexArray) {
        if (indexPath.section >= self.sections)
            return nil;
        
        if (indexPath.row >= [(NSArray *)_items[indexPath.section] count])
            return nil;
        
        return [(NSArray *)_items[indexPath.section] objectAtIndex:indexPath.row];
    }
    
    // 单层数组
    if (indexPath.row >= _items.count)
        return nil;
    
    return _items[indexPath.row];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.isComplexArray ? [_items[section] count] : _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                                             forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    
    // 向外传递 cell 和数据
    self.aBlock(cell, item, indexPath);
    
    return cell;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.isComplexArray ? [_items[section] count] : _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier
                                                                            forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    
    // 向外传递 cell 和数据
    self.aBlock(cell, item, indexPath);
    
    return cell;
}

@end
