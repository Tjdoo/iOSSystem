---
title: 协议分发
categories: iOS架构
---

Github：[AOMultiproxier](https://github.com/alessandroorru/AOMultiproxier)、[HJProtocolDispatcher](https://github.com/panghaijiao/HJProtocolDispatcher)

协议实现分发器，能够轻易实现将协议事件分发给多个实现者。

## 一、AOMultiproxier.h

```
#define AOMultiproxierForProtocol(__protocol__, ...) ((AOMultiproxier <__protocol__> *)[AOMultiproxier multiproxierForProtocol:@protocol(__protocol__) withObjects:((NSArray *)[NSArray arrayWithObjects:__VA_ARGS__,nil])])
```

调用类方法的宏定义。

```
@interface AOMultiproxier : NSProxy

@property (nonatomic, strong, readonly) Protocol * protocol;  // 协议
@property (nonatomic, strong, readonly) NSArray * attachedObjects;  // 协议方法实现者

+ (instancetype)multiproxierForProtocol:(Protocol *)protocol 
						    withObjects:(NSArray*)objects;
@end
```

AOMultiproxier 继承自 NSProxy 类，声明了两个只读属性和一个初始化方法。

```
NS_ROOT_CLASS
@interface NSProxy <NSObject>{
    Class   isa;
}
```

NSProxy 是一个类似于 NSObject 的根类，实现了 NSObject 协议。

苹果的官方文档描述：

> Typically, a message to a proxy is forwarded to the real object or causes the proxy to load (or transform itself into) the real object. Subclasses of NSProxy can be used to implement transparent distributed messaging (for example, NSDistantObject) or for lazy instantiation of objects that are expensive to create.
> 
> NSProxy implements the basic methods required of a root class, including those defined in the NSObject protocol. However, as an abstract class it doesn’t provide an initialization method, and it raises an exception upon receiving any message it doesn’t respond to. A concrete subclass must therefore provide an initialization or creation method and override the forwardInvocation: and methodSignatureForSelector: methods to handle messages that it doesn’t implement itself. A subclass’s implementation of forwardInvocation: should do whatever is needed to process the invocation, such as forwarding the invocation over the network or loading the real object and passing it the invocation. methodSignatureForSelector: is required to provide argument type information for a given message; a subclass’s implementation should be able to determine the argument types for the messages it needs to forward and should construct an NSMethodSignature object accordingly. See the NSDistantObject, NSInvocation, and NSMethodSignature class specifications for more information.

NSProxy 仅仅是个转发消息的场所，至于如何转发，取决于派生类到底如何实现。比如可以在内部 hold 住（或创建）一个对象，然后把消息转发给该对象。那我们就可以在转发的过程中做些手脚了，甚至可以不去创建这些对象，去做任何你想做的事情，但是必须要实现他的 forwardInvocation: 和 methodSignatureForSelector: 方法。

## 二、AOMultiproxier.m

```
@interface AOMultiproxier()
@property (nonatomic, strong) Protocol * protocol;
@property (nonatomic, strong) NSOrderedSet * objects;
@end
```

私有 readwrite 属性。

```
+ (instancetype)multiproxierForProtocol:(Protocol *)protocol withObjects:(NSArray *)objects
{
    // 调用实例方法  
    return [[super alloc] initWithProtocol:protocol objects:objects];;
}

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

    // 没有任何对象遵守协议，触发断言
    NSAssert(oneConforms, @"You didn't attach any object that declares itself conforming to %@. At least one is needed.", NSStringFromProtocol(protocol));
    
    _objects = [NSOrderedSet orderedSetWithArray:validObjects];
    
    if (_objects.count <= 0 || !oneConforms) return nil;

    return self;
}
```

初始化方法，给属性赋值。判断对象数组 objects 里的对象是否能够遵守了协议。

```
+ (BOOL)conformsToProtocol:(Protocol*)protocol
{
    return YES;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol 
{
    return protocol_conformsToProtocol(self.protocol, aProtocol);
}
```

重写方法。在此处一直返回 YES，且未调用。

```
- (NSArray *)attachedObjects
{
    return [self.objects array];
}
```

NSSet -》NSArray。

```
/**
 * 是否能够响应 selector 方法。
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
 * 转发消息
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
 * 获取方法签名，包含参数类型、返回值类型等信息。 
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
    // 方法描述 -> 方法签名    
    theMethodSignature = [NSMethodSignature signatureWithObjCTypes:methodDescription.types];

    return theMethodSignature;
}
```

消息转发核心方法。检查 selector 对应的方法描述是否正确，并对 required 方法未实现的情况做出处理。

```
/**
 * 返回方法描述
 */
- (struct objc_method_description)_methodDescriptionForSelector:(SEL)selector isMandatory:(BOOL *)isMandatory
{
    struct objc_method_description method = {NULL, NULL};
 
    // First check on main protocol. 当前协议查找
    method = [self _methodDescriptionInProtocol:self.protocol selector:selector isMandatory:isMandatory];
    
    // If no method is known on main protocol, try on ancestor protocols. 在父协议查找
    if (method.name == NULL) {
        unsigned int count = 0;
        Protocol * __unsafe_unretained * list = protocol_copyProtocolList(self.protocol, &count);
        for (NSUInteger i = 0; i < count; i++) {
            Protocol * aProtocol = list[i];

            // Skip root protocol
            if ([NSStringFromProtocol(aProtocol) isEqualToString:@"NSObject"]) continue;
            
            method = [self _methodDescriptionInProtocol:aProtocol selector:selector isMandatory:isMandatory];
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
 * 获取方法描述
 */
- (struct objc_method_description)_methodDescriptionInProtocol:(Protocol *)protocol selector:(SEL)selector isMandatory:(BOOL *)isMandatory
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
```

实际获取方法是 \_methodDescriptionInProtocol:selector: isMandatory:，在方法内调用运行时方法  protocol\_getMethodDescription，这个方法有四个参数，来看看各代表了什么。

```
/** 
 * Returns a method description structure for a specified method of a given protocol.
 * 
 * @param proto A protocol.
 * @param aSel A selector.
 * @param isRequiredMethod A Boolean value that indicates whether aSel is a required method. 标识是否是必须实现的
 * @param isInstanceMethod A Boolean value that indicates whether aSel is an instance method. 标识是否是实例方法
 * 
 * @return An c objc_method_description structure that describes the method specified by e aSel,
 *  e isRequiredMethod, and e isInstanceMethod for the protocol e p.
 *  If the protocol does not contain the specified method, returns an c objc_method_description structure
 *  with the value c {NULL, c NULL}.
 * 
 * @note This function recursively searches any protocols that this protocol conforms to.
 */
OBJC_EXPORT struct objc_method_description
protocol_getMethodDescription(Protocol * _Nonnull proto, SEL _Nonnull aSel,
                              BOOL isRequiredMethod, BOOL isInstanceMethod)
    OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0, 2.0);
```

注意第三、四个参数即可。

```
- (BOOL)_checkIfAttachedObjectsRespondToSelector:(SEL)selector
{
    for (id object in self.objects) {
        if ([object respondsToSelector:selector]) {
            return YES;
        }
    }
    
    return NO;
}
```

检查 object 对象是否能够响应 selector 方法。

```
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

        // Skip root protocol. 如果查找到了 NSObject 协议，结束查找
        if ([NSStringFromProtocol(aProtocol) isEqualToString:@"NSObject"]) continue;
        
        // 递归调用
        if ([self _object:object inheritsProtocolOrAncestorOfProtocol:aProtocol]) {
            conforms = YES;
            break;
        }
    }
    free(list);
    
    return conforms;
}
```

查找 object 是否实现了协议方法。

## 三、HJProtocolDispatcher.h

```
#define AOProtocolDispatcher(__protocol__, ...)  \
    [ProtocolDispatcher dispatcherProtocol:@protocol(__protocol__)  \
                            toImplemertors:\[NSArray arrayWithObjects:__VA_ARGS__, nil]]
```

同样的宏定义，这里用了 \ 换行，更适合阅读。\_\_VA\_ARGS__ 是新的 C99 规范中新增的一个可变参数的宏，目前似乎只有 gcc 支持（[VC6.0](https://www.baidu.com/s?wd=VC6.0&tn=24004469_oem_dg&rsv_dl=gh_pl_sl_csd)的编译器不支持），实现思想就是宏定义中参数列表的最后一个参数为 ...。

## 四、HJProtocolDispatcher.m

```
/**
 * 返回方法描述
 */
struct objc_method_description MethodDescriptionForSELInProtocol(Protocol *protocol, SEL sel) {

    // required 方法

    struct objc_method_description description = protocol_getMethodDescription(protocol, sel, YES, YES);
    if (description.types) {
        return description;
    }

    // optional 方法
    description = protocol_getMethodDescription(protocol, sel, NO, YES);
    if (description.types) {
        return description;
    }

    // 未找到
    return (struct objc_method_description){NULL, NULL};
}

/**
 * 判断 protocol 是否包含 sel 方法 
 */
BOOL ProtocolContainSel(Protocol *protocol, SEL sel) {
    return MethodDescriptionForSELInProtocol(protocol, sel).types ? YES: NO;
}
```

私有方法。

```
@interface ImplemertorContext : NSObject
@property (nonatomic, weak) id implemertor;  // 方法实现者，即最后调用方法的对象
@end

@implementation ImplemertorContext
@end

ImplemertorContext 是每个实现者的封装。

@interface ProtocolDispatcher ()

@property (nonatomic, strong) Protocol * prococol;    // 协议
@property (nonatomic, strong) NSArray * implemertors; // 实现者数组

@end

@implementation ProtocolDispatcher

+ (id)dispatcherProtocol:(Protocol *)protocol toImplemertors:(NSArray *)implemertors 
{
    return [[ProtocolDispatcher alloc] initWithProtocol:protocol toImplemertors:implemertors];
}

- (instancetype)initWithProtocol:(Protocol *)protocol toImplemertors:(NSArray *)implemertors 
{
    if (self = [super init]) {
        self.prococol = protocol;
        NSMutableArray *implemertorContexts = [NSMutableArray arrayWithCapacity:implemertors.count];
        [implemertors enumerateObjectsUsingBlock:^(id implemertor, NSUInteger idx, BOOL * _Nonnull stop) {
            ImplemertorContext *implemertorContext = [ImplemertorContext new];
            implemertorContext.implemertor = implemertor;
            [implemertorContexts addObject:implemertorContext];
            objc_setAssociatedObject(implemertor, _cmd, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }];
        self.implemertors = [implemertorContexts copy];
    }
    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    // 如果协议未包含方法，直接调用 super
    if (!ProtocolContainSel(self.prococol, aSelector)) {
        return [super respondsToSelector:aSelector];
    }
    
    for (ImplemertorContext *implemertorContext in self.implemertors) {
        if ([implemertorContext.implemertor respondsToSelector:aSelector]) {
            return YES;
        }
    }
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    // 如果协议未包含方法，直接调用 super 
    if (!ProtocolContainSel(self.prococol, aSelector)) {
        return [super methodSignatureForSelector:aSelector];
    }
    
    struct objc_method_description methodDescription = MethodDescriptionForSELInProtocol(self.prococol, aSelector);
    return [NSMethodSignature signatureWithObjCTypes:methodDescription.types];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL aSelector = anInvocation.selector;

    // 如果协议未包含方法，直接调用 super 
    if (!ProtocolContainSel(self.prococol, aSelector)) {
        [super forwardInvocation:anInvocation];
        return;
    }
    
    for (ImplemertorContext *implemertorContext in self.implemertors) {
        if ([implemertorContext.implemertor respondsToSelector:aSelector]) {
            [anInvocation invokeWithTarget:implemertorContext.implemertor];
        }
    }
}
```

## 五、总结

HJProtocolDispatcher 与 AOMultiproxier 的思想和功能大体相同。

AO 功能更齐全，它会去父协议中检查方法是否存在，且对 required 方法添加了逻辑判断。

AO 继承自 NSProxy，HJ 继承自 NSObject。NSObject 寻找方法顺序：本类->父类->动态方法解析->消息转发；NSproxy 顺序：本类->消息转发，同样做“消息转发”，NSObject 会比 NSProxy 多做好多事，也就意味着耽误很多时间，所以 NSProxy 效率更高。