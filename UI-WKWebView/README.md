# UIWebView & WKWebView

1. `Nitro` 就是 Safari 的 JavaScript 引擎，WKWebView 使用 Nitro 引擎；
2. WKWebView 不支持 JavaScriptCore 的方式，但提供 message handler 的方式为 JavaScript 与 Native 通信；

WKWebview 的优点：

1. 更多的支持 HTML5 的特性
2. 官方宣称的高达 60fps 的滚动刷新率以及内置手势
3. Safari 相同的 JavaScript 引擎，且允许 JavaScript 的 Nitro 库加载并使用（UIWebView 中限制）；
4. 将 UIWebViewDelegate 与 UIWebView 拆分成了 14 类与 3个协议
5. 占用更少的内存，在性能、稳定性、功能方面有很大提升（最直观的体现就是加载网页是占用的内存，模拟器加载百度与开源中国网站时，WKWebView 占用 23M，而 UIWebView 占用 85M）；

	另外用的比较多的，增加加载进度属性：`estimatedProgress`。

<hr>

JS 调用 OC 

1. JavaScriptCore
2. 协议拦截
3. WKWebview 代理方法

⚠️ 如果 WKScriptMessageHandler 回调没有被调用，需要检查：

1. 是否设置 [ucc addScriptMessageHandler:self name:@""];
2. 检查 h5 是否写错


	```
	<button type="button" onclick=callShare()>clicked to share</button>
	<input type="button" value="Share" onclick="callShare()">

	<script>
		function callShare () {
			window.webkit.messageHandlers.share.postMessage("");
		}
		
		var callShare = function() {
			window.webkit.messageHandlers.share.postMessage("");
   		}
	</script>
	```

OC 调用 JS

1. evaluateJavaScript: 或者 stringByEvaluatingJavaScriptFromString: 方法


<hr>

* [WKWebView的使用](https://www.cnblogs.com/demodashi/p/9443213.html)
* [iOS 如何设置UserAgent](https://www.jianshu.com/p/651cbbe1f99a)
* [WKWebView填坑之----加载沙盒图片和音视频文件](https://www.jianshu.com/p/db6386fada10)
* [iOS WKWebView使用总结](https://www.jianshu.com/p/20cfd4f8c4ff)
* [WKWebView的使用和各种坑的解决方法（OC＋Swift）](https://www.jianshu.com/p/403853b63537)
* [Objective-C与JavaScript交互的那些事](https://www.jianshu.com/p/f896d73c670a)
* [Objective-C与JavaScript交互的那些事(续)](https://www.jianshu.com/p/939db6215436)
* [WKWebView使用及注意点(keng)](https://www.jianshu.com/p/9513d101e582)
* [iOS webview加载时序和缓存问题总结](https://www.cnblogs.com/lolDragon/p/6774509.html)
<hr>


* [iOS与JS交互之UIWebView-协议拦截](https://www.jianshu.com/p/f94448235209)
* [iOS与JS交互之UIWebView-JavaScriptCore框架](https://www.jianshu.com/p/5d9e2e47f226)
* [iOS与JS交互之UIWebView-JSExport协议](https://www.jianshu.com/p/f4ec947f0721)
* [iOS与JS交互之WKWebView-协议拦截](https://www.jianshu.com/p/e23aa25d7514)
* [iOS与JS交互之WKWebView-WKScriptMessageHandler协议](https://www.jianshu.com/p/905b40e609e2)
* [iOS与JS交互之WKWebView-WKUIDelegate协议](https://www.jianshu.com/p/7a1fceae5880)