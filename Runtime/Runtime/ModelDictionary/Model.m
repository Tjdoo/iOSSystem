//
//  Model.m
//  Runtime
//
//  Created by CYKJ on 2019/6/22.
//  Copyright © 2019年 D. All rights reserved.


#import "Model.h"
#import <objc/message.h>


@implementation Model
/**
  *  @discussion  字典：key - value       Model 赋值是调用 set 方法
  */
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        for (NSString * key in dict.allKeys) {
            SEL sel = NSSelectorFromString([NSString stringWithFormat:@"set%@:", key.capitalizedString]);
            
            // 此处未考虑基础类型数值、复杂结构类型
            if (sel) {
                ((void (*)(id, SEL, id))objc_msgSend)(self, sel, dict[key]);
            }
        }
    }
    return self;
}

/**
  *  @discussion   key ：class_copyPropertyList()         value ： get 方法（objc_msgSend）
  */
- (NSDictionary *)convertModelToDictionary
{
    unsigned int count = 0;
    objc_property_t * properties = class_copyPropertyList(Model.class, &count);
    
    if (count > 0) {
        NSMutableDictionary * mDict = [NSMutableDictionary dictionaryWithCapacity:1];
        
        for (NSInteger i = 0; i < count; i++) {
            NSString * key = [NSString stringWithUTF8String:property_getName(properties[i])];
            SEL sel = NSSelectorFromString(key);
            
            if (sel) {
                id value = ((id (*)(id, SEL))objc_msgSend)(self, sel);
                mDict[key] = value;
            }
        }
        free(properties);
        return mDict;
    }
    free(properties);
    
    return nil;
}

@end
