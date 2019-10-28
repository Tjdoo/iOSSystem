# UIView

1. 同时处理阴影和圆角

2. 处理四个角不同的 cornerRadius
	
	方式 ①：CAShapeLayer + UIBezierpath 自带的指定圆角位置
	方式 ②：CAShapeLayer + 自定义的 CGPath

3. UIView 的上下文绘制圆形 + CGContextBeginTransparencyLayer 透明层添加阴影