//
//  LKObjcet.m
//  LuoKiOS
//
//  Created by lkshine on 16/7/23.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "LKObjcet.h"

@implementation LKObjcet

- (void)receiveNotification:(NSNotification *)notify {
    
    NSLog(@"notify");
}


-(void)dealloc{
    /**
     *  当对象销毁时，需要从通知中心删除监听对象
     */
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end

