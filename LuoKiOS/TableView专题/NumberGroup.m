//
//  NumberGroup.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/15.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "NumberGroup.h"

@implementation NumberGroup

+ (instancetype)numberGroup {
    
    NumberGroup * numberGroup = [NumberGroup new];
    
    //设置数据
    numberGroup.groupHeader = [NSString stringWithFormat:@"Header:%d", arc4random_uniform(10000)];
    numberGroup.groupFooter = [NSString stringWithFormat:@"Footer:%d", arc4random_uniform(10000)];
    numberGroup.groupIndex  = [NSString stringWithFormat:@"Index:%d", arc4random_uniform(10)];
    
    NSMutableArray * tempArray = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        
//        NSString * number = [NSString stringWithFormat:@"cell:%d", arc4random_uniform(1000000)];
//        [tempArray addObject:number];
        
        Number * number = [Number number];
        [tempArray addObject:number];
        
    }
    
    numberGroup.groupNumbers = tempArray;
    
    return numberGroup;
    
}


#pragma mark -- 打印NumberGroup类时候会调用的工厂方法和类方法
- (NSString *)description {
    /*
     // 错误示范
     return [NSString stringWithFormat:@"%@", self];
     */
    return [NSString stringWithFormat:@"NumberGroup_groupHeader: %@, groupFooter: %@, groupIndex: %@, groupNumbers: %@", self.groupHeader, self.groupFooter, self.groupIndex, self.groupNumbers];
}
//自己实现description方法可以“打印类”（我们想要看到class的内容），更加便于调试，但是在description方法中不要返回或者打印self。

+ (NSString *)description {
    
    return @"NumberGroup";
}



@end
