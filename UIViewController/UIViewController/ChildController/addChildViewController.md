> /*
> 
> These two methods are public for container subclasses to call when transitioning between child controllers. If they are overridden, the overrides should ensure to call the super. The parent argument in both of these methods is nil when a child is being removed from its parent; otherwise it is equal to the new parent view controller.
> 
> addChildViewController: will call \[child willMoveToParentViewController:self\] before adding the child. However, it will not call didMoveToParentViewController:. It is expected that a container view controller subclass will make this call after a transition to the new child has completed or, in the case of no transition, immediately after the call to addChildViewController:. Similarly, removeFromParentViewController does not call \[self willMoveToParentViewController:nil\] before removing the child. This is also the responsibilty of the container subclass. Container subclasses will typically define a method that transitions to a new child by first calling addChildViewController:, then executing a transition which will add the new child's view into the view hierarchy of its parent, and finally will call didMoveToParentViewController:. Similarly, subclasses will typically define a method that removes a child in the reverse manner by first calling \[child willMoveToParentViewController:nil\].
> 
> */
> 
> \- (void)willMoveToParentViewController:(nullable UIViewController *)parent NS\_AVAILABLE\_IOS(5_0);
> 
> \- (void)didMoveToParentViewController:(nullable UIViewController *)parent NS\_AVAILABLE\_IOS(5_0);

使用：

```
[parentVC addChildViewController:childVC];
childVC.view.frame = parentVC.view.bounds;
[parentVC.view addSubview:childVC.view];
[childVC didMoveToParentViewController:parentVC];  // 添加（系统不会自动调用）

[childVC willMoveToParentViewController:nil];   // 移除
```

![](https://upload-images.jianshu.io/upload_images/5294842-4d8ffc311557697d.png)