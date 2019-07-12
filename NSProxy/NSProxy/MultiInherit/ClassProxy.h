//
//  ClassProxy.h
//  NSProxy
//
//  Created by CYKJ on 2019/7/12.
//  Copyright © 2019年 D. All rights reserved.


#import <Foundation/Foundation.h>


/**
 *  @brief   NSProxy 用于实现“多继承”。

    大致过程就是让它持有要实现多继承的类的对象，然后用多个接口定义不同的行为，并让 Proxy 去实现这些接口，然后在转发的时候把消息转发到实现了该接口的对象去执行，这样就好像实现了多重继承一样。注意：这个真不是多重继承，只是包含，然后把消息路由到指定的对象而已，其实完全可以用 NSObject 类来实现。
 
    NSObject 寻找方法顺序：本类 -> 父类 -> 动态方法解析 -> 备用对象 -> 消息转发；
    NSproxy  寻找方法顺序：本类 -> 消息转发；
 
    同样做“消息转发”，NSObject 会比 NSProxy 多做好多事，也就意味着耽误很多时间。
  */
@interface ClassProxy : NSProxy

@property (nonatomic, strong, readonly) NSMutableArray * targetArray;  // target 数组
/**
  *  @brief  传入单个 target
  */
- (void)target:(id)target;
/**
  *  @brief  传入 target 数组
  */
- (void)handleTargets:(NSArray *)targets;

@end
