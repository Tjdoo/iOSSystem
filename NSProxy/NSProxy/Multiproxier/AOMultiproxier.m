//
//  AOMultiproxier.m
//  Pods
//
//  Created by Alessandro Orrù on 21/01/15.


#import "AOMultiproxier.h"
#import <objc/runtime.h>

@interface AOMultiproxier()
@property (nonatomic, strong) Protocol * protocol;
@property (nonatomic, strong) NSOrderedSet * objects;
@end


@implementation AOMultiproxier

+ (instancetype)multiproxierForProtocol:(Protocol *)protocol withObjects:(NSArray *)objects
{
    // 调用实例方法
    AOMultiproxier * multiproxier = [[super alloc] initWithProtocol:protocol
                                                            objects:objects];
    return multiproxier;
}

/**
  *  @brief   初始化方法，给属性赋值。判断对象数组 objects 里的对象是否能够遵守了协议。
  */
- (instancetype)initWithProtocol:(Protocol*)protocol objects:(NSArray*)objects
{
    // 保存协议
    _protocol = protocol;
    
    NSMutableArray * validObjects = [NSMutableArray array];
    
    BOOL oneConforms = NO;
    for (id object in objects) {
        // 判断 object 是否遵守了 protocol 协议
        if ([object conformsToProtocol:protocol]) {
            oneConforms = YES;
        }
        // 判断 object 是否遵守了 protocol 协议或者 protocol 的父协议
        if ([self _object:object inheritsProtocolOrAncestorOfProtocol:protocol]) {
            [validObjects addObject:object];
        }
    }

    // 没有任何对象遵守协议时，触发断言
    NSAssert(oneConforms, @"You didn't attach any object that declares itself conforming to %@. At least one is needed.", NSStringFromProtocol(protocol));
    
    // NSArray -》NSOrderedSet
    _objects = [NSOrderedSet orderedSetWithArray:validObjects];
    
    if (_objects.count <= 0 || !oneConforms) return nil;

    return self;
}

/**
  *  @brief  重写方法。在此处一直返回 YES，且未调用。
  */
+ (BOOL)conformsToProtocol:(Protocol *)protocol
{
    return YES;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    return protocol_conformsToProtocol(self.protocol, aProtocol);
}

- (NSArray *)attachedObjects
{
    return [self.objects array];
}


#pragma mark - Forward methods
/**
  *  @brief   是否能够响应 selector 方法。
  */
- (BOOL)respondsToSelector:(SEL)selector
{
    BOOL responds = NO;
    // 是否是必须实现的协议方法（required）
    BOOL isMandatory = NO;
    
    // 获取方法描述
    struct objc_method_description methodDescription = [self _methodDescriptionForSelector:selector
                                                                               isMandatory:&isMandatory];
    
    if (isMandatory) {
        responds = YES;
    }
    else if (methodDescription.name != NULL) {
        // 非必须实现的再检查 object 是否实现了协议方法
        responds = [self _checkIfAttachedObjectsRespondToSelector:selector];
    }

    return responds;
}

/**
 *  @brief   转发消息
 */
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL selector = [anInvocation selector];

    BOOL isMandatory = NO;

    struct objc_method_description methodDescription = [self _methodDescriptionForSelector:selector
                                                                               isMandatory:&isMandatory];
    // 方法描述获取失败，调用 super 触发 crash
    if (methodDescription.name == NULL) {
        [super forwardInvocation:anInvocation];
        return;
    }
    
    BOOL someoneResponded = NO;
    for (id object in self.objects) {
        // 可以响应，由 object 调用协议方法
        if ([object respondsToSelector:selector]) {
            [anInvocation invokeWithTarget:object];
            someoneResponded = YES;
        }
    }

    // If a mandatory method has not been implemented by any attached object, this would provoke a crash
    // 如果没有 required 方法没有被实现，调用 super 触发 crash
    if (isMandatory && !someoneResponded) {
        [super forwardInvocation:anInvocation];
    }
}

/**
  *  @brief   获取方法签名，包含参数类型、返回值类型等信息。
  */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature * theMethodSignature;

    BOOL isMandatory = NO;
    struct objc_method_description methodDescription = [self _methodDescriptionForSelector:selector
                                                                               isMandatory:&isMandatory];
    
    if (methodDescription.name == NULL) {
        return nil;
    }
    
    // 方法描述 -》方法签名
    theMethodSignature = [NSMethodSignature signatureWithObjCTypes:methodDescription.types];

    return theMethodSignature;
}



#pragma mark - Utility methods
/**
  *  @brief   返回方法描述
  */
- (struct objc_method_description)_methodDescriptionForSelector:(SEL)selector
                                                    isMandatory:(BOOL *)isMandatory
{
    struct objc_method_description method = {NULL, NULL};
 
    // First check on main protocol. 当前协议查找
    method = [self _methodDescriptionInProtocol:self.protocol
                                       selector:selector
                                    isMandatory:isMandatory];
    
    // If no method is known on main protocol, try on ancestor protocols. 在父协议查找
    if (method.name == NULL) {
        
        unsigned int count = 0;
        Protocol * __unsafe_unretained * list = protocol_copyProtocolList(self.protocol, &count);
        for (NSUInteger i = 0; i < count; i++) {
            Protocol * aProtocol = list[i];

            // Skip root protocol
            if ([NSStringFromProtocol(aProtocol) isEqualToString:@"NSObject"])
                continue;
            
            method = [self _methodDescriptionInProtocol:aProtocol
                                               selector:selector
                                            isMandatory:isMandatory];
            // 找到了
            if (method.name != NULL) {
                break;
            }
        }
        free(list);
    }
    
    return method;
}

/**
  *  @brief   获取方法描述。在方法内调用运行时方法  protocol_getMethodDescription
  */
- (struct objc_method_description)_methodDescriptionInProtocol:(Protocol *)protocol
                                                      selector:(SEL)selector
                                                   isMandatory:(BOOL *)isMandatory
{
    struct objc_method_description method = {NULL, NULL};

    // 使用 runtime 方法获取
    method = protocol_getMethodDescription(protocol, selector, YES, YES);
    if (method.name != NULL) {
        *isMandatory = YES;
        return method;
    }
    
    method = protocol_getMethodDescription(protocol, selector, NO, YES);
    if (method.name != NULL) {
        *isMandatory = NO;
    }
    
    return method;
}

/**
  *  @brief   检查 object 对象是否能够响应 selector 方法
  */
- (BOOL)_checkIfAttachedObjectsRespondToSelector:(SEL)selector
{
    for (id object in self.objects) {
        if ([object respondsToSelector:selector]) {
            return YES;
        }
    }
    
    return NO;
}

/**
  *  @brief   查找 object 是否实现了协议方法。
  */
- (BOOL)_object:(id)object inheritsProtocolOrAncestorOfProtocol:(Protocol*)protocol
{
    // 在当前协议中查找
    if ([object conformsToProtocol:protocol]) {
        return YES;
    }
    
    BOOL conforms = NO;
    
    unsigned int count = 0;
    Protocol * __unsafe_unretained * list = protocol_copyProtocolList(protocol, &count);
    
    // 在查找父协议中查找
    for (NSUInteger i = 0; i < count; i++) {
        Protocol * aProtocol = list[i];

        // Skip root protocol.  如果查找到了 NSObject 协议，结束查找
        if ([NSStringFromProtocol(aProtocol) isEqualToString:@"NSObject"])
            continue;
        
        // 递归调用
        if ([self _object:object inheritsProtocolOrAncestorOfProtocol:aProtocol]) {
            conforms = YES;
            break;
        }
    }
    free(list);
    
    return conforms;
}

@end

