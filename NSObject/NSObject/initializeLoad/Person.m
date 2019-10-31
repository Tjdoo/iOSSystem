//
//  Person.m
//  NSObject
//
//  Created by CYKJ on 2019/10/25.
//  Copyright © 2019年 D. All rights reserved.


#import "Person.h"

@interface Person ()
{
    NSString * __c;
}
@property (nonatomic, copy) NSString * d;
@end


@implementation Person
{
    @private
        NSString * __e;
    @public
        NSString * __f;
}

+ (instancetype)alloc
{
    NSLog(@"%s", __func__);
    return [super alloc];
}

+ (void)initialize
{
    NSLog(@"%s", __func__);
    
}

- (instancetype)init
{
    NSLog(@"%s", __func__);
    return [super init];
}

- (void)sayHello
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
