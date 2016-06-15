//
//  CustomGestureRecognizer.m
//  iOS知识点总结项目----自定义手势（左右擦拭滑动）
//
//  Created by lkshine on 16/5/11.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "CustomGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

#define REQUIRED_TICKLES        2
#define MOVE_AMT_PER_TICKLE     25

/*
 
 代码解析：
 先获取起始坐标：curTickleStart
 通过和ticklePoint的x值对比，得出当前的放下是向左还是向右。
 再算出移动的x的值是否比MOVE_AMT_PER_TICKLE距离大，如果太则返回。
 再判断是否有三次是不同方向的动作，如果是则手势结束，回调。
 
 */


@implementation CustomGestureRecognizer


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch * touch = [touches anyObject];
    self.curTickleStart = [touch locationInView:self.view];
    
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // Make sure we've moved a minimum amount since curTickleStart
    UITouch * touch = [touches anyObject];
    CGPoint ticklePoint = [touch locationInView:self.view];
    CGFloat moveAmt = ticklePoint.x - self.curTickleStart.x;
    Direction curDirection;
    if (moveAmt < 0) {
        
        curDirection = DirectionLeft;
        
    }
    else {
        
        curDirection = DirectionRight;
        
    }
    
    if (ABS(moveAmt) < MOVE_AMT_PER_TICKLE) return;
    
    // 确认方向改变了
    if (self.lastDirection == DirectionUnknown ||
        (self.lastDirection == DirectionLeft && curDirection == DirectionRight) ||
        (self.lastDirection == DirectionRight && curDirection == DirectionLeft)) {
        
        // 挠痒次数
        self.tickleCount++;
        self.curTickleStart = ticklePoint;
        self.lastDirection = curDirection;
        
        // 一旦挠痒次数超过指定数，设置手势为结束状态
        // 这样回调函数会被调用。
        if (self.state == UIGestureRecognizerStatePossible && self.tickleCount > REQUIRED_TICKLES) {
            [self setState:UIGestureRecognizerStateEnded];
        }
    }
    
}

- (void)reset {
    
    self.tickleCount = 0;
    self.curTickleStart = CGPointZero;
    self.lastDirection = DirectionUnknown;
    
    if (self.state == UIGestureRecognizerStatePossible) {
        
        [self setState:UIGestureRecognizerStateFailed];
        
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self reset];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self reset];
    
}


@end


