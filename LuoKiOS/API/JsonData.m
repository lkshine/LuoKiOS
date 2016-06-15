//
//  JsonData.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/27.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "JsonData.h"

@implementation JsonData

- (void)getData {
    
//    __block NSMutableArray *result = [[NSMutableArray alloc] init];
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    //在数组里面添加请求参数，根据聚合数据的文档说明添加
    params[@"key"] = @"987d0c7bd487209bd5bb4065b3d4fcc2";
    params[@"lng"] = @"121.538123";
    params[@"lat"] = @"31.677132";
    //创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //发送请求
    [manager GET:@"http://apis.juhe.cn/catering/query" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        //如果数据请求成功返回到responseObject中
        NSMutableDictionary *datasouce=[responseObject mutableCopy];
//        //在返回的字典中通过关键字result索引到的数据存放到另外的数组中
//        NSArray * resultArray = [datasouce objectForKey:@"result"];
//        //遍历resultArray数组得到navigation对应的数据
//        for (NSDictionary *dic in resultArray) {
//            NSString *navigation = [dic objectForKey:@"navigation"];
//            [result addObject:navigation];
//        }
//        [self.delegate data:result];
        [self.delegate data:datasouce];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
