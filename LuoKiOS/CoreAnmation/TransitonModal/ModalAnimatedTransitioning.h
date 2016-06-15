//
//  ModalAnimatedTransitioning.h
//  LuoKiOS
//
//  Created by lkshine on 16/6/6.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModalAnimatedTransitioning : NSObject

// 是否是开始modal进来的
@property (nonatomic , assign) BOOL presented;

@end


/*
  
 ModalAnimatedTransitioning是封装了UIViewControllerAnimatedTransitioning代理协议里面的方法，具体的动画实现
 
 */