# UIView

1. 同时处理阴影和圆角

2. 处理四个角不同的 cornerRadius
	
	方式 ①：CAShapeLayer + UIBezierpath 自带的指定圆角位置
	方式 ②：CAShapeLayer + 自定义的 CGPath

3. UIView 的上下文绘制圆形 + CGContextBeginTransparencyLayer 透明层添加阴影

4. App 首次使用，透明引导图

	* 方案一：生成整张引导图
		* 优点：
			* a. 快速

				只要设计师做好效果图以后，把蒙层导出成各种规格即可，90% 的工作量都在设计师身上，程序员只需要简单地添加视图和事件即可。
			* b. 维护成本低

				当界面发生变化，或者引导图需要调整时，只需要设计师重新生成图片，然后替换
		* 缺点：

			* a. 图片占据空间大

				每种设备一张图片，图片还是全屏规格的，可能还要适配横屏，明显会增加 app 安装包的大小
			* b. 图片无法复用

				一张引导图只能用于一个地方，其他地方不可能会用
				得上
			* c. 不够动态
			
				如果界面存在动态设置控件的隐藏、显示，或者布局会动态改变，那么体验就不够好。
	* 方案二：图片拼接
		* 优点：
			* a. 节约空间

				一般就只需要几个小图，然后就可以组装成一张引导图了

			* b. 图片可重用

				按钮、椭圆图、小箭头这一类的图片可能被其他引导图继续使用

		* 缺点：
			* a. 编码时间较长

				每一个界面元素都需要通过编码来实现，每一次改动也需要调整代码
	
	[iOS 半透明新手引导 手把手教你做](https://www.jianshu.com/p/b83aefdc9519)
	[Github](https://github.com/sunljz/demo/tree/master/GuideDemo)
	
	文中的方案局限性很大：挖洞的图片是固定的。
	
	* 方案三：CAShapeLayer + UIBezierPath 挖洞
	
	[iOS App中添加半透明新手指引](https://www.jianshu.com/p/00d4fe5a3c1a)