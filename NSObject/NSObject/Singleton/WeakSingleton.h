//
//  WeakSingleton.h
//  NSObject
//
//  Created by CYKJ on 2019/11/19.
//  Copyright © 2019年 D. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeakSingleton : NSObject <NSCopying>

+ (instancetype)sharedInstance;

@end
