//
//  KeyFrameView.m
//  LuoKiOS
//
//  Created by lkshine on 16/6/5.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "KeyFrameView.h"


@interface KeyFrameView ()

@property (weak, nonatomic) IBOutlet UIImageView * searchIV;
@property (weak, nonatomic) IBOutlet UIImageView * contactsIV;
@property (weak, nonatomic) IBOutlet UIImageView * twitterIV;
@property (weak, nonatomic) IBOutlet UIImageView * snowIV;


@end


@implementation KeyFrameView

+ (instancetype)keyFrameAnimationView {
    
    KeyFrameView * view = [[[NSBundle mainBundle] loadNibNamed:@"KeyFrameView" owner:self options:nil] lastObject];
    
    return view;
}


- (void)moveBirdView {
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
    animation.keyPath               = @"position";
    //获取初始position
    CGPoint originalPosition        = self.twitterIV.layer.position;
    CGFloat originalX               = originalPosition.x;
    CGFloat originalY               = originalPosition.y;
    CGFloat moveMargin              = 20;
    //设置values属性
    NSValue *value1                 = [NSValue valueWithCGPoint:CGPointMake(originalX + moveMargin, originalY + moveMargin)];
    NSValue *value2                 = [NSValue valueWithCGPoint:CGPointMake(originalX + 2 * moveMargin, originalY)];
    NSValue *value3                 = [NSValue valueWithCGPoint:CGPointMake(originalX + moveMargin, originalY - moveMargin)];
    NSValue *value4                 = [NSValue valueWithCGPoint:originalPosition];
    //思考：开头不添加value4的动画效果
    animation.values                = @[value4, value1, value2, value3, value4];
    animation.duration              = 2.0;
    animation.repeatCount           = MAXFLOAT;
    
    [self.twitterIV.layer addAnimation:animation forKey:nil];
}


- (void)moveSearchView {
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
    animation.keyPath               = @"position";
    //获取初始position
    CGPoint originalPosition        = self.searchIV.layer.position;
    CGFloat originalX               = originalPosition.x;
    CGFloat originalY               = originalPosition.y;
    //初始化一个贝塞尔路径
    UIBezierPath *path              = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(originalX, originalY, 50, 20)];
    animation.path                  = path.CGPath;
    animation.duration              = 1.0;
    animation.repeatCount           = MAXFLOAT;
    animation.removedOnCompletion   = NO;
    animation.fillMode              = kCAFillModeForwards;
    
    [self.searchIV.layer addAnimation:animation forKey:nil];
}


- (void)shakeContactsView {
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
    animation.keyPath               = @"transform.rotation";
    CGFloat rotationValue1          = (6/180.0) * M_PI;
    CGFloat rotationValue2          = (-6/180.0) * M_PI;
    //注意数组存储基本数据类型的语法格式
    animation.values                = @[@(rotationValue2), @(rotationValue1), @(rotationValue2)];
    animation.duration              = 0.25;
    animation.repeatCount           = MAXFLOAT;
    
    [self.contactsIV.layer addAnimation:animation forKey:nil];
}


#pragma mark -- 本来我们是希望能展现一个按着一个圆圈旋转的雪花效果，但是没有效果，需要动画组来实现了
- (void)downSnowStorm {
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
    animation.keyPath               = @"transform.rotation.scale.move";
    CGFloat rotationValue1          = (60/180.0) * M_PI;
    CGFloat rotationValue2          = (-60/180.0) * M_PI;
    //注意数组存储基本数据类型的语法格式
    animation.values                = @[@(rotationValue2), @(rotationValue1), @(rotationValue2)];
    animation.duration              = 3;
    animation.repeatCount           = MAXFLOAT;
    
    
    //获取初始position
    CGPoint originalPosition        = self.snowIV.layer.position;
    CGFloat originalX               = originalPosition.x;
    CGFloat originalY               = originalPosition.y;
    //初始化一个贝塞尔路径
    UIBezierPath *path              = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(originalX, originalY, 50, 20)];
    animation.path                  = path.CGPath;


    CGFloat moveMargin              = 20;
    //设置values属性
    NSValue *value1                 = [NSValue valueWithCGPoint:CGPointMake(originalX + moveMargin, originalY + moveMargin)];
    NSValue *value2                 = [NSValue valueWithCGPoint:CGPointMake(originalX + 2 * moveMargin, originalY)];
    NSValue *value3                 = [NSValue valueWithCGPoint:CGPointMake(originalX + moveMargin, originalY - moveMargin)];
    NSValue *value4                 = [NSValue valueWithCGPoint:originalPosition];
    
   
    animation.values                = @[value4, @(rotationValue2), value2, @(rotationValue2), value1, @(rotationValue1), value3, value4];


    
    
    [self.snowIV.layer addAnimation:animation forKey:nil];
    
}



- (IBAction)clickPlay:(id)sender {
    
    [self moveBirdView];
    [self moveSearchView];
    [self shakeContactsView];
    [self downSnowStorm];
}


@end
