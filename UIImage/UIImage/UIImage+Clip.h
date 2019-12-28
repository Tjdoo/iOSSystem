//
//  UIImage+Clip.h
//  CiYunApp
//
//  Created by CYKJ on 2019/4/9.
//  Copyright © 2019年 . All rights reserved.


#import <UIKit/UIKit.h>

@interface UIImage (Clip)

- (UIImage *)clipImage:(CGSize)size;

- (UIImage *)cgFixOrientation;
- (UIImage *)uiFixOrientation;

@end
