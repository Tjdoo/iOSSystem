//
//  ScaleVC.m
//  UIImage
//
//  Created by CYKJ on 2019/12/23.
//  Copyright © 2019 D. All rights reserved.


#import "ScaleVC.h"
#import "ScaleTool.h"


@interface ScaleVC ()
@property (weak, nonatomic) IBOutlet UIImageView * imageView1;
@property (weak, nonatomic) IBOutlet UIImageView * imageView2;
@property (weak, nonatomic) IBOutlet UIImageView * imageView3;
@property (weak, nonatomic) IBOutlet UIImageView * imageView4;
@end


@implementation ScaleVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage * image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image"
                                                                                       ofType:@"jpg"]];
    CGFloat ratio = 100.0/3600;
    self.imageView1.image = [ScaleTool doScale1:image ratio:ratio];
    self.imageView2.image = [ScaleTool doScale2:image ratio:ratio];
    self.imageView3.image = [ScaleTool doScaleWithImagePath3:[[NSBundle mainBundle] pathForResource:@"image" ofType:@"jpg"] ratio:100.0/3600];//[ScaleTool doScale3:image ratio:ratio];
    self.imageView4.image = [ScaleTool doScale4:image ratio:ratio];
}

@end
