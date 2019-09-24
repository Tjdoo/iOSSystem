//
//  CustomModel.m
//  NSArray
//
//  Created by CYKJ on 2019/9/24.
//  Copyright © 2019年 D. All rights reserved.


#import "CustomModel.h"


@implementation CustomPerson

- (instancetype)copyWithZone:(NSZone *)zone
{
    CustomPerson * person = [[self.class allocWithZone:zone] init];
    person.name = self.name;
    
    return person;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}

@end



@implementation CustomThing

- (instancetype)copyWithZone:(NSZone *)zone
{
    CustomThing * thing = [[self.class allocWithZone:zone] init];
    thing.name = self.name;
    
    return thing;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}

@end



@implementation CustomModel

- (instancetype)copyWithZone:(NSZone *)zone
{
    CustomModel * model = [[self.class allocWithZone:zone] init];
    model.persons = [[NSArray<CustomPerson> alloc] initWithArray:self.persons copyItems:YES];
    model.things = [[NSArray<CustomThing> alloc] initWithArray:self.things copyItems:YES];
    
    return model;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_persons forKey:@"persons"];
    [aCoder encodeObject:_things  forKey:@"things"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _persons = [aDecoder decodeObjectForKey:@"persons"];
        _things = [aDecoder decodeObjectForKey:@"things"];
    }
    return self;
}

@end
