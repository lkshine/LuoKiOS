//
//  NullVC.m
//  LuoKiOS
//
//  Created by lkshine on 16/7/27.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "NullVC.h"

@interface NullVC ()

@end

@implementation NullVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSDictionary *testDic = [self configDictionaryData];
    
//    if ([testDic isKindOfClass:[NSDictionary class]] && testDic.count > 0) {
//        if ([testDic[@"array"] isKindOfClass:[NSArray class]] && testDic.count > 0) {
//            NSLog(@"model.array:%@",testDic[@"array"]);
//        }
//        else {
//            NSLog(@"空");
//        }
//    }
    
    NSLog(@"model.array:%@",testDic[@"array"]);
    
    NSArray *array = testDic[@"array"];
    
    NSLog(@"first object:%@",array[0]);
    
    NSArray * A = @[@1, @2, @3];
    NSArray * B = @[@1, @3, @4];
    
    NSArray * C = [self getBoth:A and:B];
    NSLog(@"C = %@", C);
}

/*
 模拟网络返回给我们的数据情况，在有无NSNull扩展的情况下，给出测试结果
 
 没有扩展的话会报错为：-[NSNull objectAtIndexedSubscript:]: unrecognized selector sent to instance 0x10d718d80
 上面报错是一个不存在的对象发了消息引起的crash，需要我们对数据进行判断是否为空，
 而我们知道oc里可以让一个空对象去发消息就不会出问题了，
 所以只需要对NSNull类进行扩展(类目)，就可以省去繁琐的判断行为了
 顺便提下，导入一个类的category后，不用添加其头文件就可以正常使用了
 */
- (NSDictionary *)configDictionaryData{
    //1 先来个正常的数组
//        return [[NSDictionary alloc]
//                        initWithObjectsAndKeys:@"小菜", @"name"
//                        ,[NSArray arrayWithObjects:@"K1",@"K2", nil], @"array"
//                        ,nil];
    
    //2 来个坑爹的数组
    return [[NSDictionary alloc]
            initWithObjectsAndKeys:@"小菜", @"name"
            ,[NSNull null], @"array"
            ,nil];
    
}


#pragma mark -- 谓词方法获取两个数组的共同元素
- (NSArray *)getBoth:(NSArray *)arrA and:(NSArray *)arrB {
    
    NSArray *bothArr = [arrA filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF in %@", arrB]];

    return bothArr;
}



@end



