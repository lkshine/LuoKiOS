//
//  PushWithNotifyCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/6/8.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "PushWithNotifyCtrl.h"

#define LocationPushKey     @"anyKey"

@interface PushWithNotifyCtrl ()

@end

@implementation PushWithNotifyCtrl

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // presentView:为执行界面跳转的方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentView:) name:@"presentView" object:nil];
    
}


// 页面跳转
- (void)presentView:(NSNotification *)notifition {
    
    SysSchemesCtrl * viewController = [[SysSchemesCtrl alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark -- 本地推送
//要想本地通知成功必须要在AppDelegate里先注册通知，获得推送消息触发也是在AppDelegate里
- (IBAction)locationPushAction:(UIButton *)sender {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 初始化本地通知
        UILocalNotification * notification = [[UILocalNotification alloc]init];
        NSDate * pushDate = [NSDate dateWithTimeIntervalSinceNow:3];
        
        if (notification != nil) {
            
            // 设置触发通知的时间（方法参数传入的时间）
            notification.fireDate = pushDate;
            
            // 时区
            notification.timeZone = [NSTimeZone defaultTimeZone];
            
            // 通知被触发时播放的声音（可自定义）
            notification.soundName = UILocalNotificationDefaultSoundName;
            
            // 通知主体内容
            notification.alertBody = @"这是通知主体";
            
            // 通知的动作（解锁时下面一行小字，滑动来...后面的字）
            notification.alertAction = @"偷偷学习iOS";
            
            // 应用程序角标，默认为0（不显示角标）
            notification.applicationIconBadgeNumber = 1;
            
            // 通知的参数，通过key值来标识这个通知
            NSDictionary * info = [NSDictionary dictionaryWithObject:@"test本地推送" forKey:LocationPushKey];
            notification.userInfo = info;
            
            // ios8后，需要能响应registerUserNotificationSettings:方法，才能得到授权
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
                // 设置通知类型
                UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
                UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                         categories:nil];
                [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
                // 通知重复的时间间隔，可以是天、周、月（实际最小单位是分钟）
                notification.repeatInterval = kCFCalendarUnitMinute;
            } else {
                // 通知重复的时间间隔，可以是天、周、月（实际最小单位是分钟）
                notification.repeatInterval = NSCalendarUnitDay;
            }
            
            
            // 执行通知注册
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            
        }
    });
    
}

//选个一个合适的时机注销本地通知，不然即使删除应用，该通知依然在系统内
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self cancelLocalNotificationWithKey:LocationPushKey];
    // or 移除所有本地通知
    // [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
}

// 在需要移除某个通知时调用下面方法
// 取消某个本地推送通知
- (void)cancelLocalNotificationWithKey:(NSString *)key {
    
    // 获取所有本地通知数组
    NSArray * localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    // 遍历通知数组
    for (UILocalNotification * notification in localNotifications) {
        
        NSDictionary * userInfo = notification.userInfo;
        
        if (userInfo) {
            
            // 根据设置通知参数时指定的key来获取通知参数
            NSString * info = [userInfo objectForKey:key];
            
            // 如果找到需要取消的通知，则取消通知
            if (info != nil) {
                
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
    
}

/*
 本地推送过程中可能会出现如下状况：
 Attempting to schedule a local notification……with a sound but haven't received permission from the user to play sounds
 
 Attempting to schedule a local notification……with an alert but haven't received permission from the user to display alerts
 
 可能是因为你没有注册，或者设置中没有开启推送功能，
 
 */


#pragma mark -- 远程推送
// 友盟 1.3.0 之后是极大简化了配置，因此网络上很多有关配置操作不要理会了，直接参考官网关于当前最新版本的使用方法即可：http://dev.umeng.com/push/ios/integration?spm=0.0.0.0.EQJkVh#1

//对于友盟1.2.x版本中，该blog对于自定义弹出及友盟做了优化，可以借鉴http://blog.csdn.net/woaifen3344/article/details/41316267


// 不借助第三方的远程推送 http://my.oschina.net/leejan97/blog/393751
@end
