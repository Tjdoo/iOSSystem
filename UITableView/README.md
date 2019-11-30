# UITableView

1. > 处理 headerSectionView、FooterSectionView 的颜色；

2. > 增加 ListDataSource 类，从 controller 中抽出单类型 cell 的 UITableViewDataSource 协议；

3. > reloadData 后滚动至某个位置；

4. > 解决侧滑手势取消返回导致 tableView 发生偏移的问题；

	```
	self.extendedLayoutIncludesOpaqueBars = YES;
	```

5. > 同时识别多个手势

	```
	- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
	{
	    return YES;
	}
```

6. > 刷新单个 cell 时 UITableViewRowAnimationNone 还有动画

	```
	// 禁止动画
	[UIView setAnimationsEnabled:NO];
	[self.tableView beginUpdates];
	[self.tableView reloadRowsAtIndexPaths:@[ indexPath ]
	                      withRowAnimation:UITableViewRowAnimationNone];
	[self.tableView endUpdates];
	[UIView setAnimationsEnabled:YES];
	
	// 或者
	[UIView performWithoutAnimation:^{

	}];
	```
	
7. > reloadRowsAtIndexPaths: 的问题

	变高的 cell 点击后，表格的内容高度会发生变化。使用 reloadRowsAtIndexPaths 会导致调用不同 cell 的 heightForRowAtIndexPath 来计算表格内容区的大小，这种情况下出现当前 cell 显示异常：虽然占了正确的高度，但是实际“内容区”很小。
	
	![](http://dzliving.com/reloadRowsAtIndexPaths.png)
	
	所以改为 reloadData。

	```
	- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
	{
		...
		
		[self.tableView reloadData];
//        [self.tableView beginUpdates];
//        [self.tableView reloadRowsAtIndexPaths:@[ indexPath ]
//                              withRowAnimation:UITableViewRowAnimationNone];
//        [self.tableView endUpdates];
	}
	```
	
8. > 按需加载 cell 图片

	系统代码：LazyImage
	
9. > contentInset 和 scrollIndicatorInsets

	![](https://upload-images.jianshu.io/upload_images/5294842-abb6ac12ed3fcc96.gif?imageMogr2/auto-orient/strip)