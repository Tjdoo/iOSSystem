# UITableView

1. 处理 headerSectionView、FooterSectionView 的颜色；
2. 增加 ListDataSource 类，从 controller 中抽出单类型 cell 的 UITableViewDataSource 协议；
3. reloadData 后滚动至某个位置；
4. 解决侧滑手势取消返回导致 tableView 发生偏移的问题；

	```
	self.extendedLayoutIncludesOpaqueBars = YES;
	```

5. 同时识别多个手势

	```
	- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
	{
	    return YES;
	}
```

6. 刷新单个 cell 时 UITableViewRowAnimationNone 还有动画

	```
	[UIView setAnimationsEnabled:NO];
	[self.tableView beginUpdates];
	[self.tableView reloadRowsAtIndexPaths:@[ indexPath ]
	                      withRowAnimation:UITableViewRowAnimationNone];
	[self.tableView endUpdates];
	[UIView setAnimationsEnabled:YES];
	```