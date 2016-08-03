//
//  WebViewController.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/18.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "WebViewController.h"


@interface WebViewController () <UIWebViewDelegate, NJKWebViewProgressDelegate>

@property (nonatomic, strong) UIWebView                 * webView;
@property (nonatomic, strong) NJKWebViewProgressView    * progressView;
@property (nonatomic, strong) NJKWebViewProgress        * progressProxy;
@property (nonatomic, strong) KVNProgressConfiguration  * basicConfiguration;

@end



//很多时候我们得到h5界面并不能很好的适配，http://www.tuicool.com/articles/FNrIbmi

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self webView];
    NSLog(@"%s", __func__);
    [self button];
    
    [self configureProgressView];
    
    self.basicConfiguration = [KVNProgressConfiguration defaultConfiguration];
    
}

#pragma mark -- 设置进度条
- (void)configureProgressView {
    
    
    /*
    //设置进度条位置和高度
    self.progressProxy = [[NJKWebViewProgress alloc] init];
    CGFloat progressBarHeight = 2.f;//进度条的高
    
    //设置进度条代理
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    //进度条的位置
    CGRect barFrame = CGRectMake(0, 50, 375, progressBarHeight);
    self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;//自动调整子控件与父控件中间的位置，宽高。
    
   */
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    
    CGRect navBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0,
                                 navBounds.size.height - 2,
                                 navBounds.size.width,
                                 2);
    NSLog(@"Rect = %@", NSStringFromCGRect(barFrame));
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_progressView setProgress:0 animated:YES];
//    [self loadBidu];
    [self.navigationController.navigationBar addSubview:_progressView];
    
}


-(void)loadBidu {
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.baidu.com/"]];
    [_webView loadRequest:req];
}
#pragma mark -- NJKWebView的代理方法
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    
    [self.progressView setProgress:progress animated:YES];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"title = %@", self.title);
}


#pragma mark -- 在具体需要隐藏和显示导航栏的controller中实现导航栏的显示或隐藏：
- (void)viewWillAppear:(BOOL)animated {
    
//    [self.navigationController setNavigationBarHidden:YES animated:TRUE];
    //    [self.navigationController setToolbarHidden:YES animated:TRUE];
    
    [super viewWillAppear:animated];
    [self.view addSubview:_progressView];
    
    [KVNProgress setConfiguration:self.basicConfiguration];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
}

#pragma mark -- 后退前进按钮
- (void)button {
    
    UIButton * goBackBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, hSrceem-60, 50, 50)];
    goBackBtn.backgroundColor = [UIColor redColor];
    [goBackBtn setTitle:@"后退" forState:UIControlStateNormal];
    [goBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goBackBtn addTarget:self action:@selector(goBackClick:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * goForwardBtn = [[UIButton alloc]initWithFrame:CGRectMake(wSrceem-50, hSrceem-60, 50, 50)];
    goForwardBtn.backgroundColor = [UIColor blueColor];
    [goForwardBtn setTitle:@"前进" forState:UIControlStateNormal];
    [goForwardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goForwardBtn addTarget:self action:@selector(goForwardClick:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:goBackBtn];
//    goBackBtn.enabled = _webView.canGoBack;
    
    [self.view addSubview:goForwardBtn];
//    goForwardBtn.enabled = _webView.canGoForward;
    
//    //还有另外俩功能
//    [_webView reload];
//    [_webView stopLoading];
    
}

- (void)goBackClick:(UIButton *)sender {
    
    NSLog(@"%s", __func__);
    [_webView goBack];
    
    
}

- (void)goForwardClick:(UIButton *)sender {
    
    NSLog(@"%s", __func__);
    [_webView goForward];
    
}

#pragma mark -- webViewDelegate

//是否允许UIWebView加载请求的方法,当返回值为NO，表示不允许加载此请求
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}


//当WebView已经开始加载一个请求后，得到通知。
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    NSLog(@"%s", __func__);
    
    //开始加载时候显示进度视图
    self.basicConfiguration.backgroundType = KVNProgressBackgroundTypeSolid;//设置进度视图的背景风格
    [KVNProgress show];
}


//当WebView完成加载一个请求之后，得到通知。
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"%s", __func__);
    
    //加载完毕以后移除视图
    [KVNProgress dismiss];
}


//当WebView在请求加载中发生错误时，得到通知。提供一个NSSError对象，以标识所发生错误类型。
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    
    NSLog(@"%s", __func__);
}


#pragma mark -- 懒加载
- (UIWebView *)webView {
    
    if (!_webView) {
        
        CGRect bounds = CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height - 100);
        _webView = [[UIWebView alloc]initWithFrame:bounds];
        
        [self setWebViewWithProperties];
        [self reloadNetWorkSourceWithUrl:@"1"];
//        [self reloadLoctionSourceWithUrl:@"1"];
        [self displayWebView];
        
        //设置代理
        self.webView.delegate = self;
    }
    
    return _webView;
}


#pragma mark -- 属性设置
- (void)setWebViewWithProperties {
    
    _webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    [_webView setUserInteractionEnabled:YES];//是否支持交互
    
}


#pragma mark -- 加载网络资源
- (void)reloadNetWorkSourceWithUrl:(NSString *)url {
    
    NSURL *netUrl = [NSURL URLWithString:@"http://www.hcios.com"];//创建url（统一资源定位符，互联网标准资源的地址）
    NSURLRequest *urlRequest = [[NSURLRequest alloc]initWithURL:netUrl];//创建NSURLRequest
    [_webView loadRequest:urlRequest];//加载
    
}

#pragma mark -- 加载本地资源
- (void)reloadLoctionSourceWithUrl:(NSString *)url {
    
    NSString* filePath = [[NSBundle mainBundle]pathForResource:@"1" ofType:@"jpg"];//本地资源路径
    NSURL* localUrl = [NSURL fileURLWithPath:filePath];//创建本地资源URL
    NSURLRequest* request = [NSURLRequest requestWithURL:localUrl];//创建NSURLRequest
    [_webView loadRequest:request];//加载
    
}


#pragma mark -- 显示webview
- (void)displayWebView {
    
    [self.view addSubview:_webView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
