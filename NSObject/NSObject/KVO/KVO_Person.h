//
//  KVO_Person.h
//  NSObject
//
//  Created by CYKJ on 2019/11/18.
//  Copyright © 2019年 D. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dog.h"

NS_ASSUME_NONNULL_BEGIN

@interface KVO_Person : NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * age;
@property (nonatomic, strong) Dog * dog;
@property (nonatomic, copy) NSArray * students;

@end

NS_ASSUME_NONNULL_END
