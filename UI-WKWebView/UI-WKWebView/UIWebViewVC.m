//
//  UIWebViewVC.m
//  UI-WKWebView
//
//  Created by CYKJ on 2019/12/12.
//  Copyright © 2019 D. All rights reserved.


#import "UIWebViewVC.h"
#import <JavaScriptCore/JSContext.h>
#import <JavaScriptCore/JSValue.h>
#import <JavaScriptCore/JSExport.h>



@protocol JSObjcDelegate <JSExport>

- (void)uiWebViewCallCamera;
- (void)uiWebViewCallShare:(NSString *)shareString;

@end



@interface UIWebViewVC () <UIWebViewDelegate, JSObjcDelegate>

/*
 JSContext：给 JavaScript 提供运行的上下文环境
 JSValue：JavaScript 和 Objective-C 数据和方法的桥梁
 JSManagedValue：管理数据和方法的类
 JSVirtualMachine：处理线程相关，使用较少
 JSExport：这是一个协议，如果采用协议的方法交互，自己定义的协议必须遵守此协议
 */
@property (nonatomic, strong) JSContext * jsContext;
@property (nonatomic, strong) UIWebView * webview;

@end


@implementation UIWebViewVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webview.delegate = self;
    [self.view addSubview:self.webview];
    
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"]]]];
    
    self.jsContext = [self.webview valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

    // 在 webView 加载完毕的时候获取 JavaScript 运行的上下文环境
    if (self.jsContext) {
        // 注入桥梁对象名
        self.jsContext[@"Objc"] = self;  // 方法调用者
        self.jsContext.exceptionHandler = ^(JSContext * context,
                                            JSValue * exceptionValue) {
            context.exception = exceptionValue;
            NSLog(@"异常信息：%@", exceptionValue);
        };
    }
}

/**
  *  @brief   js 调用 oc 后，oc 可以回调 js
  */
- (void)uiWebViewCallCamera
{
    NSLog(@"%s", __func__);
    
    // 获取到照片之后在回调  js 的方法 picCallback 把图片传出去
    JSValue * picCallback = self.jsContext[@"picCallback"];
    [picCallback callWithArguments:@[@"photos"]];
}

- (void)uiWebViewCallShare:(NSString *)shareString
{
    NSLog(@"%s : %@", __func__, shareString);
    
    // 分享成功回调 js 的方法 shareCallback
    JSValue * shareCallback = self.jsContext[@"shareCallback"];
    [shareCallback callWithArguments:nil];
}
                              
                              
#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 在 webView 加载完毕的时候获取 JavaScript 运行的上下文环境
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 注入桥梁对象名
    self.jsContext[@"Objc"] = self;  // 方法调用者
    self.jsContext.exceptionHandler = ^(JSContext * context,
                                        JSValue * exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

@end
