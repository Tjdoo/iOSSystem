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
    // Override point for customization after application launch.
    return YES;
}

- (void)ss
{
    /*
            1、UA：把手机的一些信息传给 webView 加载的网页，网页内部根据不同信息做适配。http://www.cocoachina.com/bbs/read.php?tid-458534.html=
            2、Webview 以及 Webkit JavaScript 引擎，这两个都是单线程的，不能够在子线程中使用。所以，不要试图在子线程中获取 userAgent。https://yq.aliyun.com/articles/30758
            3、获取 userAgent 耗时间。
         */
    UIWebView * tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString * userAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString * ua = [NSString stringWithFormat:@"%@\\%@", userAgent, @" / app Browser"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : ua, @"User-Agent" : ua}];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
