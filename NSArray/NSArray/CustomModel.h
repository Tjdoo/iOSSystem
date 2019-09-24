//
//  CustomModel.h
//  NSArray
//
//  Created by CYKJ on 2019/9/24.
//  Copyright © 2019年 D. All rights reserved.


#import <Foundation/Foundation.h>


/**
  *  @brief   人
  */
@interface CustomPerson : NSObject <NSCopying>

@property (nonatomic, copy) NSString * name;

@end

@protocol CustomPerson <NSObject>
@end

/**
 *  @brief   物
 */
@interface  CustomThing : NSObject <NSCopying>

@property (nonatomic, copy) NSString * name;

@end

@protocol CustomThing <NSObject>
@end




@interface CustomModel : NSObject <NSCopying, NSCoding>

@property (nonatomic, copy) NSArray<CustomPerson> * persons;
@property (nonatomic, copy) NSArray<CustomThing> * things;

@end
