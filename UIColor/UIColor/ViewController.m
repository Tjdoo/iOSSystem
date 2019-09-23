//
//  ViewController.m
//  UIColor
//
//  Created by CYKJ on 2019/8/21.
//  Copyright © 2019年 D. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

/**
 有效位数为6、8的十六进制颜色值转为UIColor对象，如(oxff297000有效位数为8，ox为16进制标识)
 */
+ (UIColor *) colorWithHexString: (NSString *)color
{
    //去除空格和换行符，并将字母大写
    NSString * cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    //去除最前端的16进制标识
    if ([cString hasPrefix:@"OX"] || [cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    
    if (cString.length != 6 && cString.length != 8) {
        return [UIColor clearColor];
    }
    
    NSRange range;
    range.length = 2;
    
    CGFloat location = 0;
    
    //长度为8时，包含透明度
    NSString * aString = @"";
    if(cString.length == 8){
        //A
        range.location = location;
        location += 2;
        aString = [cString substringWithRange:range];
    }
    
    //R
    range.location = location;
    location += 2;
    NSString *rString = [cString substringWithRange:range];
    
    //G
    range.location = location;
    location += 2;
    NSString *gString = [cString substringWithRange:range];
    
    //B
    range.location = location;
    location += 2;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b, a;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    if(cString.length == 8){
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
    }else{
        a = 255.0;
    }
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:((float) a / 255.0f)];
}

@end
