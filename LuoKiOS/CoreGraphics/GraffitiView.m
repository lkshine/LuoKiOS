//
//  GraffitiView.m
//  LuoKiOS  -- 涂鸦
//
//  Created by lkshine on 16/6/4.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "GraffitiView.h"

@implementation GraffitiView

- (UIBezierPath *)path {
    
    if (_path == nil) {
        
        _path = [UIBezierPath bezierPath];
    }
    
    return _path;
}


- (NSMutableArray *)pathArray {
    
    if (_pathArray == nil) {
        
        _pathArray = [NSMutableArray array];
    }
    
    return _pathArray;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //开启一个新的路径对象
    UIBezierPath * path = [UIBezierPath bezierPath];
    self.path = path;
    //把当前路径添加到数组中
    [self.pathArray addObject:path];
    
    //获取当前触摸点
    UITouch * touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    //设置当前路径的开始点
    [path moveToPoint:touchPoint];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    UITouch * touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self];
    
    [self.path addLineToPoint:touchPoint];
    
    [self setNeedsDisplay];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch * touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self];
    
    [self.path addLineToPoint:touchPoint];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    if (!self.pathArray.count) return;
    
    for (UIBezierPath * path in self.pathArray) {
        
        [path stroke];
    }
    
}


- (void)clearAllPath {
    
    [self.pathArray removeAllObjects];
    [self setNeedsDisplay];
   
}

@end



