//
//  NSMutableData+Extension.h
//  NSString
//
//  Created by CYKJ on 2019/10/29.
//  Copyright © 2019年 D. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableData (Extension)

- (void)appendString:(NSString *)string;     // use NSUTF8StringEncoding
- (void)appendString:(NSString *)string encoding:(NSStringEncoding)encoding;

@end

NS_ASSUME_NONNULL_END
