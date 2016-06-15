//
//  QRcodeWebViewCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/6/8.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "QRcodeWebViewCtrl.h"

@interface QRcodeWebViewCtrl ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView                 * webView;

@end

@implementation QRcodeWebViewCtrl

#pragma mark -- 懒加载
- (UIWebView *)webView {
    
    if (!_webView) {
        
        CGRect bounds = [UIScreen mainScreen].bounds;//CGRectMake(0,0, wSrceem, hSrceem);
        _webView = [[UIWebView alloc]initWithFrame:bounds];
        [self.view addSubview:_webView];
        
        //设置代理
        self.webView.delegate = self;
    }
    
    return _webView;
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self loadWebView];
    
}


- (void)loadWebView {
    
    NSURL *netUrl = [NSURL URLWithString:self.urlString];//创建url（统一资源定位符，互联网标准资源的地址）
    NSURLRequest *urlRequest = [[NSURLRequest alloc]initWithURL:netUrl];//创建NSURLRequest
    [self.webView loadRequest:urlRequest];//加载
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}



@end
