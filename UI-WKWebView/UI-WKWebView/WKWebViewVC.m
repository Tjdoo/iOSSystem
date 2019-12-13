//
//  WKWebViewVC.m
//  UI-WKWebView
//
//  Created by CYKJ on 2019/11/22.
//  Copyright © 2019年 D. All rights reserved.


#import "WKWebViewVC.h"
#import <WebKit/WebKit.h>


/**
  *  @brief   处理循环引用
  */
@interface WeakProxy : NSProxy

@property (nonatomic, weak) id target;

- (instancetype)initWithTarget:(id)target;

@end

@implementation WeakProxy

- (instancetype)initWithTarget:(id)target
{
    WeakProxy * wp = [WeakProxy alloc];
    wp.target = target;
    return wp;
}

@end



@interface WKWebViewVC () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WeakProxy * weakProxy;
@property (nonatomic, weak) WKWebView * wkWebView;

@end


@implementation WKWebViewVC

- (void)dealloc
{
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"wkWebViewCallCamera"];
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"wkWebViewCallShare"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.weakProxy = [[WeakProxy alloc] initWithTarget:self];
    
    // 这个类主要用来做 native 与 JavaScript 的交互管理
    WKUserContentController * ucc = [[WKUserContentController alloc] init];
    // 注册一个 name 为 wkWebViewCallCamera 的 js 方法，设置处理接收 JS 方法的代理
    [ucc addScriptMessageHandler:_weakProxy.target name:@"wkWebViewCallCamera"];
    [ucc addScriptMessageHandler:_weakProxy.target name:@"wkWebViewCallShare"];
    
    // 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc]init];
    // 最小字体大小。当将 javaScriptEnabled 属性设置为 NO 时，可以看到明显的效果
    preference.minimumFontSize = 0;
    // 设置是否支持 javaScript  默认是支持的
    preference.javaScriptEnabled = YES;
    // 在 iOS 上默认为 NO，表示是否允许不经过用户交互由 javaScript 自动打开窗口
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    
    // 网页配置对象
    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = ucc;
    config.preferences = preference;
    if (@available(iOS 9.0, *)) {
        config.allowsInlineMediaPlayback = NO;  // 使用 h5 的视频播放器在线播放，还是使用原生播放器全屏播放
        config.applicationNameForUserAgent = @"ChinaDailyForiPad"; // 设置请求的 User-Agent 信息中应用程序名称
        config.requiresUserActionForMediaPlayback = YES; // 设置视频是否需要用户手动播放。设置为 NO 则会允许自动播放
        config.allowsPictureInPictureMediaPlayback = YES;  // 设置是否允许画中画技术，在特定设备上有效
    }
    
    WKWebView * wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    // 导航代理
    wkWebView.navigationDelegate = self;
    // UI 代理
    wkWebView.UIDelegate = self;
    wkWebView.opaque = YES;
    wkWebView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    wkWebView.scrollView.backgroundColor = UIColor.whiteColor;
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    wkWebView.allowsBackForwardNavigationGestures = NO;  // 不支持右滑返回手势
    [self.view addSubview:wkWebView];
    self.wkWebView = wkWebView;
    
    // 可返回的页面列表，存储已打开过的网页
//    WKBackForwardList * backForwardList = [wkWebView backForwardList];
    // 页面后退
//    [wkWebView goBack];
    // 页面前进
//    [wkWebView goForward];
    // 刷新当前页面
//    [wkWebView reload];
    
    [self __userAgent];
    
    // 监听进度
    [wkWebView addObserver:self
                forKeyPath:@"estimatedProgress"
                   options:NSKeyValueObservingOptionNew
                   context:nil];

    [self __loadRequest];
//    [self __addExtraView];
    [self __insertJS];
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
//    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    // 本地文件
//    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
//    NSString * appHtml = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    NSURL * baseURL = [NSURL fileURLWithPath:filePath];
//    [self.wkWebView loadHTMLString:appHtml baseURL:baseURL];
    
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"]]]];
}

/**
  *  @brief   添加额外的区域
  */
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

/**
  *  @brief   注入 js
  */
- (void)__insertJS
{
    // 以下代码适配文本大小，由 UIWebView 换为 WKWebView 后，会发现字体小了很多，这应该是 WKWebView 与 html 的兼容问题，解决办法是修改原网页，要么我们手动注入  JS
    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    // 用于进行  JavaScript 注入
    WKUserScript * wkUScript = [[WKUserScript alloc] initWithSource:jSString
                                                      injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                                   forMainFrameOnly:YES];
    [self.wkWebView.configuration.userContentController addUserScript:wkUScript];
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


#pragma mark - WKScriptMessageHandler
/**
  *  @brief   处理监听 JavaScript 方法，从而调用原生 OC 方法，和 WKUserContentController 搭配使用。
  */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //用 message.body 获得 JS 传出的参数体
    NSLog(@"param = %@", message.body);
    
    if ([message.name isEqualToString:@"wkWebViewCallShare"]) {
        NSLog(@"分享");
    }
    else if ([message.name isEqualToString:@"wkWebViewCallCamera"]) {
        NSLog(@"照相机");
    }
}


#pragma mark - WKUIDelegate
/**
 *  @brief   web界面中有弹出警告框时调用
 *
 *  @param   webView   实现该代理的webview
 *  @param   message  警告框中的内容
 *  @param   completionHandler   警告框消失调用
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
