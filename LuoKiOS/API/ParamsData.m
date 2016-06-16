//
//  ParamsData.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/26.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "ParamsData.h"




#define kAPI_Url    @"http://apis.baidu.com/heweather/weather/free"
#define kBaidu_Key  @"b3e67c1aa92b533b4596d7a3b7356d8f"

@implementation ParamsData
{
    NSMutableDictionary * _gDic;
}



- (void)getdata {

    NSString *httpUrl = @"http://apis.baidu.com/heweather/weather/free";
    NSString *httpArg = @"city=beijing";
//    [self request: httpUrl withHttpArg: httpArg];
    [self request1: httpUrl withHttpArg: httpArg];
    
}


#pragma mark -- connection 带header
-(void)request:(NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    
    NSString * urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL * url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: kBaidu_Key forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               
                               if (error) {
                                   
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               }
                               else {
                                   
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSString * responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   
                                   NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                   NSLog(@"Connection_Dic = %@,", dictionary);
                                   NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
                                   [self.delegate data:dic];
                                   NSLog(@"HttpResponseCode:%ld", responseCode);
                                   NSLog(@"HttpResponseBody %@",responseString);
                                
                               }
                           }];
}


#pragma mark -- AFNetworking 带header
-(void)request1: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    
//    __block NSMutableArray * result = [[NSMutableArray alloc] init];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];//[NSMutableDictionary dictionaryWithDictionary:dic];

    //在数组里面添加请求参数，根据聚合数据的文档说明添加
    params[@"city"] = @"beijing";

    

    //创建请求管理者
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:kBaidu_Key forHTTPHeaderField:@"apikey"];
    
/*
 关与AFNetworking设置header设置
 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
 manager.requestSerializer = [AFJSONRequestSerializer serializer];
 manager.responseSerializer = [AFJSONResponseSerializer serializer];
 [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
 [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
 
 */
    
    //发送请求
    [manager GET:kAPI_Url
      parameters:params
         success:^(NSURLSessionDataTask *task, id responseObject) {
             
            //如果数据请求成功返回到responseObject中
            NSMutableDictionary * datasouce = [responseObject mutableCopy];

            NSLog(@"Session_Dic = %@,", datasouce);
            //        //在返回的字典中通过关键字result索引到的数据存放到另外的数组中
            //        NSArray * resultArray = [datasouce objectForKey:@"HeWeather data service 3.0"];
            //
            //        //遍历resultArray数组得到navigation对应的数据
            //        for (NSDictionary * dic in resultArray) {
            //            NSArray * navigation = [dic objectForKey:@"basic"];
            //            [result addObject:navigation];
            //        }

            //代理存档
            if (self.delegate) {

                [self.delegate data:datasouce];
            }


            //属性存档
            if (self.dic) {

                self.dic = datasouce;
            }


            //block存档
//            if (self.dataBlock) {

                self.dataBlock(datasouce);
//            }  //这三种套不套外层的if都可以
     
    }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             
             NSLog(@"%@",error);
    }];


}


#pragma mark -- PS:很多时候，我会忘记block怎么用了，不妨回头看看找感觉：http://blog.csdn.net/lct710992308/article/details/50681337





@end

/*
 
 pod导入第三方库的时候，可以我们本地就有导入过，就会导致编译是报警告One of the two will be used. Which one is undefined.
 比如之前导入AFNetworking时，处理方法就是在 other linker flags 里处理重复的即可
 http://blog.csdn.net/cyp1992888/article/details/51354734
 
 */





