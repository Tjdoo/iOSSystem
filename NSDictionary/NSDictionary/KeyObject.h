//
//  KeyObject.h
//  NSDictionary
//
//  Created by CYKJ on 2019/10/30.
//  Copyright © 2019年 D. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyObject : NSObject <NSCopying>

- (instancetype)initWithHashNum:(NSUInteger)num;

@end

NS_ASSUME_NONNULL_END
