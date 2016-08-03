//
//  PlistTool.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/27.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "PlistTool.h"

@implementation PlistTool

//得到Plist文件所在的文件路径
- (NSString *)getFileName {
    
    //获取沙盒目录
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * plistPath = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString * fileName = [plistPath stringByAppendingPathComponent:@"my.plist"];
    NSFileManager * manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:fileName]) {
        
        [manager createFileAtPath:fileName contents:nil attributes:nil];
    }
    NSLog(@"\n\t🚩\n fileName = %@ \n\t📌", fileName);
    
    return  fileName;
}


//得到数据
- (NSMutableArray *)getAllData {
    
    //将上文中创建的Plist文件中的数据存储到数组中
    NSMutableArray * getArray = [[NSMutableArray alloc] initWithContentsOfFile:[self getFileName]];
    
    if (getArray == nil) {
        
        getArray = [NSMutableArray array];
        return getArray;
    }
    else{
        
        return getArray;
    }
}

//增加Plist文件中的数据
- (void)addNewDataWith:(NSString *)data {
    
    NSMutableArray * tmpArray; //= [NSMutableArray array];  // analyzer ,nil换成后面的，查看结果
    tmpArray = [self getAllData];
    [tmpArray addObject:data];
    
    //数据存入Plist文件
    [tmpArray writeToFile:[self getFileName] atomically:YES];
    
}

//删除Plist文件中的数据
- (void)deleteDataWith:(NSString *)data {
    
    NSMutableArray * tmpArray = nil; // [NSMutableArray array];// analyzer ,nil换成后面的，查看结果
    tmpArray = [self getAllData];
    [tmpArray removeObject:data];
    
    //数据存入Plist文件
    [tmpArray writeToFile:[self getFileName] atomically:YES];
    
}


@end



