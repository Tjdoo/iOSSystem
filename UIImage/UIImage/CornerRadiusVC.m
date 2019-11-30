//
//  CornerRadiusVC.m
//  UIImage
//
//  Created by CYKJ on 2019/11/27.
//  Copyright © 2019年 D. All rights reserved.


#import "CornerRadiusVC.h"
#import "UIImage+CornerRadius.h"

@interface CornerRadiusVC ()

@property (weak, nonatomic) IBOutlet UIImageView * originImageView;
@property (weak, nonatomic) IBOutlet UIImageView * cgContextImageView;
@property (weak, nonatomic) IBOutlet UIImageView * bezierPathImageView;
@property (weak, nonatomic) IBOutlet UIImageView * customImageView;
@property (nonatomic, strong) dispatch_queue_t queue;

@end


@implementation CornerRadiusVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    
    UIImage * img = [UIImage imageNamed:@"Corner"];
    
    self.originImageView.image = img;
    self.cgContextImageView.image = [img cgContextMakeCornerRadius:100];
    self.bezierPathImageView.image = [img bezierPathMakeCornerRadius:100];
    self.customImageView.image = [img customMakeCornerRadius:100];
    
}

static int count = 1000;

// 自定义裁剪方式：内存从 14.4 MB 开始，峰值 15.4 MB，CPU 峰值 85%
- (IBAction)doCustomClip:(id)sender
{
    dispatch_async(self.queue, ^{
        UIImage * img = [UIImage imageNamed:@"Corner"];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [sender setTitle:@"正在裁剪..." forState:UIControlStateNormal];
        });

        NSLog(@"-------Begin Custom Clip-------");
        //        time_t time1 = clock();
        NSTimeInterval t1 = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            [img customMakeCornerRadius:100];
        }
        //        time_t time2 = clock();
        NSTimeInterval t2 = CACurrentMediaTime();
        NSLog(@"-------Custom Clip = %.3fs", t2 - t1);
        //        NSLog(@"-------Custom Clip：%.3fs", ((float)(time2 - time1)) / CLOCKS_PER_SEC);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [sender setTitle:[NSString stringWithFormat:@"裁剪结束，耗时：%.3fs", t2 - t1]
                    forState:UIControlStateNormal];
        });
    });
}

// CGContext 裁剪方式：内存从 14.3 MB 开始，峰值 17.0 MB，CPU 峰值 90%
- (IBAction)cgContextClip:(id)sender
{
    dispatch_async(self.queue, ^{

        UIImage * img = [UIImage imageNamed:@"Corner"];

        dispatch_sync(dispatch_get_main_queue(), ^{
            [sender setTitle:@"正在裁剪..." forState:UIControlStateNormal];
        });
        
        NSLog(@"-------Begin CGContext Clip-------");
        NSTimeInterval t1 = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            [img cgContextMakeCornerRadius:100];
        }
        NSTimeInterval t2 = CACurrentMediaTime();
        NSLog(@"-------CGContext Clip = %.3fs", t2 - t1);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [sender setTitle:[NSString stringWithFormat:@"裁剪结束，耗时：%.3fs", t2 - t1]
                    forState:UIControlStateNormal];
        });
    });
}

// CGContext 裁剪方式：内存从 14.3 MB 开始，峰值 16.7 MB，CPU 峰值 90%
- (IBAction)bezierPathClip:(id)sender
{
    dispatch_async(self.queue, ^{

        UIImage * img = [UIImage imageNamed:@"Corner"];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [sender setTitle:@"正在裁剪..." forState:UIControlStateNormal];
        });
        
        NSLog(@"-------Begin UIBezierPath Clip-------");
        NSTimeInterval t1 = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            [img bezierPathMakeCornerRadius:100];
        }
        NSTimeInterval t2 = CACurrentMediaTime();
        NSLog(@"-------UIBezierPath Clip = %.3fs", t2 - t1);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [sender setTitle:[NSString stringWithFormat:@"裁剪结束，耗时：%.3fs", t2 - t1]
                    forState:UIControlStateNormal];
        });
    });
}

@end
