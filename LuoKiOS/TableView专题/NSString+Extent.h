//
//  NSString+Extent.h
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/15.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>    //注意分类的使用时要导入该框架



@interface NSString (Extent)

-(CGFloat) heightWithText:(NSString *) text font:(UIFont *) font width:(CGFloat) width;

@end
