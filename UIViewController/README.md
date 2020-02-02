
1. > ChildViewController

	添加、移除子视图控制器。

2. > setNeedsStatusBarAppearanceUpdate 耗时问题

	使用 Time Profiler 工具定位界面卡顿时发现。
	
3. > UIStatusBar 

	[iOS-UIStatusBar详细总结](https://www.jianshu.com/p/be6bde3a821d)
	[iOS 状态栏的隐藏和显示](https://www.jianshu.com/p/4b2aa09bee06)
	[iOS开发小知识--隐藏状态栏，导航栏向上移动的处理方法](https://www.jianshu.com/p/3c05af245f88)
	
4. > safeArea

	[iOS 11 safeArea详解 & iphoneX 适配](https://www.jianshu.com/p/1432a94ef66f)
	[iOS11 与 iPhone X适配的那些坑](https://www.jianshu.com/p/aff9509cfe29?from=groupmessage)
	[有关iOS11和iPhoneX的适配问题](https://www.jianshu.com/p/a4e778c2236e)
	
	<center>
	![](http://dzliving.com/SafeArea_0.png?imageView2/0/w/400)
	![](http://dzliving.com/SafeArea_1.png?imageView2/0/w/400)
	![](http://dzliving.com/Device_0.jpg)
	</center>
	
	```
	- (BOOL)prefersHomeIndicatorAutoHidden {
		return YES;
	}
	```
	

[modalPresentationStyle 使用present后背景页面不隐藏](https://www.jianshu.com/p/af990d83815e)