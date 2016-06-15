//
//  SysSchemesCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/31.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "SysSchemesCtrl.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface SysSchemesCtrl ()<MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>
{
    UILabel * myText;
}
@end



@implementation SysSchemesCtrl

- (void)viewDidLoad {
    
    [super viewDidLoad];
    myText = [UILabel new];
    myText.text = @"13971088809";
//    [self phone];
//    [self message];
//    [self email];
//    [self wifi];
    
}


- (IBAction)phoneAciton:(UIButton *)sender {
    [self phone];
}

#pragma mark -- 应用内打电话
- (void)phone {
    
    //通过UIWebView实现
    UIWebView *phoneWV = [[UIWebView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:phoneWV];
    
    //读入电话号码
    NSString *urlStr = [NSString stringWithFormat:@"tel://%@",myText.text];//self.myText.text是你要读入的电话号码，tel:不可省略，否则程序会出错
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //加载请求
    [phoneWV loadRequest:request];
}



- (IBAction)messageAction:(UIButton *)sender {
    [self message];
}
#pragma mark -- 应用内发短信
- (void)message {
    
    //如果设备支持发送短信，返回yes。
    if([MFMessageComposeViewController canSendText]) {
        
        // MFMessageComposeViewController提供了操作界面,这里我们创建一个相应的控制器
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init];
        controller.recipients = [NSArray arrayWithObject:myText.text];
        controller.body = @"测试发短信";
        controller.messageComposeDelegate = self;
        
        //显示发送信息界面的控制器
        [self presentViewController:controller animated:YES completion:nil];
    }
    else {
        
        NSLog(@"设备不具备短信功能");
    }
    
}


/*短信发送完成后返回app*/
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    if (result ==  MessageComposeResultSent) {
        
        NSLog(@"发送成功");
    }
}



- (IBAction)emailAction:(UIButton *)sender {
    [self email];
}
#pragma mark -- 应用内发邮件，ps：真机测试失败
- (void)email {
    
    //如果设备支持发送邮件，返回yes。
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:[NSArray arrayWithObjects:myText.text, nil]];//self.myText.text为邮件地址
        //要发送的邮件主题
        [controller setSubject:@"邮件测试"];
        //要发送邮件的内容
        [controller setMessageBody:@"Hello " isHTML:NO];
        [self presentViewController:controller animated:YES completion:nil];
        
    }
    else{
        
        NSLog(@"设备不具备发送邮件功能");
    }
    
}


- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    
    if (result == MFMailComposeResultSent) {
        
        NSLog(@"邮件发送成功");
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



- (IBAction)wifiAction:(UIButton *)sender {
    [self wifi];
}
#pragma mark -- 打开WiFi
- (void)wifi {
    
    NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        
        NSLog(@"\n\t🚩\n wifi成功打开 \n\t📌");
        [[UIApplication sharedApplication] openURL:url];
    }
    else {
        
        NSLog(@"\n\t🚩\n wifi打开失败 \n\t📌");
    }
    
}



- (IBAction)locationAction:(UIButton *)sender {
    [self location];
}

- (void)location {
    
    //定位服务设置界面
    NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        
        NSLog(@"\n\t🚩\n 定位成功打开 \n\t📌");
        [[UIApplication sharedApplication] openURL:url];
    }
    else {
        
        NSLog(@"\n\t🚩\n 定位打开失败 \n\t📌");
    }
    
}


- (IBAction)musicAction:(UIButton *)sender {
    
    //音乐设置界面
    NSURL *url = [NSURL URLWithString:@"prefs:root=MUSIC"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        
        [[UIApplication sharedApplication] openURL:url];
    }
}


- (IBAction)wallpaperAction:(UIButton *)sender {
    
    //墙纸设置界面
    NSURL *url = [NSURL URLWithString:@"prefs:root=Wallpaper"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        
        [[UIApplication sharedApplication] openURL:url];
    }
}


- (IBAction)bluetoothAction:(UIButton *)sender {
    
    //蓝牙设置界面
    NSURL *url = [NSURL URLWithString:@"prefs:root=Bluetooth"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        
        [[UIApplication sharedApplication] openURL:url];
    }
}


- (IBAction)iCloudAction:(UIButton *)sender {
    
    
    //iCloud设置界面
    NSURL *url = [NSURL URLWithString:@"prefs:root=CASTLE"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        
        [[UIApplication sharedApplication] openURL:url];
    }
}


#pragma mark -- APP内部调用系统应用如下
/*
 
 info里面设置:
 在项目中的info.plist中添加 URL types 并设置一项 URL Schemes， Item0 为 prefs，
 
 
 调用系统内部应用时 只需要替换即可
 About — prefs:root=General&path=About
 Accessibility — prefs:root=General&path=ACCESSIBILITY
 Airplane Mode On — prefs:root=AIRPLANE_MODE
 Auto-Lock — prefs:root=General&path=AUTOLOCK
 Brightness — prefs:root=Brightness
 Bluetooth — prefs:root=General&path=Bluetooth
 Date & Time — prefs:root=General&path=DATE_AND_TIME
 FaceTime — prefs:root=FACETIME
 General — prefs:root=General
 Keyboard — prefs:root=General&path=Keyboard
 iCloud — prefs:root=CASTLE
 iCloud Storage & Backup — prefs:root=CASTLE&path=STORAGE_AND_BACKUP
 International — prefs:root=General&path=INTERNATIONAL
 Location Services — prefs:root=LOCATION_SERVICES
 Music — prefs:root=MUSIC
 Music Equalizer — prefs:root=MUSIC&path=EQ
 Music Volume Limit — prefs:root=MUSIC&path=VolumeLimit
 Network — prefs:root=General&path=Network
 Nike + iPod — prefs:root=NIKE_PLUS_IPOD
 Notes — prefs:root=NOTES
 Notification — prefs:root=NOTIFICATIONS_ID
 Phone — prefs:root=Phone
 Photos — prefs:root=Photos
 Profile — prefs:root=General&path=ManagedConfigurationList
 Reset — prefs:root=General&path=Reset
 Safari — prefs:root=Safari
 Siri — prefs:root=General&path=Assistant
 Sounds — prefs:root=Sounds
 Software Update — prefs:root=General&path=SOFTWARE_UPDATE_LINK
 Store — prefs:root=STORE
 Twitter — prefs:root=TWITTER
 Usage — prefs:root=General&path=USAGE
 VPN — prefs:root=General&path=Network/VPN
 Wallpaper — prefs:root=Wallpaper
 Wi-Fi — prefs:root=WIFI
 
 */

- (IBAction)settingAction:(UIButton *)sender {
    
    [self showEventsAcessDeniedAlert];
}

#pragma mark -- 配合告警框进入系统设置效果
- (void)showEventsAcessDeniedAlert {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Sad Face Emoji!"//@"提示"
                                        message:@"The calendar permission was not authorized. Please enable it in  Settings to continue." //@"是否要重新开始？"
                                 preferredStyle:UIAlertControllerStyleAlert];//通过该枚举类型，选择展示样式
    
    UIAlertAction * settingsAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDestructive
                           handler:^(UIAlertAction * action) {
                             
                               NSURL * appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                               
                               if  ([[UIApplication sharedApplication] canOpenURL:appSettings]) {
                                   [[UIApplication sharedApplication] openURL:appSettings];
                               }
                           }];

    [alertController addAction:settingsAction];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                           handler:^(UIAlertAction * action) {
                               
                           }];
    
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];

}




- (IBAction)jumpOtherApp:(UIButton *)sender {
    
    NSLog(@"\n\t🚩\n appJump \n\t📌");
    [self JumpOtherApp];
}


#pragma mark -- APP调用另一个APP,必看 http://blog.sina.com.cn/s/blog_877e9c3c0102v0m5.html
/*
 在iOS中提供了两种在浏览器中打开APP的方法：Smart App Banner和schema协议。(使用schema协议调用APP和使用iframe打开APP的例子)

 URL Identifier  可以理解为APP在江湖的代号，而不是江湖中的名字（在手机里显示的APP名称），是自定义的 URL scheme 的名字，一般采用反转域名的方法保证该名字的唯一性，比如 com.LuokiOS.www
 URL Schemes:    可以理解为APP本身的名字（这里我写的是prefs）
 http://www.jb51.net/article/83266.htm
*/

/* 带参数2个APP之间跳转http://www.cocoachina.com/bbs/read.php?tid=150895&page=e */
- (void)JumpOtherApp {
    
//    NSString * test = @"从LuokIOS_APP（prefs发给您的消息）";
    NSString *urlString = @"otherApp://?Identifier=comeToOtherApp?name=zhangsan";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlString  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

}


//在另一个APP的appdelegate里添加如下:
/*
#pragma mark -- 接受另一个app传过来的数据
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSString *itemId = [[url query] substringFromIndex:[[url query] rangeOfString:@"name="].location+5];
    NSLog(@"itemId :%@",itemId);
    
    return YES;
}
*/



#pragma mark -- 一个APP多个版本（target）ps： http://blog.csdn.net/ysysbaobei/article/details/10951991 和 http://www.jianshu.com/p/287fe3ad1f3a


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end
