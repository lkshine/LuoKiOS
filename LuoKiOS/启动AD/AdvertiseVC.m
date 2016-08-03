//
//  AdvertiseVC.m
//  LuoKiOS
//
//  Created by lkshine on 16/7/31.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "AdvertiseVC.h"
#import <WebKit/WebKit.h>


@interface AdvertiseVC ()

//使用WKWeb比以前的UIWeb提速不少哟
@property (nonatomic, strong) WKWebView * adWebView;

@end

/*
 参照http://www.cocoachina.com/ios/20160614/16671.html
 
 心得要点，在appdelegate里做好注册，再在app首页控制内做好监听，以便push广告页【心细的话会发现，其实launchimage加载完后就加载了首页，只不过被我的广告view给挡住了，所以注意push使用的对象就行了】
 */

@implementation AdvertiseVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"点击进入广告链接";
    _adWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    _adWebView.backgroundColor = [UIColor whiteColor];
    if (!self.adUrl) {
        self.adUrl = @"http://www.jianshu.com";
    }
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.adUrl]];
    [_adWebView loadRequest:request];
    [self.view addSubview:_adWebView];
}

- (void)setAdUrl:(NSString *)adUrl {
    
    _adUrl = adUrl;
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end



