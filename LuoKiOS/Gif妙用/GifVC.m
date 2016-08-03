//
//  GifVC.m
//  LuoKiOS
//
//  Created by lkshine on 16/7/31.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "GifVC.h"
#import <WebKit/WebKit.h>


@interface GifVC ()

@property (nonatomic, strong) WKWebView * gifWeb;

@end



@implementation GifVC

- (WKWebView *)gifWeb {
    
    if (!_gifWeb) {
        _gifWeb = [[WKWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:_gifWeb];
    }
    return _gifWeb;
}

// 顺便讲下 WKWebView 的加载http://www.jianshu.com/p/e8c63551ef84
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"gif";
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"actor" ofType:@"gif"];
    NSData * gif = [NSData dataWithContentsOfFile:filePath];
//    [self.gifWeb loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];

//   [self.gifWeb loadData:gif MIMEType:@"image/gif" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@"http://localhost/"]];
    
    [self.gifWeb loadData:gif MIMEType:@"image/gif"  characterEncodingName:@"UTF-8"  baseURL:[NSURL URLWithString:@"https://www.baidu.com"]];

    self.gifWeb.userInteractionEnabled = NO;
//    //创建一个灰色的蒙版，提升效果（可选）
//    UIView *filter = [[UIView alloc] initWithFrame:self.view.bounds];
//    filter.backgroundColor = [UIColor blackColor];
//    filter.alpha = 0.5;
//    [self.view addSubview:filter];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end



