//
//  EvenDistributionLabel.m
//  UILabel
//
//  Created by CYKJ on 2019/6/25.
//  Copyright © 2019年 D. All rights reserved.


#import "EvenDistributionLabel.h"
#import <CoreText/CoreText.h>


@implementation EvenDistributionLabel

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setText:(NSString *)text
{
    self.attributedText = [[NSAttributedString alloc] initWithString:text];
    
    [super setText:text];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesFontLeading
                                       attributes:@{ NSFontAttributeName : self.font}
                                          context:nil];
    CGFloat margin = (CGRectGetWidth(self.frame) - rect.size.width) / (attributedText.length - 1);
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    // 设置间隔
    [attributedString addAttribute:(id)kCTKernAttributeName
                             value:@(margin)
                             range:NSMakeRange(0, attributedString.length - 1)];
    
    [super setAttributedText:attributedString];
}

@end
