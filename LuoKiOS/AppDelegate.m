//
//  AppDelegate.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/26.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "AppDelegate.h"

#import "RevealCtrl.h"      //侧滑菜单主页的四个控制器
#import "FrontCtrl.h"
#import "RearCtrl.h"
#import "RightCtrl.h"

#import <SMS_SDK/SMSSDK.h>  //短信验证码
#define SMSVer_AppKey           @"13ae563bfb32c"
#define SMSVer_AppSecertKey     @"200f86f30fa05fad15cad7701864c936"


#import <CIA_SDK/CIA_SDK.h> //CIA验证码
#define CIA_AppID               @"60614c14ae3c452e8f6c8017f299899c"
#define CIA_AuthKey             @"cf849abc43444dfc8579fac496f5ceb1"


@interface AppDelegate ()

@end



@implementation AppDelegate

#pragma mark -- 在实际开发过程中，假如不需要通过Storyboard加载界面，那么就需要在didFinishLaunchingWithOptions：方法中，设置window的根控制器。
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    BOOL ret = [_mapManager start:@"NATxBkNSywZizp5CILr6z2nuYRdO7oal"  generalDelegate:nil];
    
    if (!ret) {
        
        NSLog(@"manager start failed!");
    }
    
    [self.window addSubview:navigationController.view];
    
    //使用横扫滑动揭示风格
    [self useSlidingRevealStlye];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    
    //注册本地通知
    [self registerLocationPushNotifyWithApplication:application];
    // 移除所有本地通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
    //初始化短信验证码
    [self initSMSSDK];
    
    //初始化CIA
    [self initCIA];
    
    return YES;
}


#pragma mark -- CIA验证码
- (void)initCIA {
    
    [CIA initWithAppId:CIA_AppID authKey:CIA_AuthKey];
}



#pragma mark -- mob短信验证码
- (void)initSMSSDK {
    
    //初始化应用，appKey和appSecret从后台申请得
    [SMSSDK registerApp:SMSVer_AppKey withSecret:SMSVer_AppSecertKey];
    
}


#pragma mark -- 侧滑菜单栏
- (void)useSlidingRevealStlye {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //左侧菜单栏
    RearCtrl *leftViewController = [[RearCtrl alloc] init];
    //    UIViewController * leftViewController = [UIViewController new];
    //    leftViewController.view.backgroundColor = [UIColor redColor];
    
    //首页
    FrontCtrl *centerView1Controller = [[FrontCtrl alloc] init];
    
    //右侧菜单栏
    RightCtrl *rightViewController = [[RightCtrl alloc] init];
    
    SWRevealViewController *revealViewController = [[SWRevealViewController alloc] initWithRearViewController:leftViewController frontViewController:centerView1Controller];
    revealViewController.rightViewController = rightViewController;
    
    //浮动层离左边距的宽度
    revealViewController.rearViewRevealWidth = 230;
    //    revealViewController.rightViewRevealWidth = 230;
    
    //是否让浮动层弹回原位
    //mainRevealController.bounceBackOnOverdraw = NO;
    [revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:revealViewController];
    self.window.rootViewController = nav;
    
}

//- (void)applicationWillResignActive:(UIApplication *)application {
//    
//    [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
//}
//
//
//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    
//    [BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
//}


#pragma mark -- 本地推送
//注册本地通知
- (void)registerLocationPushNotifyWithApplication:(UIApplication *)application  {
    
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];//注册本地推送
    
}

//接收本地推送
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    NSLog(@"%@", notification.alertBody);
    
    
    // 如果是没有正在使用该APP状态下，从通知点击进入APP的会到指定页面（这里需要在mainController，即FrontCtrl的viewDidLoad里接收这里注册的通知来跳转到指定界面）
    if (application.applicationState == UIApplicationStateInactive) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"presentView" object:nil];
        
        // 这里我有个"bug"，我的FrontCtrl是会由左边列表选择而改变，所有要在改变后的mainCtrl里做跳转设置，但这仅仅是因为我command+shift+h慢了导致，如果真让app进入后台后程序一定还是FrontCtrl是mainCtrl,这里只是特地说下
    }
    
    
    // 这里是真实需要处理交互的地方
    // 获取通知所带的数据
    NSString *details = [notification.userInfo objectForKey:@"anyKey"];
    // 设置警示框，iOS 9.0 之后苹果推荐使用UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"通知" message:details preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    
    // 更新显示的角标个数
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge--;
    badge = badge >= 0 ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    
    
}



#pragma mark -- 应用程序从前台切换到后台,当用户点击Home键的时候，应用程序会经历从Active -> Background -> Suspended过程，在这个过程中，会调用AppDelegate对象中的applicationWillResignActive: 以及applicationDidEnterBackground:方法 。在实际的开发过程中，当用户点击Home键使应用程序切换到后台时，需要在这些方法中对数据或者状态进行保存。
/*
    在默认情况下，applicationDidEnterBackground方法有大概5秒钟的时间来完成一些任务。
 假如说5秒钟的时间不够，则需要调用beginBackgroundTaskWithExpirationHandler：方法来申请更多的后台运行时间，后台运行的时间由backgroundTimeRemaining属性来确定。
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    NSLog(@"%s",__func__);
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithName:@"MyTask" expirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    // 立即开始执行的任务
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Do the work associated with the task, preferably in chunks.
        NSLog(@"________");
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    });
    
}


#pragma mark -- 当应用程序从后台切换到前台时，会调用applicationWillEnterForeground:以及applicationDidBecomeActive:方法。
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



#pragma mark -- 响应中断, 当来电或者闹钟触发的时候，应用程序会触发中断，这时AppDelegate对象会首先调用applicationWillResignActive:方法，当用户接听电话时，会直接跳转到电话程序；假如用户选择不接听电话，这时会返回应用程序，并调用applicationDidBecomeActive:方法。



#pragma mark -- 锁屏/解锁,当用户锁屏的时候，应用程序会调用AppDelegate对象的applicationWillResignActive:方法以及applicationDidEnterBackground:方法。当用户解锁后，应用程序会调用applicationWillEnterForeground:方法以及applicationDidBecomeActive:方法。

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end



// 关于Block内部要不要使用weakSelf的几种情况 http://www.jianshu.com/p/c6ca540861d9
/*
 我们知道当对block使用不当时会造成循环引用导致内存泄露，这里列出几种使用block到底会不会引起循环引用的例子，通过重写控制器dealloc，当控制器被pop看有没有调用来判断。
 
 block是控制器的属性，如果block内部没有使用weakSelf将会造成内存泄露
 self.testBlock = ^()
 {
 NSLog(@"%@",self.mapView);
 };
 self.testBlock();
 把block内部抽出一个作为self的方法，当使用weakSelf调用这个方法，并且这个方法里有self的属性，block不会造成内存泄露
 self.testBlock = ^()
 {
 [weakSelf test];
 };
 -(void)test
 {
 NSLog(@"%@",self.mapView);
 }
 当block不是self的属性时，block内部使用self也不会造成内存泄露
 TestBlock testBlock = ^()
 {
 NSLog(@"%@",self.mapView);
 };
 [self test:testBlock];
 当使用类方法有block作为参数使用时，block内部使用self也不会造成内存泄露
 
 [WDNetwork testBlock:^(id responsObject) {
 
 NSLog(@"%@",self.mapView);
 }];
 以上几个是我通过控制器pop时，通过有没有走dealloc方法测出来的。
 
 */
