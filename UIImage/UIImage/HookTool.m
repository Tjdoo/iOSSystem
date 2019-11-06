//
//  HookTool.m
//
//  Created by D on 2018/8/21.
//  Copyright © 2018年 D. All rights reserved.


#import "HookTool.h"
#import <objc/runtime.h>


/*
 正常状态前景图片：
        UIResourceName, Like
        UIImage, <UIImage: 0x6000000945a0>, {18, 18}
 
 正常状态背景图片：
        UIResourceName, Play
        UIBackgroundImage, <UIImage: 0x6000000947d0>, {44, 44}
 
  高亮状态前景图片：
        UIResourceName, LikeS
        UIImage, <UIImage: 0x6080000955e0>, {22, 22}
 
  高亮状态背景图片
        UIResourceName, Load
        UIBackgroundImage, <UIImage: 0x600000094960>, {20, 20}
 
                。。。
 
    经过打印显示，所有状态的图片名称  key 值都是 UIResourceName，输出顺序为：normal -》highlighted -》selected -》disabled
 
    在另一个 UIButtonStatefulContent 字段中不同状态的 key 值：0 - normal；1 - highlighted；2- disabled；4 - selected
 
    UIButtonStatefulContent, {
         0 = "<UIButtonContent: 0x608000095400 Title = Button, AttributedTitle = (null), Image = <UIImage: 0x6000000945a0>, {18, 18}, Background = <UIImage: 0x6000000947d0>, {44, 44}, TitleColor = (null), ImageColor = (null), ShadowColor = (null), DrawingStroke = (null)>";
         1 = "<UIButtonContent: 0x600000094820 Title = (null), AttributedTitle = (null), Image = <UIImage: 0x6080000955e0>, {22, 22}, Background = <UIImage: 0x600000094960>, {20, 20}, TitleColor = (null), ImageColor = (null), ShadowColor = (null), DrawingStroke = (null)>";
         4 = "<UIButtonContent: 0x6000000949b0 Title = (null), AttributedTitle = (null), Image = <UIImage: 0x600000094aa0>, {22, 22}, Background = <UIImage: 0x600000094b90>, {22, 22}, TitleColor = (null), ImageColor = (null), ShadowColor = (null), DrawingStroke = (null)>";
    }
 */
typedef NS_ENUM(NSInteger, ButtonImageOrder) {
    ButtonImageOrder_Normal = 0,
    ButtonImageOrder_Highlighted = 1,
    ButtonImageOrder_Selected = 4,
    ButtonImageOrder_Disabled = 2
};


NSMutableArray * _imageViewImageArray;  // 保存（UIImageView、UIButton）图片名称的数组
NSDictionary * _buttonImageDictionary;  // 为了记录 UIButton 的哪些状态设置了图片


static NSString * propKey = nil;
static NSString * btnKey  = nil;




@implementation HookTool

+ (void)load
{
    _imageViewImageArray = [NSMutableArray arrayWithCapacity:2];
    
    propKey = [self stringByReversed:@"emaNecruoseRIU"];
    btnKey = [self stringByReversed:@"tnetnoClufetatSnottuBIU"];
    
    // hook UINibDecoder      - decodeObjectForKey:
    NSString* clsName = [NSString stringWithFormat:@"redoce%@biNIU", @"D"];
    clsName = [self stringByReversed:clsName];
    
    [HookTool exchangeInstanceMethod:NSClassFromString(clsName)
                         originalSEL:@selector(decodeObjectForKey:)
                         swizzledSEL:@selector(swizzle_decodeObjectForKey:)];

    // hook UIImageView        - initWithCoder:
    [HookTool exchangeInstanceMethod:UIImageView.class
                         originalSEL:@selector(initWithCoder:)
                         swizzledSEL:@selector(swizzle_imageView_initWithCoder:)];
    
    // hook UIButton        - initWithCoder:
    [HookTool exchangeInstanceMethod:UIButton.class
                         originalSEL:@selector(initWithCoder:)
                         swizzledSEL:@selector(swizzle_button_initWithCoder:)];
}

- (id)swizzle_decodeObjectForKey:(NSString *)key
{
    Method originalMethod = class_getInstanceMethod([HookTool class], @selector(swizzle_decodeObjectForKey:));
    IMP function = method_getImplementation(originalMethod);
    id (*functionPoint)(id, SEL, id) = (id (*)(id, SEL, id)) function;
    id value = functionPoint(self, _cmd, key);
    
    // 保存图片名称
    if ([key isEqualToString:propKey]) {
        [_imageViewImageArray addObject:value];
    }
    
    // 保存 button 状态数据
    if ([key isEqualToString:btnKey]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            _buttonImageDictionary = value;
        }
    }
    
    return value;
}


#pragma mark - UIImageView

- (id)swizzle_imageView_initWithCoder:(NSCoder *)aDecoder
{
    // 执行顺序：initWithCoder -》DecoderWithKey -》setImage：，所以每次给 imageView 设置图片时，需要将之前的置空。
    // tabbarItem 的图片设置不会执行 initWithCoder，如果不置空，会导致 imageView 设置成和 tabbarItem 一样的图片。
    [_imageViewImageArray removeAllObjects];

    UIImageView * instance = (UIImageView *)[self swizzle_imageView_initWithCoder:aDecoder];

    // 设置 image
    if (_imageViewImageArray.count > 0) {
        UIImage * normalImage = [HookTool imageAfterSearch:_imageViewImageArray[0]];
        if (normalImage) {
            instance.image = normalImage;
        }
    }
    // 设置 highlightedImage
    if (_imageViewImageArray.count > 1) {
        UIImage * highlightedImage = [HookTool imageAfterSearch:_imageViewImageArray[1]];
        if (highlightedImage) {
            instance.highlightedImage = highlightedImage;
        }
    }
    
    return instance;
}


#pragma mark - UIButton

- (id)swizzle_button_initWithCoder:(NSCoder *)aDecoder
{
    // 执行顺序：initWithCoder -》DecoderWithKey -》setImage：，所以每次给 button 设置图片时，需要将之前的置空。
    // tabbarItem 的图片设置不会执行 initWithCoder，如果不置空，会导致 button 设置成和 tabbarItem 一样的图片。
    [_imageViewImageArray removeAllObjects];
    _buttonImageDictionary = nil;
    
    UIButton * instance = (UIButton *)[self swizzle_button_initWithCoder:aDecoder];
    
    @autoreleasepool {
        [_buttonImageDictionary enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key,
                                                                    id  _Nonnull obj,
                                                                    BOOL * _Nonnull stop) {
            
            if (_imageViewImageArray.count == 0) {
                *stop = YES;
            }
            else {
                switch ([key integerValue]) {
                    case ButtonImageOrder_Normal:
                        [HookTool setImageForButton:instance object:obj state:UIControlStateNormal];
                        break;
                    case ButtonImageOrder_Highlighted:
                        [HookTool setImageForButton:instance object:obj state:UIControlStateHighlighted];
                        break;
                    case ButtonImageOrder_Selected:
                        [HookTool setImageForButton:instance object:obj state:UIControlStateSelected];
                        break;
                    case ButtonImageOrder_Disabled:
                        [HookTool setImageForButton:instance object:obj state:UIControlStateDisabled];
                        break;
                }
            }
        }];
    }

    return instance;
}

+ (void)setImageForButton:(UIButton *)button object:(id)obj state:(UIControlState)state
{
    // 防止 image、background 在私有类中被更改后 unFound
    @try {
        // 前景图片
        if ([obj valueForKey:@"image"]) {
            UIImage * image = [HookTool imageAfterSearch:_imageViewImageArray.firstObject];
            [button setImage:image forState:state];
            [_imageViewImageArray removeObjectAtIndex:0];
        }
        
        if (_imageViewImageArray.count == 0)
            return;
        
        // 背景图
        if ([obj valueForKey:@"background"]) {
            UIImage * backgroundImage = [HookTool imageAfterSearch:_imageViewImageArray.firstObject];
            [button setBackgroundImage:backgroundImage forState:state];
            [_imageViewImageArray removeObjectAtIndex:0];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally { }
}


#pragma mark - Tool
/**
  *  @brief   替换方法实现
  */
+ (void)exchangeInstanceMethod:(Class)otherClass originalSEL:(SEL)originalSEL swizzledSEL:(SEL)swizzledSEL
{
    Method originalMethod = class_getInstanceMethod(otherClass, originalSEL);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSEL);
    
    // otherClass 添加替换后的 SEL，避免 unrecognizeSelectorSentToInstance 错误
    class_addMethod( otherClass,
                    swizzledSEL,
                    method_getImplementation(originalMethod),
                    method_getTypeEncoding(originalMethod));
    // 替换 otherClass 类的旧方法实现
    BOOL c = class_addMethod( otherClass,
                             originalSEL,
                             method_getImplementation(swizzledMethod),
                             method_getTypeEncoding(swizzledMethod));
    
    if (!c) {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

/**
  *  @brief   获取查找后的图片
  */
+ (UIImage *)imageAfterSearch:(NSString *)imageName
{
    // 去 xx 模块找
    UIImage * resultImage = nil;
    
    // 去 main 找
    if (!resultImage) {
        resultImage = [UIImage imageNamed:imageName];
    }
    
    return resultImage;
}

/**
  *  @brief   翻转字符串
  */
+ (NSString *)stringByReversed:(NSString*)origStr
{
    NSMutableString *s = [NSMutableString string];
    for (NSUInteger i=origStr.length; i>0; i--) {
        [s appendString:[origStr substringWithRange:NSMakeRange(i-1, 1)]];
    }
    return s;
}

@end
