//
//  LKSingleton.m
//  iOS知识点总结项目 -- 单例模式
//
//  Created by lkshine on 16/5/25.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "LKSingleton.h"

static LKSingleton *manager;

/*
    如果要了解单例，请务必参考该文章：http://www.cnblogs.com/NSong/p/5477845.html
 */


@implementation LKSingleton

static id _instance;   //也可以用manager一样写在类方法里面的参数


#pragma mark -- 不使用GCD的方式
+ (LKSingleton *)defaultManager {
    
    if (!manager)
        manager = [[self allocWithZone:NULL] init];

    return  manager;
}

#pragma mark -- 使用GCD的方式
+ (LKSingleton *)sharedManager {
    
    static dispatch_once_t predicate;
    static LKSingleton * sharedManager;
    
    dispatch_once(&predicate, ^{
        
        sharedManager = [[LKSingleton alloc] init];
    });
    
    return sharedManager;
}// 注明：dispatch_once这个函数，  它可以保证整个应用程序生命周期中某段代码只被执行一次！


#pragma mark -- 工厂方法写copy方法
+ (id)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {   // 遵守<NSCopying>就实现方法
    
    return _instance;
}


@end


/*
 
 @protocol NSCopying
 
 - (id)copyWithZone:(nullable NSZone *)zone;
 
 @end
 
 @protocol NSMutableCopying
 
 - (id)mutableCopyWithZone:(nullable NSZone *)zone;
 
 @end
 
 @protocol NSCoding
 
 - (void)encodeWithCoder:(NSCoder *)aCoder;
 - (nullable instancetype)initWithCoder:(NSCoder *)aDecoder; // NS_DESIGNATED_INITIALIZER
 
 @end
 
 */


