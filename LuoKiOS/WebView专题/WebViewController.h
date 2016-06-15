//
//  WebViewController.h
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/18.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@end



/*
 
 NJKWebViewProgress框架
 
 分析
 之前也有遇到需要做webview进度条的需求，但是一直没有好的方法。最后我的处理方法是使用NSURLRquest 去请求数据，请求的进度可以拿到，请求结束之后把请求的数据加载到webview。
 这样请求完成之前是不会显示数据的，只显示了进度条。所以很好奇NJKWebViewProgress是怎么做到的，分析如下：
 webViewDidStartLoad 是一个请求的开始，所有的请求都要经过它，未加载资源之前，能够得到一个URL 有多少个资源需要加载，使用_loadingCount++ 方式来计数。
 webViewDidFinishLoad、didFailLoadWithError 是一个请求的结束，每次请求结束 _loadingCount --,并重新计数进度
 进度使用 _loadingCount/_maxLoadCount 的方式来计算
 每次webViewDidFinishLoad、didFailLoadWithError 请求都加入了 waitForCompleteJS 这样的js到web view中，来检测网页是否加载完成。
 把得到进度逻辑和展示进度的视图分开写，用代理把两个类联系起来，结构清晰、实现起来也会方便很多
 
 
 总结
 作者非常巧妙地通过计算需要加载的请求的个数，通过请求个数来现实加载进度，不得不佩服他的想法
 
 */