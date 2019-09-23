//
//  ProtocolCls.h
//  NSObject
//
//  Created by CYKJ on 2019/7/13.
//  Copyright © 2019年 D. All rights reserved.
//

#import <Foundation/Foundation.h>

// 协议 A
@protocol ProtocolA <NSObject>
@end


// 协议 B
@protocol ProtocolB <NSObject>
@end

@interface ClassB : NSObject <ProtocolB>
@end


// 协议 C
@protocol ProtocolC <NSObject>
@end

@interface ClassC : NSObject <ProtocolC>
@end
