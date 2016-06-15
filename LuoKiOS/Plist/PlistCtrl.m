//
//  PlistCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/27.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "PlistCtrl.h"
#import "PlistTool.h"


@interface PlistCtrl ()

@end




@implementation PlistCtrl

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self getPlist];

}


- (void)getPlist {
    
    //获取plist文件地址
    NSString * path = [[NSBundle mainBundle] pathForResource:@"User" ofType:@"plist"];
    
    //获取plist文件内容（一个字典） plist一般应用例如地图的属性，省市县列表等。
    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSLog(@"\n\t🚩\n dict = %@ \n\t📌", dict);
    
    
    //在沙盒路径下创建和使用plist文件
    //获取沙盒目录
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * plistPath = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString * fileName = [plistPath stringByAppendingPathComponent:@"my.plist"];
    NSLog(@"\n\t🚩\n filenName = %@ \n\t📌", fileName);
    
    //创建一个字典，将此字典对象存入上文创建的my.plist文件中
    NSDictionary * dic = @{@"name":@"jack", @"age":@"18", @"gender":@"male"};
    
    [dic writeToFile:fileName atomically:YES];
    
    //读取刚刚保存的数据
    NSDictionary *getDic = [NSDictionary dictionaryWithContentsOfFile:fileName];
    NSLog(@"\n\t🚩\n getDic = %@ \n\t📌", getDic);
    
//    [self modifyPlist];
    
}


- (void)modifyPlist {
    
    //创建一个存放从Plist文件取出数据的数组
    NSArray * array = [NSArray array];
    //将取出的数据放入数组array中
    PlistTool * Plist = [[PlistTool alloc] init];
    array = [Plist getAllData];
    NSLog(@"\n\t🚩\n array = %@ \n\t📌", array);
    
    //给Plist文件中加入数据123
    PlistTool * Plist1 = [[PlistTool alloc] init];
    [Plist1 addNewDataWith:@"123"];
    
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}



@end
