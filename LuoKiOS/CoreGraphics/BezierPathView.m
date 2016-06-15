//
//  BezierPathView.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/31.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "BezierPathView.h"
#import "UIColor+Random.h"


@interface BezierPathView ()

@property (nonatomic, assign) CGPoint firstTouchPoint;
@property (nonatomic, assign) CGPoint lastTouchPoint;
@property (nonatomic,strong) UIImage *image;

@end



@implementation BezierPathView

- (instancetype)initWithCoder:(NSCoder *)coder {
    
    self = [super initWithCoder:coder];
    
    if (self) {
        
        _currentColor = [UIColor redColor];
        _useRandomColor = NO;
        _image = [UIImage imageNamed:@"iphone"];
    }
    
    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
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

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch * touch = [touches anyObject];
    
    self.lastTouchPoint = [touch locationInView:self];
    
    //绘图
    [self setNeedsDisplay];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    self.lastTouchPoint = [touch locationInView:self];
    
    //绘图
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    //获取上下文/环境
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //设置画笔宽度
    CGContextSetLineWidth(context, 3.0);
    //设置画笔颜色
    CGContextSetStrokeColorWithColor(context, self.currentColor.CGColor);
    
    
    //绘图
    switch (self.sharpType) {
            
        case kLineShape: {
            
            //创建绘图路径
            UIBezierPath *path = [UIBezierPath bezierPath];
            
            //设置起始点
            [path moveToPoint:self.firstTouchPoint];
            [path addLineToPoint:self.lastTouchPoint];
            
            //添加到上下文
            CGContextAddPath(context, path.CGPath);
            
            //渲染上下文
            CGContextStrokePath(context);
            
            break;
        }
            
        case kRectShape: {
            
            //获取矩形区域
            CGRect rect = CGRectMake(self.firstTouchPoint.x,
                                     self.firstTouchPoint.y,
                                     self.lastTouchPoint.x - self.firstTouchPoint.x,
                                     self.lastTouchPoint.y - self.firstTouchPoint.y);
            
            //创建绘图路径
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
            
            //添加到上下文
            CGContextAddPath(context, path.CGPath);
            
            //渲染上下文
            CGContextStrokePath(context);
            
            break;
            
        }
            
        case kEllipeShape: {
            
            //获取矩形区域
            CGRect rect = CGRectMake(self.firstTouchPoint.x,
                                     self.firstTouchPoint.y,
                                     self.lastTouchPoint.x - self.firstTouchPoint.x,
                                     self.lastTouchPoint.y - self.firstTouchPoint.y);
            //创建绘图路径
            UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
            
            //设置填充颜色
            CGContextSetFillColorWithColor(context, self.currentColor.CGColor);
            
            //添加到上下文
            CGContextAddPath(context, path.CGPath);
            
            //渲染上下文
            CGContextStrokePath(context);
            
            break;
            
        }
            
        case kImageShape: {
            
            [self.image drawAtPoint:CGPointZero];
            
            break;
        }
            
        default:
            break;
    }
    
}



@end



