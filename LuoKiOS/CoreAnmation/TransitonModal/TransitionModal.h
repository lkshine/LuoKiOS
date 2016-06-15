//
//  TransitionModal.h
//  LuoKiOS
//
//  Created by lkshine on 16/6/6.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransitionModal : NSObject<UIViewControllerTransitioningDelegate>

// 创建一个单例实例

+ (instancetype)sharedTransitioning;

@end
