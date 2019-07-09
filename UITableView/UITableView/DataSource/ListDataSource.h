//
//  ListDataSource.h
//  UITableView
//
//  Created by CYKJ on 2019/6/18.
//  Copyright © 2019年 D. All rights reserved.


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
  *  @brief   调用 tableView:cellForRowAtIndexPath:  方法时，向外传递 cell、model、indexPath
  */
typedef void(^ ListConfigureBlock) (id cell, id item, NSIndexPath * indexPath);



/**
  *  @brief   遵守 UITableView、UICollectionView 的 dataSource 协议，处理数据的传递，简化 viewController 中的代码。
  *
  *  @note   当前不能处理多种类型 cell 的使用
  */
@interface ListDataSource : NSObject <UITableViewDataSource, UICollectionViewDataSource>

@property (nonatomic, copy) NSArray * items;
/**
  * @brief   初始化、传值
  */
- (id)initWithItems:(NSArray * _Nullable)items
     cellIdentifier:(NSString *)aIdentifier
     configureBlock:(ListConfigureBlock)aBlock;

/**
  *  @brief   返回 indexPath 位置对应的数据
  */
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

+ (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
