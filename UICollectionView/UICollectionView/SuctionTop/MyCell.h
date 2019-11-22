//
//  MyCell.h
//  UICollectionView
//
//  Created by CYKJ on 2019/6/28.
//  Copyright © 2019年 D. All rights reserved.


#import <UIKit/UIKit.h>

static NSString * CELL_RUID = @"CELL";

@interface MyCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel * label;

@end
