//
//  KCImageData.h
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/22.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCImageData : NSObject

#pragma mark 索引
@property (nonatomic,assign) int index;

#pragma mark 图片数据
@property (nonatomic,strong) NSData *data;

@end
