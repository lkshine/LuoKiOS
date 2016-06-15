//
//  SandboxCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/27.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "SandboxCtrl.h"

@interface SandboxCtrl ()

@end

/*
 
 默认情况下，每个沙盒含有3个文件夹：Documents, Library 和 tmp。因为应用的沙盒机制，应用只能在这几个目录下读写文件。
 
 Documents：苹果建议将程序中建立的或在程序中浏览到的文件数据保存在该目录下，iTunes备份和恢复的时候会包括此目录
 Library：存储程序的默认设置或其它状态信息，其中又包含了Caches文件夹和Preferences文件夹
 Library/Caches：存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出时删除
 
 Library/Preferences：存放偏好设置的plist文件
 
 tmp：提供一个即时创建临时文件的地方
 iTunes在与iPhone同步时，会备份所有的Documents和Library文件。iPhone在重启时，会丢弃所有的tmp文件。
 
 */

@implementation SandboxCtrl

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self sandbox];
    
}

- (void)sandbox {
    
    //获取沙盒目录
    NSString * homePath = NSHomeDirectory();
    NSLog(@"\n\t🚩\n homePath = %@ \n\t📌", homePath);
   
    
    /*
         NSSearchPathForDirectoriesInDomains方法用来取得当前程序沙盒中的文件路径，
         第一个参数设置检索的指定路径名，第二个参数设定检索范围，
         第三个参数设置是否展开波浪线符号（展开波浪线符号才是完整的路径，所以常设置为YES），
         方法返回值为一个数组，由于不同的参数返回的路径个数不统一，
         所以为了接口的统一性，设置返回值为数组
     */
    //获取Documents文件夹目录
    NSArray * documentsArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsPath = [documentsArr objectAtIndex:0];
    NSLog(@"\n\t🚩\n documentsPath = %@ \n\t📌", documentsPath);
  
    
    //获取Library文件夹目录
    NSArray * libraryArr = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString * libraryPath = [libraryArr objectAtIndex:0];
    NSLog(@"\n\t🚩\n libraryPath = %@ \n\t📌", libraryPath);
    
    //获取Caches文件夹目录
    NSArray * cachesArr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * cachesPath = [cachesArr objectAtIndex:0];
    NSLog(@"\n\t🚩\n cachesPath = %@ \n\t📌", cachesPath);
    
    //获取tmp文件夹目录
    NSString * tmpPath = NSTemporaryDirectory();
    NSLog(@"\n\t🚩\n tmpPath = %@ \n\t📌", tmpPath);
    
}


/*
     程序的沙盒文件在Mac上是被隐藏的，所以如果想要查看程序的沙盒路径，首先需要显示Mac上隐藏的文件夹。
     
     我个人推荐使用终端通过命令行来显示隐藏文件：
     
     显示Mac隐藏文件的命令：defaults write com.apple.finder AppleShowAllFiles -bool true
     隐藏Mac隐藏文件的命令：defaults write com.apple.finder AppleShowAllFiles -bool false
     输入命令后敲回车键，然后退出终端，重新启动Finder，隐藏文件就会显示出来了。
 
 */


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
