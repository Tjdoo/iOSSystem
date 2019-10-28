//
//  Node.m
//  UITableView
//
//  Created by CYKJ on 2019/10/25.
//  Copyright © 2019年 D. All rights reserved.


#import "Node.h"

@implementation Node

- (instancetype)initWithParentId:(NSInteger)parentId
                          nodeId:(NSInteger)nodeId
                        nodeName:(NSString *)nodeName
                           depth:(NSInteger)depth
                          isOpen:(BOOL)isOpen
{
    if (self = [super init]) {
        self.parentId = parentId;
        self.nodeId = nodeId;
        self.nodeName = nodeName;
        self.depth = depth;
        self.open = isOpen;
    }
    return self;
}

@end
