//
//  Timer.h
//  Date&Time
//
//  Created by CYKJ on 2019/5/21.
//  Copyright © 2019年 D. All rights reserved.


#import <Foundation/Foundation.h>

/**
  *  @brief  倒计时。http://www.cocoachina.com/ios/20180911/24870.html
  */
@interface Timer : NSObject

- (void)performAfterDelay;

- (void)nsTimer;

- (void)caDisplayLink;

- (void)gcd;

@end
