//
//  KVO.h
//  Runtime
//
//  Created by CYKJ on 2019/6/22.
//  Copyright © 2019年 D. All rights reserved.


#import <Foundation/Foundation.h>

@interface KVO : NSObject

@property (nonatomic, copy) NSString * time;

- (void)cs_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;

@end
