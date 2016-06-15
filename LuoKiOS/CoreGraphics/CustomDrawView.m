//
//  CustomDrawView.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/31.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "CustomDrawView.h"

@implementation CustomDrawView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"%s",__func__);
    
    self.useRandomColor = YES;
    
    //如果使用随机颜色，则获取随机颜色
    if (self.useRandomColor) {
        
        UIColor * randomColor = [UIColor randomColor];
        self.currentColor = randomColor;
    }
    
    UITouch * touch = [touches anyObject];
    self.firstTouchPoint = [touch locationInView:self];
    self.lastTouchPoint = self.firstTouchPoint;
    
    //绘图,调用drawRect方法
    [self setNeedsDisplay];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"%s",__func__);
    
    UITouch *touch = [touches anyObject];
    
    self.lastTouchPoint = [touch locationInView:self];
    
    //绘图
    [self setNeedsDisplay];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"%s",__func__);
    
    UITouch *touch = [touches anyObject];
    
    self.lastTouchPoint = [touch locationInView:self];
    
    //绘图
    [self setNeedsDisplay];
    
}




- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect    myFrame = self.bounds;
    
    //添加边框
    CGContextSetLineWidth(context, 10);
    CGRectInset(myFrame, 5, 5);
    
    [[UIColor greenColor] set];
    UIRectFrame(myFrame);

//    1、获取绘图上下文
//        CGContextRef context = UIGraphicsGetCurrentContext();
    
        //2、设置绘图路径
        //2.1 创建路径
        UIBezierPath *path = [UIBezierPath bezierPath];
    
        //2.2 创建起始点
        CGPoint startPoint = self.firstTouchPoint;
        CGPoint secondPoint = self.lastTouchPoint;
    
    //2.3 画线
        [path moveToPoint:startPoint];
        [path addLineToPoint:secondPoint];
        [path closePath];
    
    //2.4 设置线的属性
        [[UIColor redColor] setStroke];
    
    //3、设置绘图的状态（一定要在渲染之前）
        CGContextSetLineWidth(context, 3.0);
    
        //4、添加路径到上下文
        CGContextAddPath(context, path.CGPath);
    
        //5、渲染上下文
        CGContextStrokePath(context);
}


//- (void)drawRect:(CGRect)rect {
//    
//    //1、获取绘图上下文
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    //2、设置绘图路径
//    //2.1 创建路径
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    
//    //2.2 创建起始点
//    CGPoint startPoint = _firstTouchPoint;//CGPointMake(5 + 30, 5 + 90);
//    CGPoint secondPoint = _lastTouchPoint;//CGPointMake(50+30, 95+90);
////    CGPoint thirdPoint = CGPointMake(95+30, 5+90);
//    
//    //2.3 画线
//    [path moveToPoint:startPoint];
//    [path addLineToPoint:secondPoint];
////    [path addLineToPoint:thirdPoint];
//    [path closePath];
//    
//    //2.4 设置线的属性
//    [[UIColor redColor] setStroke];
//    
//    //2.5 设置填充颜色
//    [[UIColor yellowColor] setFill];
//    [path fill];
//    
//    //3、设置绘图的状态（一定要在渲染之前）
//    CGContextSetLineWidth(context, 3.0);
//    
//    //4、添加路径到上下文
//    CGContextAddPath(context, path.CGPath);
//    
//    //5、渲染上下文
//    CGContextStrokePath(context);
//    
//}


@end


