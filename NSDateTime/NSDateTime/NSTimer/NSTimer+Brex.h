//
//  NSTimer+Brex.h
//  Date&Time
//
//  Created by CYKJ on 2019/5/21.
//  Copyright © 2019年 D. All rights reserved.


#import <Foundation/Foundation.h>

/*
    RunLoop -》 NSTimer -》target（self）-》 NSTimer，这样就造成了一个循环引用。虽然系统提供了一个 invalidate 方法来把 NSTimer 从 RunLoop中释放掉并取消强引用，但是往往找不到合适的位置。
 
    解决这个问题的思路很简单，初始化 NSTimer 时把触发事件的 target 替换成一个单独的对象，然后这个对象中 NSTimer 的 SEL 方法触发时让这个方法在当前的视图 self 中实现。
    利用 runtime 在 target 对象中动态的创建 SEL 方法，然后 target 对象关联当前的视图 self，当 target 对象执行 SEL 方法时，取出关联对象 self，然后让 self 执行该方法。
   */
@interface NSTimer (Brex)

/**
  *  @brief   创建一个不会造成循环引用的循环执行的 timer
  */
+ (instancetype)brexScheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                            target:(id)aTarget
                                          selector:(SEL)aSelector
                                          userInfo:(id)userInfo;

@end
