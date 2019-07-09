//
//  UILabel+HTML.m
//  UILabel
//
//  Created by CYKJ on 2019/6/19.
//  Copyright © 2019年 D. All rights reserved.


#import "UILabel+HTML.h"


@implementation UILabelHTMLStringAttribute

- (instancetype)init
{
    if (self = [super init]) {
        self.lineSpacing = 4;
        self.textColor   = [UIColor blackColor];
        self.textFont    = [UIFont systemFontOfSize:14];
        self.maxNumberOfLines = 0;
    }
    return self;
}

@end



@implementation UILabel (HTML)

- (void)setAttributedStringWithHTML:(NSString *)htmlString attribute:(UILabelHTMLStringAttribute *)attribute
{
    NSMutableAttributedString * maString = [UILabel getAttributedStringFromHTML:htmlString];
    
    if (maString && maString.length > 0) {
        
        __weak UILabel * weakSelf = self;
        
        [self handleAttributedString:maString withAttributes:attribute completion:^(NSMutableAttributedString * attributedStr) {
            
            weakSelf.attributedText = attributedStr;
        }];
    }
}

/**
 *  @brief   HTML 字符串 ---》 NSMutableAttributedString
 */
+ (NSMutableAttributedString *)getAttributedStringFromHTML:(NSString *)htmlString
{
    NSData * htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    if (htmlData) {
        
        __block NSMutableAttributedString * maString = nil;
        
        dispatch_block_t block = ^{
            
            NSDictionary * options = @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                        NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
            
            maString = [[NSMutableAttributedString alloc] initWithData:htmlData
                                                               options:options
                                                    documentAttributes:nil
                                                                 error:NULL];
        };
        
        if ([NSThread isMainThread]) {
            block();
        }else{
            dispatch_sync(dispatch_get_main_queue(), block);
        }
        
        return maString;
    }
    return nil;
}

/**
 *  @brief   Attributed 字符串设置属性
 */
- (void)handleAttributedString:(NSMutableAttributedString *)maString withAttributes:(UILabelHTMLStringAttribute *)attribute completion:(void (^)(NSMutableAttributedString *))completion
{
    if (maString || maString.length > 0) {
        
        if (attribute) {
            // 需要再次设置字体大小、间隔、文本颜色等属性
            NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
            style.lineSpacing = attribute.lineSpacing;
            
            [maString addAttributes:@{ NSParagraphStyleAttributeName : style,
                                       NSForegroundColorAttributeName : attribute.textColor,
                                       NSFontAttributeName : attribute.textFont }
             
                              range:NSMakeRange(0, maString.length)];
        }
        
        // 一般用于文本框设置内容
        if (completion) {   completion( maString );   }
        
        if (attribute && attribute.maxNumberOfLines > 0) {
            
            // 行宽
            CGFloat lineW  = CGRectGetWidth(self.bounds);
            // 行高
            CGFloat lineH = attribute.textFont.lineHeight;
            // 文本高度
            CGFloat textH = [UILabel calculateTextHeight:maString.string width:lineW font:attribute.textFont];
            
            if (textH >= attribute.maxNumberOfLines * lineH) {
                
                self.numberOfLines = attribute.maxNumberOfLines;
                self.lineBreakMode = NSLineBreakByTruncatingTail;
            }
            else {
                self.numberOfLines = 0;
            }
        }
    }
}

/**
 *  @brief   计算文本高度
 */
+ (CGFloat)calculateTextHeight:(NSString *)text width:(CGFloat)width font:(UIFont *)font
{
    return [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                              options: NSStringDrawingUsesFontLeading |
            NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{ NSFontAttributeName : font}
                              context:nil].size.height;
}

- (CGFloat)calculateSelfHeightMaxWidth:(CGFloat)width
{
    return [self.attributedText.string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                    options: NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{ NSFontAttributeName : self.font}
                                                    context:nil].size.height;
}

@end
