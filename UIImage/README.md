# UIImage

1. imageNamed: 与 imageWithContentsOfFile:的区别

2. 图片压缩 [https://pngquant.org/](https://pngquant.org/)
[https://github.com/google/zopfli](https://github.com/google/zopfli)

3. 使用图层混合方式，将图片处理成不同颜色样式。

	```
	[originImage drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:1.0];
	[originImage drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0];
	```