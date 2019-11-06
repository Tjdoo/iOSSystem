//
//  Copy_Custom.h
//  NSObject
//
//  Created by CYKJ on 2019/11/4.
//  Copyright © 2019年 D. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Copy_Custom : NSObject <NSCopying, NSMutableCopying>

@property (nonatomic, copy) NSString * aa;

@end

NS_ASSUME_NONNULL_END
