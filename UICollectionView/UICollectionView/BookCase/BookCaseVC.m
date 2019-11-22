//
//  BookCaseVC.m
//  UICollectionView
//
//  Created by CYKJ on 2019/11/21.
//  Copyright © 2019年 D. All rights reserved.


#import "BookCaseVC.h"
#import "BookCaseCVCell.h"


@interface BookCaseVC () <UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView * collectionView;

@end


@implementation BookCaseVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Bg"]];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookCaseCVCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:BOOKCASE_CVCELL_RUID
                                                                      forIndexPath:indexPath];
    return cell;
}

@end
