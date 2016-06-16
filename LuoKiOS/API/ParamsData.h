//
//  ParamsData.h  -- 在模型内进行网络请求操作
//  LuoKiOS
//
//  Created by lkshine on 16/5/26.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataDelegate //通过代理将得到的JSON数据传递到Ctrl

- (void)data:(NSMutableDictionary *)dic;

@end



@interface ParamsData : NSObject

@property (nonatomic, copy) void(^dataBlock)(NSMutableDictionary *);
@property (nonatomic, weak) id <DataDelegate> delegate;//代理属性
@property (nonatomic, strong) NSMutableDictionary * dic;

- (void)getdata;//在Ctrl中执行此方法从而得到JSON数据

@end
