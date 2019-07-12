//
//  ViewController.m
//  NSNumberFormatter
//
//  Created by CYKJ on 2019/6/26.
//  Copyright © 2019年 D. All rights reserved.


#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSNumberFormatter * formatter;  // 阿拉伯数字转为汉字

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.formatter = [[NSNumberFormatter alloc] init];
    self.formatter.numberStyle = NSNumberFormatterSpellOutStyle;
    self.formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans"];

    for (NSInteger i = 0; i < 10; i++) {
        NSLog(@"%@", [self.formatter stringFromNumber:@(i + 1)]);
    }
}

@end
