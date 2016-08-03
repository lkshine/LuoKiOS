//
//  TestClass.h
//  LuoKiOS
//
//  Created by lkshine on 16/7/29.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestClass : NSObject

@property (nonatomic, copy) void (^midBlock)();
- (void)test;

@end
