//
//  WKWebViewCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/6/29.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "WKWebViewCtrl.h"
#import <WebKit/WebKit.h>    //导入WKWebView需要的类库
//http://blog.csdn.net/li_yangyang_li/article/details/50611963
//http://blog.csdn.net/li_yangyang_li/article/details/50989354
//http://blog.csdn.net/li_yangyang_li/article/details/50989370   WKWebView属性详解


@interface WKWebViewCtrl ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView              * webView;
@property (nonatomic, strong) WKWebViewConfiguration * config;
@property (nonatomic, strong) UIProgressView         * progressView;

@end



@implementation WKWebViewCtrl


#pragma mark -- lazyload
- (UIProgressView *)progressView {
    
    if (!_progressView) {
        
        _progressView = [[UIProgressView alloc]init];//WithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = [UIScreen mainScreen].bounds;
        _progressView.backgroundColor = [UIColor redColor];
        [self.view addSubview:_progressView];
    }
    
    return _progressView;
}


- (WKWebView *)webView {
    
    if (!_webView) {
        
        _webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:self.config];
        [self.view addSubview:_webView];
        
        _webView.navigationDelegate =  self;// 导航代理
        _webView.UIDelegate = self;// 与webview UI交互代理
        [self addKVO];// 添加KVO监听
        [self progressView];
        _webView.allowsBackForwardNavigationGestures = YES;//打开左划回退功能
    }
    
    return _webView;
}


- (WKWebViewConfiguration *)config {
    
    if (!_config) {
        
        _config = [[WKWebViewConfiguration alloc] init];
        
        //WKPreferences偏好设置
        _config.preferences.minimumFontSize                       = 10; // 默认为0
        _config.preferences.javaScriptEnabled                     = YES;// 默认认为YES
        _config.preferences.javaScriptCanOpenWindowsAutomatically = NO; // 在iOS上默认为NO，表示不能自动通过窗口打开
        
        //WKProcessPool内容处理池
        _config.processPool = [[WKProcessPool alloc] init];
    }
    
    return _config;
}


- (void)loadH5View {
    
    NSURL * path  = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:path]];
}


- (void)addKVO {
    
    // 添加KVO监听
    [self.webView addObserver:self
                   forKeyPath:@"loading"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"title"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
//    [self.webView removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self loadH5View];
    
    [self testFunny];

    
    //自动判断有无Nav存在，并重新进行顶部约束
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"后退" style:UIBarButtonItemStyleDone target:self action:@selector(goback)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"前进" style:UIBarButtonItemStyleDone target:self action:@selector(gofarward)];
}

#pragma mark -- UTF-8和字符串互转化
- (void)testFunny {
    
    //UTF-8转字符串
    //第一种，直接转
    NSString * utfString = @"%E6%96%B0%E9%B2%9C%E6%B0%B4%E6%9E%9C";
    NSString * strString = [utfString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"strString    = %@", strString);

    //第二种，利用webview解码
    UIWebView * web      = [[UIWebView alloc] init];
    NSString  * tsw      = @"%E4%B8%AD%E5%9B%BD";
    NSString  * sc       = [NSString stringWithFormat:@"decodeURIComponent('%@')", tsw];
    NSString  * st       = [web stringByEvaluatingJavaScriptFromString:sc];
    NSLog(@"st = %@", st);
    
    //字符串转UTF-8
    NSString * utfStr = [strString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"utfStr = %@", utfStr);

}


- (void)goback {
    
    if ([self.webView canGoBack]) {
        
        [self.webView goBack];
    }
}

- (void)gofarward {
    
    if ([self.webView canGoForward]) {
        
        [self.webView goForward];
    }
}


#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([message.name isEqualToString:@"AppModel"]) {
        
        //打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray, NSDictionary, and NSNull类型
        NSLog(@"%@", message.body);
        
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"loading"]) {
        
        NSLog(@"loading");
    }
    else if ([keyPath isEqualToString:@"title"]) {
        
        self.title = self.webView.title;
    }
    else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        NSLog(@"progress: %f", self.webView.estimatedProgress);
        self.progressView.progress = self.webView.estimatedProgress;
    }
    
    // 加载完成
    if (!self.webView.loading) {
        
        // 手动调用JS代码
        // 每次页面完成都弹出来，大家可以在测试时再打开
        NSString * js = @"callJsAlert()";
        [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            
            NSLog(@"response: %@ error: %@", response, error);
            NSLog(@"call js alert by native");
        }];
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.progressView.alpha = 0;
        }];
    }
    
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString * hostname = navigationAction.request.URL.host.lowercaseString;
    
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated
        && ![hostname containsString:@".baidu.com"]) {
        
        // 对于跨域，需要手动跳转
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        
        // 不允许web内跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else {
        
        self.progressView.alpha = 1.0;
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    decisionHandler(WKNavigationResponsePolicyAllow);
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    NSLog(@"%s", __func__);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    
    NSLog(@"%s", __FUNCTION__);
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - WKUIDelegate
- (void)webViewDidClose:(WKWebView *)webView {
    
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    NSLog(@"%s", __FUNCTION__);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert" message:@"JS调用alert" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
    NSLog(@"%@", message);
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    
    NSLog(@"%s", __FUNCTION__);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"confirm" message:@"JS调用confirm" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(NO);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
    NSLog(@"%@", message);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", prompt);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"textinput" message:@"JS调用输入框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end
