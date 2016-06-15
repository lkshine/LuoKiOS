//
//  ReachabilityCtrl.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/26.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "ReachabilityCtrl.h"

@interface ReachabilityCtrl ()

@end

@implementation ReachabilityCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self useNotifiction];
}


#pragma mark -- 直接咨询网络状态
- (void)getNetworkingStatus {
    
    //可以使用多种方式初始化
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.cctv.com"];
    
    //判断当前的网络状态
    switch ([reach currentReachabilityStatus]) {
            
        case ReachableViaWWAN:
            NSLog(@"正在使用移动数据网络");
            break;
        case ReachableViaWiFi:
            NSLog(@"正在使用WiFi");
            break;
        default:
            NSLog(@"无网络");
            break;
            
    }
    //根据currentReachabilityStatus方法获取当前的网络环境，ReachableViaWWAN表示移动数据网络，ReachableViaWiFi表示WiFi网络，NotReachable表示没有接入网络。
}


#pragma mark -- 通知监测网络变化
- (void)useNotifiction {
    
    //可以使用多种方式初始化
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.hcios.com"];
    
    //通知中心注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    //Reachability实例调用startNotifier方法启动网络状态监测
    [reach startNotifier];
    
}

//收到通知调用的方法
- (void)reachabilityChanged:(NSNotification *)notification {
    
    Reachability *reach = [notification object];
    
    //判断网络状态
    if (![reach isReachable]) {
        
        NSLog(@"网络连接不可用");
    }
    else {
        
        if ([reach currentReachabilityStatus] == ReachableViaWiFi) {
            
            NSLog(@"正在使用WiFi");
        }
        else if ([reach currentReachabilityStatus] == ReachableViaWWAN) {
            
            NSLog(@"正在使用移动数据");
        }
    }
    
}//通过通知的方式使用Reachability是在程序中经常使用的，Reachability可以在用户的网络状态发生改变时，及时给出通知提醒，防止数据流量的快速流失，在实际的项目应用中是十分常见的。


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
