//
//  DecorationReusableView.m
//  UICollectionView
//
//  Created by CYKJ on 2019/11/21.
//  Copyright © 2019年 D. All rights reserved.


#import "DecorationReusableView.h"

@implementation DecorationReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView * iv = [[UIImageView alloc] initWithFrame:frame];
        iv.image = [UIImage imageNamed:@"BookCase"];
        [self addSubview:iv];
    }
    return self;
}

@end
