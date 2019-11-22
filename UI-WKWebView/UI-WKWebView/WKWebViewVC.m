//
//  WKWebViewVC.m
//  UI-WKWebView
//
//  Created by CYKJ on 2019/11/22.
//  Copyright © 2019年 D. All rights reserved.


#import "WKWebViewVC.h"
#import <WebKit/WebKit.h>


@interface WKWebViewVC () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, weak) WKWebView * wkWebView;

@end


@implementation WKWebViewVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WKUserContentController * ucc = [[WKUserContentController alloc] init];
    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = ucc;
    if (@available(iOS 9.0, *)) {
        config.allowsInlineMediaPlayback = NO;  // no - 网页中内嵌的视频就无法正常播放。（没效果？？）
    }
    
    WKWebView * wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    wkWebView.navigationDelegate = self;
    wkWebView.UIDelegate = self;
    wkWebView.opaque = YES;
    wkWebView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    wkWebView.scrollView.backgroundColor = UIColor.whiteColor;
    wkWebView.allowsBackForwardNavigationGestures = NO;  // 不支持右滑返回手势
    [self.view addSubview:wkWebView];
    self.wkWebView = wkWebView;
    
    [self __userAgent];
    
    // 监听进度
    [wkWebView addObserver:self
                forKeyPath:@"estimatedProgress"
                   options:NSKeyValueObservingOptionNew
                   context:nil];

    [self __loadRequest];
    [self __addExtraView];
}

- (void)__userAgent
{
    // 全局 userAgent
    if (@available(iOS 9.0, *)) {
        NSLog(@"userAgent = %@", self.wkWebView.configuration.applicationNameForUserAgent); // 这里的内容比 navigator.userAgent 的少很多
    }
    [self.wkWebView evaluateJavaScript:@"navigator.userAgent"
                     completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                         NSLog(@"%@", (NSString *)result);
                     }];
    
    // 局部自定义 userAgent
    if (@available(iOS 9.0, *)) {
//        self.wkWebView.customUserAgent = @"iOS UI-WKWebView";  // 设置后，www.baidu.com 页面加载不出来
    }
}

- (void)__loadRequest
{
    // 远程地址
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    // 本地文件
//    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
//    NSString * appHtml = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    NSURL * baseURL = [NSURL fileURLWithPath:filePath];
//    [self.wkWebView loadHTMLString:appHtml baseURL:baseURL];
}

- (void)__addExtraView
{
    CGFloat height = 100;
    UIView * csView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, height)];
    csView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.3];
    [self.wkWebView.scrollView addSubview:csView];
    
    // 添加一个额外的 div
    NSString * js = [NSString stringWithFormat:@"\
                     var appendDiv = document.getElementById(\"AppAppendDIV\");\
                     if (appendDiv) {\
                     appendDiv.style.height = %@+\"px\";\
                     } else {\
                     var appendDiv = document.createElement(\"div\");\
                     appendDiv.setAttribute(\"id\",\"AppAppendDIV\");\
                     appendDiv.style.width=%@+\"px\";\
                     appendDiv.style.height=%@+\"px\";\
                     document.body.appendChild(appendDiv);\
                     }\
                     ", @(height), @(self.wkWebView.scrollView.contentSize.width), @(height)];
    
    [self.wkWebView evaluateJavaScript:js completionHandler:nil];
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"进度：%.2f", [change[NSKeyValueChangeNewKey] floatValue]);
}


#pragma mark - WKNavigationDelegate
/// 页面加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    self.title = webView.title;
}

/// 准备加载页面
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}

/// 内容开始加载
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}

/// 加载错误
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"Fail error: %@", error);
}

/// 判断链接是否允许跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler(WKNavigationActionPolicyAllow);
}

/// 响应后决定是否允许跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

/// 重定向
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    
}

/// 权限认证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential * credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }
        else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    }
    else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}


#pragma mark - WKUIDelegate
/**
  *  @brief   Alert
  */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil
                                                                      message:message ? : @""
                                                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ensureAction = [UIAlertAction actionWithTitle:@"确认"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              completionHandler();
                                                          }];
    
    [alertVC addAction:ensureAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

/**
  *  @brief   comfirm   确认返回YES， 取消返回NO
  */
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示"
                                                                      message:message?:@""
                                                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              completionHandler(NO);
                                                          }];
    UIAlertAction * ensureAction = [UIAlertAction actionWithTitle:@"确认"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              completionHandler(YES);
                                                          }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:ensureAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

/**
 *  @brief   prompt   默认需要有一个输入框一个按钮，点击确认按钮回传输入值
 *  @param   completionHandler   只有一个参数，如果有多个输入框，需要将多个输入框中的值通过某种方式拼接成一个字符串回传
 */
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:prompt
                                                                      message:@""
                                                               preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    
    UIAlertAction * ensureAction = [UIAlertAction actionWithTitle:@"完成"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              completionHandler(alertVC.textFields[0].text?:@"");
                                                          }];
    
    [alertVC addAction:ensureAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
