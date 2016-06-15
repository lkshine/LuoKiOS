//
//  Number.h
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/15.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Number : NSObject

@property (nonatomic, copy ) NSString * titleNumber;
@property (nonatomic, copy ) NSString * detailDescription;

//根据内容计算所需高度
@property (nonatomic,assign) CGFloat    cellLabelHeight;

+ (instancetype)number;

@end




//iOS面试题： http://zhangmingwei.iteye.com/blog/1748431