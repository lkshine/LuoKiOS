//
//  XmlData.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/27.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "XmlData.h"
#import "GDataXMLNode.h"


@implementation XmlData


- (void)getData {
    
    
    /*
    
    __block NSMutableArray *result = [[NSMutableArray alloc] init];
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    //在数组里面添加请求参数
    params[@"key"]   = @"987d0c7bd487209bd5bb4065b3d4fcc2";
    params[@"lng"]   = @"121.538123";
    params[@"lat"]   = @"31.677132";
    params[@"dtype"] = @"xml";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    [manager GET:@"http://apis.juhe.cn/catering/query" parameters:params success:^(AFHTTPRequestOperation *operation,id responseObject){
        
        //将得到的xml数据写入相应的xml文件中
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *plistPath = [paths objectAtIndex:0];
        //得到完整的文件名
        NSString *fileName =[plistPath stringByAppendingPathComponent:@"data.xml"];
        NSLog(@"%@",fileName);
        NSFileManager *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:fileName]) {
            [manager createFileAtPath:fileName contents:nil attributes:nil];
        }
        [responseObject writeToFile:fileName atomically:YES];
        NSString *xmlString = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
        
        NSError *error;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        
        //取出所需数据放入到result数组中
        NSArray *array = [document nodesForXPath:@"root/result/item/navigation" error:nil];
        NSLog(@"%@", [array[1] stringValue]);
        for (int i = 0; i < array.count; i++) {
            NSString *navigation = [array[i] stringValue];
            
            [result addObject:navigation];
            
        }
//        [self.delegate data:result];
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        
        NSLog(@"error = %@",error);
        
    }];

    */
    
}

@end
