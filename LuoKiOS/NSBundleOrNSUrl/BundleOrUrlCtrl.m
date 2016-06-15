//
//  BundleOrUrlCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/6/7.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "BundleOrUrlCtrl.h"

@interface BundleOrUrlCtrl ()

@property (nonatomic, strong) NSString * lkNewPath;
@property (nonatomic, strong) NSString * lkNewfile;
@property (nonatomic, strong) NSString * lkPathBundle;

@end



@implementation BundleOrUrlCtrl



- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setString];
    [self setContent];
    [self chineseConvertUtf];
    
    NSLog(@"\n\t🚩\n ？？ = %@ \n\t📌", (@[@"测试", @"中文"]).description);
}


- (void)setString {
    
    NSString *path = @"/Users/luok/Desktop/aa.txt";
    //NSString *str = [NSString stringWithContentsOfFile:path];
    //UTF-8编码
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"str = %@",str);
    
    //GBK编码
    NSString *path2 = @"/Users/luok/Desktop/aa.txt";
    NSString *str2 = [NSString stringWithContentsOfFile:path2 encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000) error:nil];
    NSLog(@"str2 = %@",str2);
    
    //使用NSURL从文件中读取字符串
    NSURL *url = [NSURL URLWithString:@"file:///Users/luok/Desktop/aa.txt"];
    NSString *str3 = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"str3 = %@",str3);
    
    //使用NSURL读取远程文本
    NSURL *url2 = [NSURL URLWithString:@"http://www.baidu.com"];
    NSString *str4 = [NSString stringWithContentsOfURL:url2 encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"str4 = %@",str4);
    
}

- (void)setContent {
    
    //  读取文件内容
    //  方法1:按照文件路径读取
    _lkPathBundle      = [[NSBundle mainBundle]pathForResource:@"aa" ofType:@"txt"];
    NSString * outstringbundle = [NSString stringWithContentsOfFile:_lkPathBundle encoding:NSUTF8StringEncoding error:nil];

    NSLog(@"\n\t🚩\n _lkPathBundle = %@ \n\t📌", _lkPathBundle);
    //  方法2:按照URL读取
    NSURL    * pathUrl         = [[NSBundle mainBundle]URLForResource:@"aa" withExtension:@"txt" subdirectory:nil];//[NSURL URLWithString:@"http://www.baidu.com?id=1"];//
    NSString * outstringUrl    = [NSString stringWithContentsOfURL:pathUrl encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"\n\t🚩\n outstringbundle = %@\n,\n outstringUrl = %@ \n\t📌", outstringbundle, outstringUrl);
    
}

- (void)writeFile {
    
    _lkNewPath = [NSString stringWithFormat:@"%@/Documents/New", NSHomeDirectory()];
    NSString * lknew = [_lkNewPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //  先把文件路径和文件名定义好
    _lkNewfile = [NSString stringWithFormat:@"%@/new.mp3", _lkNewPath];
    //  使用createFileAtPath创建文件
    [[NSFileManager defaultManager]createFileAtPath:_lkNewfile contents:nil attributes:nil];
    NSLog(@"lknew = %@",lknew);
    
}


- (void)readFile {
    
    //  写入文件
    //  1、先用data读取数据
    NSData * data = [[NSData alloc]initWithContentsOfFile:_lkPathBundle];
    NSLog(@"%@",data);
    
    //  2、把读取的data写入沙盒文件，newfile为上面在沙盒文件中创建的mp3文件
    [data writeToFile:_lkNewfile atomically:YES];
    
}

#pragma mark -- Unicode转化为汉字


#pragma mark -- 汉字与utf-8
- (void)chineseConvertUtf {
    
    NSString* strA = [@"%E4%B8%AD%E5%9B%BD"stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n\t🚩\n strA = %@ \n\t📌", strA);
    
    //1.如果传服务器的是“乱码”，一般是需要本地转码成utf-8再传给服务器
    NSString *strB = [@"中国"stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n\t🚩\n strB = %@ \n\t📌", strB);
    
    //2.如果1方法之后还乱码，因为传到服务器的数据的编码是UTF-8，在服务器看到是乱码，那说明服务器解析数据采用的可能不是UTF-8，使用中文操作系统，默认的编码是GBK,
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString * str = @"汉字";
    NSData * data = [str dataUsingEncoding:enc];
    NSLog(@"\n\t🚩\n data = %@\n\t📌", data);
    NSString * retStr = [[NSString alloc] initWithData:data encoding:enc];
    NSLog(@"\n\t🚩\n retStr = %@ \n\t📌", retStr);
    
    //如果还不对，就需要 做encoding 编码了
    
}

#pragma mark -- 字符串适用房
//http://blog.sina.com.cn/s/blog_8d05143b01013h5h.html



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}



@end
