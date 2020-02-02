# UIImage

1. imageNamed: 与 imageWithContentsOfFile:的区别

2. 图片压缩 [https://pngquant.org/](https://pngquant.org/)
[https://github.com/google/zopfli](https://github.com/google/zopfli)

3. 使用图层混合方式，将图片处理成不同颜色样式。

	```
	[originImage drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:1.0];
	[originImage drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0];
	```
	
4. 处理模块化工程图片加载
	
	HookTool.h、HookTool.m 处理图片资源不在 mainBundle 中，xib 设置图片名称无效的问题。

5. > 圆角处理

	[[iOS] 图像处理 - 一种高效裁剪图片圆角的算法](https://www.jianshu.com/p/bbb50b2cb7e6)
	
6. > 图片缩放

	[图片调整技术](https://www.jianshu.com/p/154b938d2046)
	
	
[图片ImageI/O解码探究](https://www.jianshu.com/p/19e1faddd37f)
[图片处理：Image I/O 学习笔记](https://www.jianshu.com/p/4dcd6e4bdbf0)
[处理iOS中照片的方向的问题](https://blog.csdn.net/zhang522802884/article/details/79800617)