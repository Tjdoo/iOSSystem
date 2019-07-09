//
//  ViewController.m
//  UICollectionView
//
//  Created by CYKJ on 2019/6/27.
//  Copyright © 2019年 D. All rights reserved.


#import "ViewController.h"
#import "MyCell.h"


@interface ViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView * collectionView;
@property (nonatomic, strong) NSNumberFormatter * formatter;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.formatter = [[NSNumberFormatter alloc] init];
    self.formatter.numberStyle = NSNumberFormatterSpellOutStyle;
    self.formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_Hans"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SUPPLE"];
    
    if (@available(iOS 9.0, *)) {
        // 吸顶效果，iOS 9.0 ~
        ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).sectionHeadersPinToVisibleBounds = YES;
    } else {
        // Fallback on earlier versions
    }

    // 处理闪烁问题
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self.collectionView reloadData];
    [CATransaction commit];
}


#pragma mark - UICollectionViewDelegate/DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_RUID
                                                              forIndexPath:indexPath];
    cell.label.text = [self.formatter stringFromNumber:@(indexPath.row)];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width / 3.0 - 0.5, 60);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SUPPLE" forIndexPath:indexPath];
        header.backgroundColor = [UIColor redColor];
        
        return header;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 50.0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SuctionTopVC_SBID"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
