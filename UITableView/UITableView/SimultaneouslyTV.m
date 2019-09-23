//
//  SimultaneouslyTV.m
//  UITableView
//
//  Created by CYKJ on 2019/8/21.
//  Copyright © 2019年 D. All rights reserved.


#import "SimultaneouslyTV.h"

@implementation SimultaneouslyTV

/**
  *  @brief   同时识别多个手势
  */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
