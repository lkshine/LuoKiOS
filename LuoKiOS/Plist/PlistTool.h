//
//  PlistTool.h
//  LuoKiOS
//
//  Created by lkshine on 16/5/27.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistTool : NSObject

/*get data*/
- (NSMutableArray *)getAllData;
/*add data*/
- (void)addNewDataWith:(NSString *)data;
/*delete data*/
- (void)deleteDataWith:(NSString *)data;

@end