//
//  ListDataSourceCell.h
//  UITableView
//
//  Created by CYKJ on 2019/6/18.
//  Copyright © 2019年 D. All rights reserved.


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * CELL_RUID = @"ListDataSourceCell";

@interface ListDataSourceCell : UITableViewCell

- (void)setData:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
