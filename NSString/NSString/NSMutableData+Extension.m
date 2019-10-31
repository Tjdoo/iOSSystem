//
//  NSMutableData+Extension.m
//  NSString
//
//  Created by CYKJ on 2019/10/29.
//  Copyright © 2019年 D. All rights reserved.
//

#import "NSMutableData+Extension.h"

@implementation NSMutableData (Extension)

- (void)appendString:(NSString *)string
{
    [self appendString:string encoding:NSUTF8StringEncoding];
}

- (void)appendString:(NSString *)string encoding:(NSStringEncoding)encoding
{
    NSUInteger maxLenth = [string maximumLengthOfBytesUsingEncoding:encoding];
    NSUInteger offset = self.length;
    self.length += maxLenth;
    
    NSUInteger usedLength = 0;
    [string getBytes:self.mutableBytes+offset
           maxLength:maxLenth
          usedLength:&usedLength
            encoding:encoding
             options:NSStringEncodingConversionExternalRepresentation
               range:NSMakeRange(0, string.length)
      remainingRange:NULL];
    
    self.length -= maxLenth - usedLength;
}

@end
