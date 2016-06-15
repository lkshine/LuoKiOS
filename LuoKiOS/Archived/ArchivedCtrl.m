//
//  ArchivedCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/28.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "ArchivedCtrl.h"
#import "CustomArchiveObject.h"


@interface ArchivedCtrl ()


@end



@implementation ArchivedCtrl

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self archivedWithOneObject];
    [self archiveWithMutableObject];
    [self archiveWithCustomObject];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark -- 一次只能归档一个对象，如果是多个对象归档需要分开进行，归档和解档其中任意对象都需要归档和解档整个文件
- (void)archivedWithOneObject {
    
    //获得沙盒路径
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //获取文件路径，由于归档后文件会加密，所以文件后缀可以任意取
    NSString * filePath = [documentPath stringByAppendingPathComponent:@"file.archiver"];
    
    //创建一个字典，用来归档
    NSDictionary * archiveDic = @{@"name":@"jack"};
    
    //调用NSKeyedArchiver的类方法archiveRootObject:toFile:将对象归档（返回一个布尔值）
    if ([NSKeyedArchiver archiveRootObject:archiveDic toFile:filePath]) {
        
        NSLog(@"\n\t🚩\n archive success! \n\t📌");
    }
    
    //调用NSKeyedUnarchiver的类方法unarchiveObjectWithFile:将文件解档
    NSDictionary *unarchiveDic = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    NSLog(@"\n\t🚩\n unarchiveDic = %@ \n\t📌", unarchiveDic);
    
}


#pragma mark -- 多个对象可以同时归档，每个对象通过键值区分，解档时键值必须与归档时键值保持匹配归档和解档其中任意对象都需要归档和解档整个文件
- (void)archiveWithMutableObject {
    
    //获得沙盒路径
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //获取文件路径，由于归档后文件会加密，所以文件后缀可以任意取
    NSString * filePath = [documentPath stringByAppendingPathComponent:@"file.archiver"];
    
    //创建一个MutableData对象用于存放需要归档的数据
    NSMutableData * archiveData = [NSMutableData data];
    
    //创建一个NSKeyedArchiver类的对象archiver，用来对归档对象进行编码，编码完成才能进行归档
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:archiveData];
    [archiver encodeObject:@"jack" forKey:@"name"];
    [archiver encodeInt:20 forKey:@"age"];
    [archiver encodeFloat:72.5 forKey:@"weight"];
    
    //完成编码
    [archiver finishEncoding];
    
    //将archiveData对象写入文件，完成归档
    if ([archiveData writeToFile:filePath atomically:YES]) {
        
        NSLog(@"archive success!");
    }
    
    //创建NSData对象来接收解档文件
    NSData *unarchiveData = [NSData dataWithContentsOfFile:filePath];
    
    //创建一个NSKeyedUnarchiver对象unarchiver，用来对需要解档的对象进行解码，解码后就能还原原对象的数据类型
    NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:unarchiveData];
    NSString * name                = [unarchiver decodeObjectForKey:@"name"];
    int age                        = [unarchiver decodeIntForKey:@"age"];
    float weight                   = [unarchiver decodeFloatForKey:@"weight"];
    NSLog(@"\n\t🚩\n name = %@, age = %d, weight = %.2f \n\t📌", name, age, weight);
    
}


#pragma mark -- 自定义类归档和解归档
- (void)archiveWithCustomObject {
    
    //获得沙盒路径
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //获取文件路径，由于归档后文件会加密，所以文件后缀可以任意取
    NSString * filePath = [documentPath stringByAppendingPathComponent:@"file.archiver"];
    
    //自定义对象
    CustomArchiveObject * person = [[CustomArchiveObject alloc] init];
    person.name   = @"jack";
    person.gender = @"male";
    person.age    = 20;
    
    //归档
    if ([NSKeyedArchiver archiveRootObject:person toFile:filePath]) {
        
        NSLog(@"archive success!");
    }
    
    //解档，person2实例接收解档后的对象
    CustomArchiveObject * person2 = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    NSLog(@"\n\t🚩\n name = %@, gender = %@, age = %d \n\t📌", person2.name, person2.gender, person2.age);
    
}
@end
