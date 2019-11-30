//
//  Person.h
//  NSObject
//
//  Created by CYKJ on 2019/11/28.
//  Copyright © 2019年 D. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainPerson : NSObject
{
    NSString * _name;
    int _age;
}
@end


@interface Man : MainPerson
{
    int _score;
}
@end

@interface Student : NSObject
{
    int _age;
}
@end

NS_ASSUME_NONNULL_END
