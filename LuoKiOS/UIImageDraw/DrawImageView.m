//
//  DrawImageView.m
//  LuoKiOS
//
//  Created by lkshine on 16/6/4.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "DrawImageView.h"

@implementation DrawImageView


#pragma mark -- 重写drawRect:方法
- (void)drawRect:(CGRect)rect {
    
    [self.customImage drawInRect:rect];
    
    
    UIImage * image1 = self.customImage;

    NSString * path  = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
    UIImage * image2 = [UIImage imageWithContentsOfFile:path];
    
    NSLog(@"\n\t🚩\n rect = %@ \n\t📌", NSStringFromCGRect(rect));
    //先绘制image1
    [image1 drawInRect:rect];
    
    //再绘制image2
    [image2 drawAtPoint:CGPointZero];
    
}


#pragma mark -- 重写set方法
- (void)setCustomImage:(UIImage *)customImage {
    
    _customImage = customImage;
    [self setNeedsDisplay];
    
}

- (void)layoutSubviews {
    
    [self setNeedsDisplay];
    
}


@end


