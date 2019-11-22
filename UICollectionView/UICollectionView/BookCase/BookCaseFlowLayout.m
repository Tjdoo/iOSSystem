//
//  BookCaseFlowLayout.m
//  UICollectionView
//
//  Created by CYKJ on 2019/11/21.
//  Copyright © 2019年 D. All rights reserved.


#import "BookCaseFlowLayout.h"
#import "DecorationReusableView.h"

#define CELL_COUNT  3  // 单行 cell 的数量
#define CELL_MARGIN 20
#define CELL_SPACE  17.5
#define CELL_WIDTH  (([UIScreen mainScreen].bounds.size.width - CELL_MARGIN * 2 - CELL_SPACE * (CELL_COUNT - 1)) / CELL_COUNT)

@implementation BookCaseFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    // 注册装饰视图
    [self registerClass:DecorationReusableView.class forDecorationViewOfKind:@"decoration"];
}

/**
  *  @brief   修改 cell 的位置
  */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGRect rect = CGRectMake(CELL_MARGIN + indexPath.item * (CELL_WIDTH + CELL_SPACE),
                             45 + indexPath.section * (146 + 65),
                             CELL_WIDTH,
                             146);
    attributes.frame = rect;
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind
                                                                  atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
    attributes.frame = CGRectMake(0,
                                  (216 * indexPath.section) / 2,
                                  UIScreen.mainScreen.bounds.size.width,
                                  216);
    attributes.zIndex = -1; // 放到底层
    
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray * attributes = [NSMutableArray array];
    
    //把 Decoration View 的布局加入可见区域布局。
    for (int y = 0; y < 3; y++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:3 inSection:y];
        [attributes addObject:[self layoutAttributesForDecorationViewOfKind:@"decoration"
                                                                atIndexPath:indexPath]];
    }
    
    for (NSInteger i = 0 ; i < 3; i++) {
        for (NSInteger t = 0; t < 3; t++) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:t inSection:i];
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    
    return attributes;
}

@end
