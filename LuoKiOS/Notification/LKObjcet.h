//
//  LKObjcet.h
//  LuoKiOS
//
//  Created by lkshine on 16/7/23.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKObjcet : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * favorite;

- (void)receiveNotification:(NSNotification *)notify;

@end
