//
//  ListDataSourceCell.m
//  UITableView
//
//  Created by CYKJ on 2019/6/18.
//  Copyright © 2019年 D. All rights reserved.


#import "ListDataSourceCell.h"

@interface ListDataSourceCell ()

@property (weak, nonatomic) IBOutlet UIImageView * iconImageView;
@property (weak, nonatomic) IBOutlet UILabel * cellTitleLabel;

@end


@implementation ListDataSourceCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setData:(NSString *)text
{
    self.iconImageView.image = [UIImage imageNamed:text];
    self.cellTitleLabel.text = text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
