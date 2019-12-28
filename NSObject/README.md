# NSObject

1. > 单例类的实现

2. > +load 和 + (void)initialize 的区别

3. > 属性声明在 @implementation 里与 extension 里的区别

	```
	@interface Car () {
	@property (nonatomic, strong) Engine * engine;
	@end
	
	@implementation Car 
	{ 
	    Engine * _engine;
	}
	```
	
	Objective-C 编译器指令是以 <font color=#cc0000>@</font> 打头，它通常用来描述文件中的内容。.h 文件中 @interface 指令用来标识文件的接口代码的起始位置，而 @end 指令标示该段的结束位置。在 .m 文件中，@implementation 指令用来标识实现的起始位置，@end 标识结束位置。
	
	@interface Car () 是一个特殊的匿名 Category，即扩展（extension）。
	
	一般来说把要公开的信息（变量，属性，方法）定义在头文件里，把要隐藏的信息定义在类扩展里，只是为了隐藏私有信息， 不需要被外界知道的就不要放在头文件里， 这样可以隔离接口和实现。
	
	区别：
	
	* @property 可以添加属性标识符，原子性、读写、内存语义，有 getter、setter 方法；
	* @ property 既可以直接访问 _engine 成员变量，又可以通过点语法，调用 get 方法。
	
	[iOS 属性声明在@implementation里与extension里的区别](https://blog.csdn.net/zhongbeida_xue/article/details/51456858)
	
4. > ios中的拷贝你知道多少？

	[ios中的拷贝你知道多少？](https://www.jianshu.com/p/4e5fde48fcda)
	
5. > 线程与 KVO 的关系

	|触发 KVO 的线程|KVO 监听方法内的线程|
	|:-----:|:------:|
	|主线程|主线程|
	|非主线程|非主线程|
	
6. > KVO

7. > inline static

	[iOS OC内联函数 inline](https://www.jianshu.com/p/d557b0831c6a)
	[OC中的静态（static）/ 内联（inline）函数](https://www.jianshu.com/p/7fb0008ed730)
       [inline函数的好处与缺点](https://blog.csdn.net/tsinfeng/article/details/5871043)

8. > KVC

9. CPU 使用率