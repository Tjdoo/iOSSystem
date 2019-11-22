1. > copy、strong 修饰的区别

2. > 银行卡号间增加间隔

3. > NSMutableData 高效率追加 NSString

	[NSMutableData高效率追加NSString](https://blog.csdn.net/baight123/article/details/53580436)
	
4. > appendFormat: 和 appendString: 的区别

	使用 appendString: 传入参数 nil，导致崩溃，崩溃信息：
	
	```
	*** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[__NSCFString appendString:]: nil argument'
	```
	
	猜测：`appendFormat:` 底层对 nil 进行了判断或处理
	
5. >Tagged Pointer：将一个对象的指针拆成两部分，一部分直接保存数据，另一部分作为特殊标记（最后一个 bit 位），表示这是一个特别的指针，不指向任何一个地址。Tagged Pointer 并不是真正的对象，我们在使用时需要注意不要直接访问其 isa 变量。

	[深入理解Tagged Pointer](https://www.jianshu.com/p/c9089494fb6c)
	[TaggedPointer](https://www.jianshu.com/p/01153d2b28eb)
	
	![](https://upload-images.jianshu.io/upload_images/2291135-070f531e813e962a.png?imageMogr2/auto-orient/strip|imageView2/2/w/811)
	![](https://upload-images.jianshu.io/upload_images/2291135-840cf1c5b39bc82b.png?imageMogr2/auto-orient/strip|imageView2/2/w/805)