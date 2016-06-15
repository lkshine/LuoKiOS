//
//  NumberGroup.h
//  iOS知识点总结项目 ----- 二维对象模型《一维数组，二维字典，三维链表》
//
//  Created by lkshine on 16/5/15.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NumberGroup : NSObject    //二维数组对象

@property (nonatomic, copy  ) NSString       * groupHeader;
@property (nonatomic, copy  ) NSString       * groupFooter;
@property (nonatomic, copy  ) NSString       * groupIndex;
@property (nonatomic, strong) NSMutableArray * groupNumbers;

+ (instancetype)numberGroup;

@end
