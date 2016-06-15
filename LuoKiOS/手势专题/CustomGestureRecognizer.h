//
//  CustomGestureRecognizer.h
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/11.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DirectionUnknown = 0,
    DirectionLeft,
    DirectionRight
} Direction;


@interface CustomGestureRecognizer : UIGestureRecognizer

@property (nonatomic,assign) int tickleCount;
@property (nonatomic,assign) CGPoint curTickleStart;
@property (nonatomic,assign) Direction lastDirection;

@end
