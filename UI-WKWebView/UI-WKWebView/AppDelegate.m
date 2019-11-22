//
//  AppDelegate.m
//  UI-WKWebView
//
//  Created by CYKJ on 2019/7/8.
//  Copyright © 2019年 D. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [self setUserAgent];
    
    return YES;
}


/**
  *  @brief   全局修改 UserAgent
 
     Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36
 
 1、用户代理应用程序是 Mozilla 版本 5.0 或与之兼容的一种软件。
 2、操作系统是 OS X 版本 10.11.6（并且在Mac上运行）。
 3、客户端是 Chrome 版本 56.0.2924.87。
 4、客户端基于 Safari 版本 537.36。
 5、负责在此设备上显示内容的引擎是 AppleWebKit 版本 537.36（和 KHTML，一个开源布局引擎）。
 
     UserAgent可以做什么？
 
 1、检查浏览器或设备的功能，并根据结果加载不同的 CSS;
 2、将自定义 JavaScript 与另一个设备相比较;
 3、与桌面计算机相比，向手机发送完全不同的页面布局;
 4、根据用户代理语言偏好自动发送文档的正确翻译;
 5、根据用户的设备类型或其他因素向特定用户推送特惠优惠;
 6、收集有关访问者的统计信息，以告知我们的网页设计和内容制作流程，或者仅仅衡量谁访问我们的网站，以及来自哪些引荐来源。
  */
- (void)setUserAgent
{
    /*
            1、UA：把手机的一些信息传给 webView 加载的网页，网页内部根据不同信息做适配。http://www.cocoachina.com/bbs/read.php?tid-458534.html=
            2、Webview 以及 Webkit JavaScript 引擎，这两个都是单线程的，不能够在子线程中使用。所以，不要试图在子线程中获取 userAgent。https://yq.aliyun.com/articles/30758
            3、获取 userAgent 耗时间。
         */
    UIWebView * tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    // 取出 webView 的 userAgent
    NSString * userAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    // 向 userAgent 中添加自己需要的内容
    NSString * ua = [NSString stringWithFormat:@"%@\\%@", userAgent, @" / app Browser"];
    // 将字典内容注册到 NSUserDefaults 中
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : ua, @"User-Agent" : ua}];
}

@end
