//
//  PreferenceCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/27.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "PreferenceCtrl.h"



@interface PreferenceCtrl ()



@end

/*

    很多iOS应用都支持偏好设置，比如保存用户名、密码、字体大小等设置，
    iOS提供了一套标准的解决方案来为应用加入偏好设置功能。
    每个应用都有个NSUserDefaults实例，通过它来存取偏好设置。
    比如，保存用户名、字体大小、是否自动登录等。
    NSUserDefaults 基本上支持所有的原生数据类型
    NSString、 NSNumber、NSDate、 NSArray、NSDictionary、BOOL、NSInteger、NSFloat等等。
 
 */

@implementation PreferenceCtrl

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self usePreference];
    
}

/*
 
 保存数据
 使用偏好设置对数据进行保存之后, 它保存到系统的时间是不确定的，
 会在将来某一时间点自动将数据保存到Preferences文件夹下面，
 如果需要即刻将数据存储，必须使用[defaults synchronize]
 想要实现自定义对象的存储，需要将该对象转化为NSData类型，再进行保存
 
 */

- (void)usePreference {
    
    //写数据
    //获取NSUserDefaults对象
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    //保存数据
    [defaults setObject:@"jack" forKey:@"name"];
    [defaults setInteger:20 forKey:@"age"];
    [defaults setBool:YES forKey:@"sex"];//YES表示性别为男性
    //同步数据
    [defaults synchronize];
    
//    NSDictionary * defaults = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
//    NSLog(@"\n\t🚩\n defaults = %@ \n\t📌", defaults);
    
    
    //读取数据
//    //获取NSUserDefaults对象
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //读取数据（类型需要与存储时保持一致）
    NSString * name = [defaults objectForKey:@"name"];
    NSLog(@"\n\t🚩\n name = %@ \n\t📌", name);
    NSInteger age = [defaults integerForKey:@"age"];
    NSLog(@"\n\t🚩\n age = %ld \n\t📌", (long)age);
    BOOL sex = [defaults boolForKey:@"sex"];
    NSLog(@"\n\t🚩\n sex = %i \n\t📌", sex);
    
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end
