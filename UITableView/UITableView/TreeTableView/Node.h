//  TreeTableVC 中 cell 的数据源
//
//  Node.h
//  UITableView
//
//  Created by CYKJ on 2019/10/25.
//  Copyright © 2019年 D. All rights reserved.


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Node : NSObject

@property (nonatomic, assign) NSInteger parentId; // 父节点 id
@property (nonatomic, assign) NSInteger nodeId;   // 自身 id
@property (nonatomic, copy) NSString * nodeName;  // 节点名称
@property (nonatomic, assign) NSInteger depth;  // 该节点的深度
@property (nonatomic, assign, getter=isOpen) BOOL open;  // 该节点是否是展开状态

/**
  *  @brief   初始化方法
  */
- (instancetype)initWithParentId:(NSInteger)parentId
                          nodeId:(NSInteger)nodeId
                        nodeName:(NSString *)nodeName
                           depth:(NSInteger)depth
                          isOpen:(BOOL)isOpen;

@end

NS_ASSUME_NONNULL_END
