## 导航控制器

1. > 右滑返回手势失效？

	主要是因为自定义了页面中 navigationItem 的 leftBarButtonItem 或leftBarButtonItems，或是 self.navigationItem.hidesBackButton = YES; 隐藏了返回按钮，亦或是 self.navigationItem.leftItemsSupplementBackButton = NO;
	
	```oc
	UIViewController * b = [self.storyboard instantiateViewControllerWithIdentifier:@"BViewController_SBID"];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 33)];
    label.backgroundColor = [UIColor redColor];
    label.text = @"A页面";
    b.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:label];
    b.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:b animated:YES];
	```
	
	* ``backBarButtonItem``   当前页面设置，在次级页面 navigationItem 上展示
	* ``leftBarButtonItem``   当前界面设置，当前界面展示
	* ``rightBarButtonItem``  当前界面设置，当前界面展示
	* ``leftItemsSupplementBackButton``  控制 backBarButtonItem 是否被 leftBarButtonItem “覆盖”

	系统默认情况下 leftBarButtonItem 的优先级是要高于 backBarButtonItem。当存在leftBarButtonItem 时，自动忽略 backBarButtonItem，达到重写 backBarButtonItem 的目的，但会<font color=#cc0000>造成右滑返回手势的响应代理从当前页面被覆盖性移除</font>。
	
	处理方案：
	> ①、navigationController 中在手势代理中处理
	> ②、自定义 backBarButton
	> ③、UIScrollView 处于第一页时，处理多手势响应
	
	[iOS右滑返回手势深度全解和最佳实施方案](http://www.cocoachina.com/articles/23269)
	
2. > 设置 navigationbar.translucent = NO 时，视图控制器整体下移

	self.extendedLayoutIncludesOpaqueBars = YES; 或者 xib、storyboard 中勾选 Under Opaque Bars。
	
    self.edgesForExtendedLayout = UIRectEdgeTop;  自动处理导航栏 64pt

3. > translucent

	[iOS translucent引发的那点小事](https://www.jianshu.com/p/a75632bab095)
	[鬼魅的“64边距”——translucent属性](https://www.jianshu.com/p/930643270455)
	
4. > [iOS 更改导航栏背景颜色&透明度](https://www.jianshu.com/p/a08f6c727a43)

5. > [iOS 状态栏的隐藏和显示](https://www.jianshu.com/p/4b2aa09bee06)