//
//  JsonData.h
//  LuoKiOS
//
//  Created by lkshine on 16/5/27.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParamsData.h"


@interface JsonData : NSObject

@property (nonatomic, weak) id <DataDelegate> delegate;//代理属性
- (void)getData;

@end
