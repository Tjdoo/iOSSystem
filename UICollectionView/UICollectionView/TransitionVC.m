//
//  TransitionVC.m
//  UICollectionView
//
//  Created by CYKJ on 2019/11/25.
//  Copyright © 2019年 D. All rights reserved.


#import "TransitionVC.h"

@interface TransitionVC () <UICollectionViewDelegateFlowLayout>

@end


@implementation TransitionVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.title = [NSString stringWithFormat:@"%lu", (unsigned long)self.navigationController.viewControllers.count - 1];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.cellCount <= 0) {
        self.cellCount = 10;
    }
    return self.cellCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.backgroundColor = [UIColor redColor];
    }
    else {
        cell.backgroundColor = [UIColor orangeColor];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.itemWidth <= 0) {
        self.itemWidth = 50;
    }
    return CGSizeMake(self.itemWidth, self.itemWidth);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 0, 10);
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TransitionVC * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TransitionVC_SBID"];
    vc.itemWidth = (indexPath.item + 1) * 10;
    vc.cellCount = arc4random() % 10 + 5;
    vc.useLayoutToLayoutNavigationTransitions = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
