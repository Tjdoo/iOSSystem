# UICollectionView

1. > SuctionTopLayout 吸顶效果

2. > CATransaction 处理 reloadData 时闪烁问题

3. > [UICollectionView cell 间距调整](https://www.jianshu.com/p/40914d5708af)

4. > 自定义界面

5. > reloadData 不执行

	调用 [collectionView reloadData]; 之后，numberOfItemsInSection: 被执行，但 cellForItemAtIndexPath: 没有执行。
 
	原因 1：reloadData 必须在主线程里调用，各个函数才会重新开始执行
	
	```
	dispatch_async(dispatch_get_main_queue(), ^{
	     [self.collectionView reloadData];
	});
	```
	
	
	
[iOS九宫格放大图片相册](https://www.jianshu.com/p/2e6e86be7699)