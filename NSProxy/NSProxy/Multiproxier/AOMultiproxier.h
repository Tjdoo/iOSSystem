//
//  AOMultiproxier.h
//  Pods
//
//  Created by Alessandro Orrù on 21/01/15.


#import <Foundation/Foundation.h>

#define AOMultiproxierForProtocol(__protocol__, ...) ((AOMultiproxier <__protocol__> *)[AOMultiproxier multiproxierForProtocol:@protocol(__protocol__) withObjects:((NSArray *)[NSArray arrayWithObjects:__VA_ARGS__,nil])])

/**
  *  @see   https://github.com/alessandroorru/AOMultiproxier
  */
@interface AOMultiproxier : NSProxy

@property (nonatomic, strong, readonly) Protocol * protocol;  // 协议
@property (nonatomic, strong, readonly) NSArray * attachedObjects;  // 遵守协议的对象数组

+ (instancetype)multiproxierForProtocol:(Protocol *)protocol
                            withObjects:(NSArray *)objects;
@end
