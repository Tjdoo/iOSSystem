//
//  UILabel+HTML.h
//  UILabel
//
//  Created by CYKJ on 2019/6/19.
//  Copyright © 2019年 D. All rights reserved.


#import <UIKit/UIKit.h>


@interface UILabelHTMLStringAttribute : NSObject

@property (nonatomic, assign) CGFloat lineSpacing;  // 行间距
@property (nonatomic, strong) UIColor * textColor;  // 文字颜色
@property (nonatomic, strong) UIFont * textFont;    // 字体大小
@property (nonatomic, assign) NSUInteger maxNumberOfLines;  // 最大行数，如果值 > 0，即表明希望最多显示 maxNumberOfLines 行。如果文本实际行数小于 maxNumberOfLines，则 label.numberOfLines = 0。

@end



@interface UILabel (HTML)

/**
 *  @brief   设置文本框内容
 */
- (void)setAttributedStringWithHTML:(NSString *)htmlString
                          attribute:(UILabelHTMLStringAttribute *)attribute;


/**
 *  @brief   HTML 字符串 ---》 NSMutableAttributedString，并返回
 */
+ (NSMutableAttributedString *)getAttributedStringFromHTML:(NSString *)htmlString;


/**
 *  @brief   Attributed 字符串设置属性
 *  @param   completion    由于文本框设置内容需要在处理 maxNumberOfLines 之前，所以提供此 block
 */
- (void)handleAttributedString:(NSMutableAttributedString *)maString
                withAttributes:(UILabelHTMLStringAttribute *)attribute
                    completion:(void (^)(NSMutableAttributedString * attributedStr))completion;


+ (CGFloat)calculateTextHeight:(NSString *)text
                         width:(CGFloat)width
                          font:(UIFont *)font;

- (CGFloat)calculateSelfHeightMaxWidth:(CGFloat)width;

@end
