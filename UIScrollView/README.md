# UIScrollView

1. > 判断是否是手指滑动

2. > [iOS 侧滑返回手势与Scrollview冲突的解决办法](https://www.jianshu.com/p/419e3b081e5a)

3. > View controller-based status bar appearance 

	在 info.plist 里面设置 View controller-based status bar appearance = NO，当浏览大图设置 statusBarHidden = YES，会导致页面中的滚动视图发生滚动，触发 layout。堆栈信息：
	
	```
	   frame #1: 0x0000000105cf6feb Foundation`NSKeyValueNotifyObserver + 332
    frame #2: 0x0000000105cfa696 Foundation`NSKeyValueDidChange + 489
    frame #3: 0x0000000105cf9f85 Foundation`-[NSObject(NSKeyValueObservingPrivate) _changeValueForKeys:count:maybeOldValuesDict:maybeNewValuesDict:usingBlock:] + 790
    frame #4: 0x0000000105cfa8ad Foundation`-[NSObject(NSKeyValueObservingPrivate) _changeValueForKey:key:key:usingBlock:] + 68
    frame #5: 0x0000000105cf56f3 Foundation`_NSSetPointValueAndNotify + 281
    frame #6: 0x00000001132c93f5 UIKitCore`-[UIScrollView(UIScrollViewInternal) _adjustContentOffsetIfNecessary] + 53
    frame #7: 0x00000001132a5c9f UIKitCore`-[UIScrollView setBounds:] + 1108
    frame #8: 0x00000001130742ae UIKitCore`-[UITableView setBounds:] + 234
    frame #9: 0x0000000113313dd4 UIKitCore`-[UIView(Geometry) _applyISEngineLayoutValuesToBoundsOnly:] + 563
    frame #10: 0x00000001133140d0 UIKitCore`-[UIView(Geometry) _resizeWithOldSuperviewSize:] + 125
    frame #11: 0x0000000113251c60 UIKitCore`-[UIScrollView(_UIOldConstraintBasedLayoutSupport) _resizeWithOldSuperviewSize:] + 46
    frame #12: 0x00000001090f6c9c CoreFoundation`-[__NSArrayM enumerateObjectsWithOptions:usingBlock:] + 476
    frame #13: 0x0000000113312b7d UIKitCore`-[UIView(Geometry) resizeSubviewsWithOldSize:] + 175
    frame #14: 0x0000000113260bab UIKitCore`-[UIView(AdditionalLayoutSupport) _is_layout] + 201
    frame #15: 0x000000011331bc66 UIKitCore`-[UIView(Hierarchy) _updateConstraintsAsNecessaryAndApplyLayoutFromEngine] + 1002
    frame #16: 0x0000000113330795 UIKitCore`-[UIView(CALayerDelegate) layoutSublayersOfLayer:] + 1441
    frame #17: 0x0000000106c4ab19 QuartzCore`-[CALayer layoutSublayers] + 175
    frame #18: 0x0000000106c4f9d3 QuartzCore`CA::Layer::layout_if_needed(CA::Transaction*) + 395
    frame #19: 0x000000011331b077 UIKitCore`-[UIView(Hierarchy) layoutBelowIfNeeded] + 1429
    frame #20: 0x0000000112786fc6 UIKitCore`-[UINavigationController _layoutViewController:] + 1758
    frame #21: 0x0000000112780a25 UIKitCore`-[UINavigationController _layoutTopViewController] + 223
    frame #22: 0x0000000112782362 UIKitCore`-[UINavigationController _computeAndApplyScrollContentInsetDeltaForViewController:] + 323
    frame #23: 0x0000000112786996 UIKitCore`-[UINavigationController _layoutViewController:] + 174
    frame #24: 0x0000000112780a25 UIKitCore`-[UINavigationController _layoutTopViewController] + 223
    frame #25: 0x0000000112776187 UIKitCore`__105-[UINavigationController _repositionPaletteWithNavigationBarHidden:duration:shouldUpdateNavigationItems:]_block_invoke + 727
    frame #26: 0x0000000112775e80 UIKitCore`-[UINavigationController _repositionPaletteWithNavigationBarHidden:duration:shouldUpdateNavigationItems:] + 308
    frame #27: 0x000000011277fd49 UIKitCore`-[UINavigationController _updateBarsForCurrentInterfaceOrientationAndForceBarLayout:] + 174
    frame #28: 0x0000000112829308 UIKitCore`-[UIViewController window:statusBarWillChangeFromHeight:toHeight:windowSizedViewController:] + 2005
    frame #29: 0x000000011282959c UIKitCore`-[UIViewController window:statusBarWillChangeFromHeight:toHeight:] + 147
    frame #30: 0x0000000112e8f9d0 UIKitCore`-[UIWindow handleStatusBarChangeFromHeight:toHeight:] + 389
    frame #31: 0x0000000112e9395a UIKitCore`+[UIWindow _noteStatusBarHeightChanged:oldHeight:forAutolayoutRootViewsOnly:] + 740
    frame #32: 0x0000000112e49ba1 UIKitCore`__79-[UIApplication _setStatusBarHidden:animationParameters:changeApplicationFlag:]_block_invoke + 139
    frame #33: 0x0000000113323bf2 UIKitCore`+[UIView(UIViewAnimationWithBlocks) _setupAnimationWithDuration:delay:view:options:factory:animations:start:animationStateGenerator:completion:] + 558
    frame #34: 0x000000011332413e UIKitCore`+[UIView(UIViewAnimationWithBlocks) animateWithDuration:animations:completion:] + 86
    frame #35: 0x0000000112e4988c UIKitCore`-[UIApplication _setStatusBarHidden:animationParameters:changeApplicationFlag:] + 776
    frame #36: 0x0000000112e49e8b UIKitCore`-[UIApplication setStatusBarHidden:withAnimation:] + 124
    frame #37: 0x0000000104591e2d CiYunDoctor`__32-[DZoneScrollView setFirstRect:]_block_invoke.184(.block_descriptor=0x00000001049fec68, finished=YES) at DZoneScrollView.m:248
    frame #38: 0x0000000113323753 UIKitCore`-[UIViewAnimationBlockDelegate _didEndBlockAnimation:finished:context:] + 847
    frame #39: 0x00000001132f634d UIKitCore`-[UIViewAnimationState sendDelegateAnimationDidStop:finished:] + 343
    frame #40: 0x00000001132f698d UIKitCore`-[UIViewAnimationState animationDidStop:finished:] + 293
    frame #41: 0x0000000106c5ccad QuartzCore`CA::Layer::run_animation_callbacks(void*) + 323
    frame #42: 0x000000010b0f4602 libdispatch.dylib`_dispatch_client_callout + 8
    frame #43: 0x000000010b10199a libdispatch.dylib`_dispatch_main_queue_callback_4CF + 1541
    frame #44: 0x00000001091333e9 CoreFoundation`__CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__ + 9
    frame #45: 0x000000010912da76 CoreFoundation`__CFRunLoopRun + 2342
    frame #46: 0x000000010912ce11 CoreFoundation`CFRunLoopRunSpecific + 625
    frame #47: 0x000000010f47f1dd GraphicsServices`GSEventRunModal + 62
    frame #48: 0x0000000112e4681d UIKitCore`UIApplicationMain + 140
    frame #49: 0x0000000104580320 CiYunDoctor`main(argc=1, argv=0x00007ffeeb7b0fe0) at main.m:29
    frame #50: 0x000000010b16a575 libdyld.dylib`start + 1
	```