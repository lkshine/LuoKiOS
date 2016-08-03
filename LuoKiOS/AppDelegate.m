//
//  AppDelegate.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/26.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "AppDelegate.h"
#import "AdvertiseView.h"   //启动广告

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

//启动广告1里需要的属性
@property (nonatomic, strong) UIImageView * advertiseView;//启动AD的image其实就是launchImage底部相似的一个广告界面的覆盖，就是一个用户视觉的欺瞒效果

//启动广告2里需要的属性
@property (nonatomic, strong) UIButton               * countBtn;
@property (strong, nonatomic) UIView                 * launchView;
@property (nonatomic,strong ) UIImageView            * imgBg;
@property (nonatomic,strong ) UIImageView            * oldLaunchView;
@property (nonatomic, assign) int                      count;
@property (nonatomic, strong) UITapGestureRecognizer * tap;

@end


// 广告显示的时间
static int const showtime = 3;

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
    
    //启动广告1
//    [self launchAdvertising1];
    
    //启动广告2
    [self launchAdvertising2];
    
    return YES;
}



//  在启动页进行广告添加 http://blog.csdn.net/wx_jin/article/details/50617041（launchImag加载完后加载一张雷同图片覆盖上，形同视觉欺骗手法，达到启动页即广告页效果） 和http://www.cocoachina.com/ios/20160614/16671.html（通过SB的key值获取launchImage图片，并对其进行修改，再做bringSubviewToFront将其推前来达到启动页与广告页会显示效果，这里我改良了下对广告页添加跳过button，手法同链接一）

#pragma mark -- 启动广告1（一样的广告页盖在了启动页上，形同一体）
- (void)launchAdvertising1 {
    // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
    NSString *filePath = [self getFilePathWithImageName:[kUserDefaults valueForKey:adImageName]];
    
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (isExist) {// 图片存在
        
        AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:self.window.bounds];
        advertiseView.filePath = filePath;
        [advertiseView show];
        
    }
    
    // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
    [self getAdvertisingImage];
    
}


/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

/**
 *  初始化广告页面
 */
- (void)getAdvertisingImage
{
    
    // TODO 请求广告接口
    
    // 这里原本采用美团的广告接口，现在了一些固定的图片url代替
    NSArray *imageArray = @[@"http://imgsrc.baidu.com/forum/pic/item/9213b07eca80653846dc8fab97dda144ad348257.jpg", @"http://pic.paopaoche.net/up/2012-2/20122220201612322865.png", @"http://img5.pcpop.com/ArticleImages/picshow/0x0/20110801/2011080114495843125.jpg", @"http://www.mangowed.com/uploads/allimg/130410/1-130410215449417.jpg"];
    NSString *imageUrl = imageArray[arc4random() % imageArray.count];
    
    // 获取图片名:43-130P5122Z60-50.jpg
    NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
    NSString *imageName = stringArr.lastObject;
    
    // 拼接沙盒路径
    NSString *filePath = [self getFilePathWithImageName:imageName];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
        
        [self downloadAdImageWithUrl:imageUrl imageName:imageName];
        
    }
    
}

/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            NSLog(@"保存成功");
            [self deleteOldImage];
            [kUserDefaults setValue:imageName forKey:adImageName];
            [kUserDefaults synchronize];
            // 如果有广告链接，将广告链接也保存下来
        }else{
            NSLog(@"保存失败");
        }
        
    });
}

/**
 *  删除旧图片
 */
- (void)deleteOldImage
{
    NSString *imageName = [kUserDefaults valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    
    return nil;
}


#pragma mark -- 启动广告2（通过bringSubviewToFront方法，将launchImage替换后再推前定时显示，达到启动页和广告页都显示的需求）
/*
 兼容使用LaunchImage启动图
 这边去获取启动图（为了防止广告图还在加载中，启动图已经加载结束了）
 */
- (void)launchAdvertising2 {
    
    CGSize viewSize = self.window.bounds.size;
    NSString * viewOrientation = @"Portrait";//横屏请设置成 @"Landscape"
    NSString * launchImage = nil;
    NSArray * imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    
    for(NSDictionary * dict in imagesDict) {
        
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if(CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    
    //这里我一直不知道为什么明明添加了launchImage就是不显示，参考http://zhidao.baidu.com/link?url=Me3e5YPhPupTqCAmjD5Wx-wfvEsGya-XU8p8Tk9VJI4dH5vIswyc9Ng-fpVIPhvFS8pJ5AzaEerjXTqwjokhSHx05RQzhv3eU_5HIm2zUoe来配置就好
    self.oldLaunchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
    self.oldLaunchView.frame = self.window.bounds;
    self.oldLaunchView.contentMode = UIViewContentModeScaleAspectFill;
    [self.window addSubview:self.oldLaunchView];
    
    [self loadLaunchAd];
}

//懒加载第二次切换好后的window上添加个“跳过”按钮
- (UIButton *)countBtn {
    
    if (!_countBtn) {
        
        CGFloat btnW = 60;
        CGFloat btnH = 30;
        _countBtn = [[UIButton alloc] initWithFrame:CGRectMake(kscreenWidth - btnW - 24, btnH, btnW, btnH)];
        [_countBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_countBtn setTitle:[NSString stringWithFormat:@"跳过%d", showtime] forState:UIControlStateNormal];
        _countBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_countBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _countBtn.backgroundColor = [UIColor colorWithRed:38 /255.0 green:38 /255.0 blue:38 /255.0 alpha:0.6];
        _countBtn.layer.cornerRadius = 4;
    }
    return _countBtn;
}


/*
 加载自定义广告
 */
-(void)loadLaunchAd {
    
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(handleTimer) userInfo:nil repeats:NO];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
    if (storyboard == nil) {
        return;
    }
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"LaunchScreen"]; //记得在LaunchScreen.storyboard里添加Identity -- Storyboard ID 为LaunchScreen,另外需要注意配置的是直接将imageview加到该sb上【如果用Nav了把再其上的三个view灯删除，只需要在该sb上留一个ImageView即可】
    if (viewController == nil) {
        return;
    }
    
    self.launchView = viewController.view;
    [self.window addSubview:self.launchView];
    
    self.imgBg=[[UIImageView alloc]initWithFrame:self.window.frame];
    
    
    [self.launchView addSubview:self.imgBg];
    
    [self.oldLaunchView removeFromSuperview];
    
    [self.window bringSubviewToFront:self.launchView];
    
    //显示好广告页后添加个跳过按钮
    [self.window addSubview:self.countBtn];
    
    //点击广告图片跳转到广告界面
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToAd)];
    [self.window  addGestureRecognizer:_tap];
    
    //gcd倒计时让跳过button开始倒计时起来
    [self startCoundown];
    
}

// GCD倒计时
- (void)startCoundown {
    
    __block int timeout = showtime + 1; //倒计时时间 + 1
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if (timeout <= 0) { //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self dismiss];
            });
        }
        else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_countBtn setTitle:[NSString stringWithFormat:@"跳过%d",timeout] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}



-(void)handleTimer {
    
    [self.imgBg removeFromSuperview];
    [self.launchView removeFromSuperview];
    [self.countBtn removeFromSuperview];
}

- (void)pushToAd{
    
    [self dismiss];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushtoad" object:nil userInfo:nil];
}

// 移除广告页面
- (void)dismiss
{
    [UIView animateWithDuration:0.3f animations:^{
        [self.imgBg removeFromSuperview];
        [self.launchView removeFromSuperview];
        [self.countBtn removeFromSuperview];
        //手势也需要移除吗？Absolute！，不然手势一直在屏幕上会一直调广告的控制器了
        [self.window removeGestureRecognizer:_tap];
        
    } completion:^(BOOL finished) {
        
        
    }];
    
}
//=========================================================


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
