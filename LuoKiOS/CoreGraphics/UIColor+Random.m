//
//  UIColor+Random.m
//  OneYuanWinPrecious
//
//  Created by lkshine on 16/1/18.
//  Copyright © 2016年 luok. All rights reserved.
//

#import "UIColor+Random.h"
#import <UIKit/UIKit.h>



@implementation UIColor (Random)


+(UIColor *)randomColor{
    
    static BOOL seed = NO;
    
    if (!seed) {
        
        seed = YES;
        srandom((unsigned)time(NULL));
        
    }
    
    CGFloat red = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];//alpha为1.0,颜色完全不透明
    
}


@end