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