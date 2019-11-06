//
//  ViewController.m
//  UILabel
//
//  Created by CYKJ on 2019/6/19.
//  Copyright © 2019年 D. All rights reserved.
//

#import "ViewController.h"
#import "EvenDistributionLabel.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet EvenDistributionLabel * label;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.label.text = @"中华人民共和国";
}

@end
