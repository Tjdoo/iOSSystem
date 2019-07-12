NSProxy 是一个实现了 NSObject 协议类似于 NSObject 的根类。

```objc
NS_ROOT_CLASS
@interface NSProxy <NSObject>{
    Class   isa;
}
```

苹果的官方文档：

> Typically, a message to a proxy is forwarded to the real object or causes the proxy to load (or transform itself into) the real object. Subclasses of NSProxy can be used to implement transparent distributed messaging (for example, NSDistantObject) or for lazy instantiation of objects that are expensive to create.
> 
> NSProxy implements the basic methods required of a root class, including those defined in the NSObject protocol. However, as an abstract class it doesn’t provide an initialization method, and it raises an exception upon receiving any message it doesn’t respond to. A concrete subclass must therefore provide an initialization or creation method and override the forwardInvocation: and methodSignatureForSelector: methods to handle messages that it doesn’t implement itself. A subclass’s implementation of forwardInvocation: should do whatever is needed to process the invocation, such as forwarding the invocation over the network or loading the real object and passing it the invocation. methodSignatureForSelector: is required to provide argument type information for a given message; a subclass’s implementation should be able to determine the argument types for the messages it needs to forward and should construct an NSMethodSignature object accordingly. See the NSDistantObject, NSInvocation, and NSMethodSignature class specifications for more information.

看了这些描述我们应该能对 NSProxy 有个初步印象，它仅仅是个转发消息的场所，至于如何转发，取决于派生类的具体实现。比如可以在内部 hold 住（或创建）一个对象，然后把消息转发给该对象。那我们就可以在转发的过程中做些手脚了。甚至也可以不去创建这些对象，去做任何你想做的事情，但是必须要实现它的 forwardInvocation: 和 methodSignatureForSelector: 方法。


## 一、用途

1、多继承

大致过程就是让它持有要实现多继承的类的对象，然后用多个接口定义不同的行为，并让 Proxy 去实现这些接口，然后在转发的时候把消息转发到实现了该接口的对象去执行，这样就好像实现了多重继承一样。注意：这个真不是多重继承，只是包含，然后把消息路由到指定的对象而已，其实完全可以用 NSObject 类来实现。

NSObject 寻找方法顺序：本类 -> 父类 -> 动态方法解析 -> 备用对象 -> 消息转发；  
 NSproxy 寻找方法顺序：本类-> 消息转发；

同样做“消息转发”，NSObject 会比 NSProxy 多做好多事，也就意味着耽误很多时间。

首先新建两个基类如下：

```
@implementation classA
-(void)infoA
{
    NSLog(@"classA 卖水");   
}
@end

@implementation classB

-(void)infoB
{
    NSLog(@"classB 卖饭");
}

@end
```

代理如下：

```objc
@interface ClassProxy : NSProxy
@property(nonatomic, strong, readonly) NSMutableArray * targetArray;
-(void)target:(id)target;
-(void)handleTargets:(NSArray *)targets;

@end
```

NSProxy 必须以子类的形式出现。

因为考虑到很可能还有其他的卖衣服的、卖鞋子的需要 ClassProxy 来代理，这边做了一个数组来存放需要代理的类。

```objc
@interface ClassProxy()
@property (nonatomic, strong) NSMutableArray * targetArray; // 多个 targets 皆可代理
@property (nonatomic, strong) NSMutableDictionary * methodDic;
@property (nonatomic, strong) id target;
@end
```

然后 target 和相对应的 method name 做了一个字典来存储，方便获取。

```objc
-(void)registMethodWithTarget:(id)target
{
    unsigned int countOfMethods = 0;
    Method *method_list = class_copyMethodList([target class], &countOfMethods);
    for (int i = 0; i<countOfMethods; i++) {
        Method method = method_list[i];
        //得到方法的符号
        SEL sel = method_getName(method);
        //得到方法的符号字符串
        const char *sel_name = sel_getName(sel);
        //得到方法的名字
        NSString * method_name = [NSString stringWithUTF8String:sel_name];
        self.methodDic[method_name] = target;
    }
    free(method_list);
}
```

然后就是最主要的两个方法

```objc
-(void)forwardInvocation:(NSInvocation *)invocation
{
    SEL sel = invocation.selector;
    NSString *methodName = NSStringFromSelector(sel);
    id target = self.methodDic[methodName];
    if (target) {
        [invocation invokeWithTarget:target];
    } 
}
-(NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    NSMethodSignature *Method;
    NSString *methodName = NSStringFromSelector(sel);
    id target = self.methodDic[methodName];
    if (target) {
        Method =  [target methodSignatureForSelector:sel];
    }
    else{
        Method = [super methodSignatureForSelector:sel];
    }
    return Method;
}
```

methodSignatureForSelector: 得到对应的方法签名，通过 forwardInvocation: 转发。

调用和打印结果：

```
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self classInheritance];
}

/**
 * 多继承
 */
-(void)classInheritance
{
    classA * A = [[classA alloc]init];
    classB * B = [[classB alloc]init];
    ClassProxy * proxy = [ClassProxy alloc];

    [proxy handleTargets:@[A, B]];
    [proxy performSelector:@selector(infoA)];
    [proxy performSelector:@selector(infoB)];
}

2018-12-27 18:02:34.445 NSProxyStudy[18975:4587631] classA 卖水
2018-12-27 18:02:34.446 NSProxyStudy[18975:4587631] classB 卖饭
```

以上就是利用 NSProxy 实现多继承。


2、避免循环应用

举一个比较常见的例子 NSTimer。

由于苹果在 iOS10 以上给出了 timer 的 block 方式，已经可以解决循环引用的问题。所以这里只是说明利用 NSProxy 如何解决循环引用，实际情况可直接使用系统的方法。

首先因为 NSTimer 创建的时候需要传入一个 target，并且持有它，而 target 本身也会持有 timer 所以会造成循环引用。所以我们将 target 用 NSProxy 的子类代替。如下：

```
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.timer = [NSTimer timerWithTimeInterval:1
                                         target:[WeakProxy proxyWithTarget:self]
                                       selector:@selector(invoked:)
                                       userInfo:nil
                                        repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)invoked:(NSTimer *)timer
{
    NSLog(@"1");
}
```

在 WeakProxy 中我们设定 target 为弱引用。

```
@interface WeakProxy ()
@property (nonatomic, weak) id target;
@end

@implementation WeakProxy
+(instancetype)proxyWithTarget:(id)target
{
    return [[self alloc] initWithTarget:target];
}

-(instancetype)initWithTarget:(id)target
{
    self.target = target; 
    return self;
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [self.target methodSignatureForSelector:sel];
}
-(void)forwardInvocation:(NSInvocation *)invocation
{
    SEL sel = invocation.selector;
    if ([self.target respondsToSelector:sel]) {
        [invocation invokeWithTarget:self.target];
    }
}
@end
```

然后同样利用上述两个方法进行消息转发即可。

3、AOP

要重点介绍的功能就是 AOP（Aspect Oriented Programming），它是可以通过预编译方式和运行时动态代理实现在不修改源代码的情况下给程序动态添加功能的一种技术。

iOS 中面向切片编程一般有两种方式 ，一种是直接基于 runtime 的 method-Swizzling 机制来实现方法替换从而达到 hook 的目的，另一种就是基于 NSProxy。

OC 的动态语言的核心部分应该就是 objc_msgSend 方法的调用了。该函数的声明大致如下：

```
/**
 * 参数 1：接受消息的 target
 * 参数 2：要执行的 selector
 * 参数 3：要调用的方法
 * 可变参数：若干个要传给 selector 的参数 
 */
id objc_msgSend(id self, SEL _cmd, ...)
```

只要我们能够 Hook 到对某个对象的 objc_msgSend 的调用，并且可以修改其参数甚至于修改成任意其他 selector 的 IMP，我们就实现了 AOP。

```
@interface MyProxy : NSProxy {
     id _innerObject;  // 在内部持有要 hook 的对象
}
+(instancetype)proxyWithObj:(id)object;
@end

@interface Dog : NSObject
-(NSString *)barking:(NSInteger)months;
@end
```

实现部分：

```
@implementation MyProxy
+(instancetype)proxyWithObj:(id)object
{
    MyProxy * proxy = [MyProxy alloc];
    // 持有要 hook 的对象
    proxy->_innerObject = object;
    // 注意返回的值是 Proxy 对象
    return proxy;
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    // 这里可以返回任何 NSMethodSignature 对象，也可以完全自己构造一个
    return [_innerObject methodSignatureForSelector:sel];
}
- (void)forwardInvocation:(NSInvocation *)invocation
{
    if([_innerObject respondsToSelector:invocation.selector]){
        NSString *selectorName = NSStringFromSelector(invocation.selector);
        NSLog(@"Before calling %@",selectorName);
        [invocation retainArguments];
        NSMethodSignature *sig = [invocation methodSignature];
        // 获取参数个数，注意在本例里这里的值是 3，因为 objc_msgSend 隐含了 self、selector 参数
        NSUInteger cnt = [sig numberOfArguments];
        // 本例只是简单的将参数和返回值打印出来
        for (int i = 0; i < cnt; i++) {

            // 参数类型
            const char * type = [sig getArgumentTypeAtIndex:i];
            if(strcmp(type, "@") == 0){
                NSObject *obj;
                [invocation getArgument:&obj atIndex:i];
                // 这里输出的是："parameter (0)'class is MyProxy"，也证明了这是 objc_msgSend 的第一个参数
                NSLog(@"parameter (%d)'class is %@", i, [obj class]);
            }
            else if(strcmp(type, ":") == 0){
                SEL sel;
                [invocation getArgument:&sel atIndex:i];
                // 这里输出的是:"parameter (1) is barking:"，也就是 objc_msgSend 的第二个参数
                NSLog(@"parameter (%d) is %@", i, NSStringFromSelector(sel));
            }
            else if(strcmp(type, "q") == 0){
                int arg = 0;
                [invocation getArgument:&arg atIndex:i];
                // 这里输出的是:"parameter (2) is int value is 4"，稍后会看到我们在调用 barking 的时候传递的参数就是 4
                NSLog(@"parameter (%d) is int value is %d", i, arg);
            }
        }
        // 消息转发
        [invocation invokeWithTarget:_innerObject];
        const char *retType = [sig methodReturnType];
        if(strcmp(retType, "@") == 0){
            NSObject *ret;
            [invocation getReturnValue:&ret];
            //这里输出的是:"return value is wang wang!"
            NSLog(@"return value is %@", ret);
        }
        NSLog(@"After calling %@", selectorName);
    }
}
@end

@implementation Dog
-(NSString *)barking:(NSInteger)months
{
    return months > 3 ? @"wang wang!" : @"eng eng!";
}
@end
```

函数的调用如下：

```
Dog * dog = [MyProxy proxyWithObj:[Dog alloc]];
[dog barking:4];
```

上面的代码中，可以任意更改参数、调用的方法，甚至转发给其他类型的对象，这确实达到了 Hook 对象的目的，也就是可以实现 AOP 的功能了。

```
typedef void(^proxyBlock)(id target,SEL selector);

NS_ASSUME_NONNULL_BEGIN

@interface AOPProxy : NSProxy
+(instancetype)proxyWithTarget:(id)target;
-(void)inspectSelector:(SEL)selector preSelTask:(proxyBlock)preTask endSelTask:(proxyBlock)endTask;
@end

@interface AOPProxy ()
@property (nonatomic, strong) id target;
@property (nonatomic, strong) NSMutableDictionary * preSelTaskDic;
@property (nonatomic, strong) NSMutableDictionary * endSelTaskDic;
@end

-(void)inspect{
    NSMutableArray * targtArray = [AOPProxy proxyWithTarget:[NSMutableArray arrayWithCapacity:1]];
    [(AOPProxy *)targtArray inspectSelector:@selector(addObject:) preSelTask:^(id target, SEL selector) {
        [target addObject:@"-------"];
        NSLog(@"%@ 我加进来之前", target);
    } endSelTask:^(id target, SEL selector) {
        [target addObject:@"-------"];
        NSLog(@"%@ 我加进来之后", target);
    }];
    [targtArray addObject:@"我是一个元素"];
}

( "-------" ) 我加进来之前
( "-------", 
  "U6211U662fU4e00U4e2aU5143U7d20", 
  "-------" ) 
我加进来之后

。
```

4、实现延迟初始化（Lazy Initialization）

使用场景：

①、在 [SomeClass lazy] 之后调用 doSomthing，首先进入 forwardingTargetForSelector，\_object 为 nil 并且不是 init 开头的方法的时候会调用 init 初始化对象，然后将消息转发给代理对象 \_object；

②、在 [SomeClass lazy] 之后调用 initWithXXX:，首先进入 forwardingTargetForSelector 返回 nil，然后进入 methodSignatureForSelector: 和 forwardInvocation: 保存自定义初始化方法的调用，最后调用 doSomthing，进入 forwardingTargetForSelector，\_object 为 nil 并且不是 init 开头的方法的时候会调用自定义初始化方法，然后将消息转发给代理对象 \_object。

```
SomeClass *object = [SomeClass lazy];

// other thing ...

[object doSomething];  // 在这里 object 才会调用初始化方法，然后调用 doSomething
```