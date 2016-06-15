//
//  AnimationGroupView.m
//  LuoKiOS
//
//  Created by lkshine on 16/6/5.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "AnimationGroupView.h"

@interface AnimationGroupView ()

@property (weak, nonatomic) IBOutlet UIImageView * snowIV;
@property (weak, nonatomic) IBOutlet UIButton * palyBtn;

@end



@implementation AnimationGroupView


+ (instancetype)animationGroupView {
    
    AnimationGroupView * view = [[[NSBundle mainBundle] loadNibNamed:@"AnimationGroupView" owner:self options:nil] lastObject];
    
    return view;
}


/*开始播放*/
- (void) beginAnimation {
    
    /*动画1设置*/
    CAKeyframeAnimation * animation1  = [CAKeyframeAnimation animation];
    animation1.keyPath                = @"position";
    //获取初始position
    CGPoint originalPosition          = self.snowIV.layer.position;
    CGFloat originalX                 = originalPosition.x;
    CGFloat originalY                 = originalPosition.y;
    NSValue * animation1Value1        = [NSValue valueWithCGPoint:CGPointMake(originalX + 160, originalY)];
    NSValue * animation1Value2        = [NSValue valueWithCGPoint:originalPosition];
    animation1.values                 = @[animation1Value2, animation1Value1, animation1Value2];

    /*动画2设置*/
    CAKeyframeAnimation * animation2  = [CAKeyframeAnimation animation];
    animation2.keyPath                = @"transform.scale";
    animation2.values                 = @[@(1.0), @(3.0), @(1.0)];

    /*动画3设置*/
    CAKeyframeAnimation * animation3  = [CAKeyframeAnimation animation];
    animation3.keyPath                = @"opacity";
    animation3.values                 = @[@(1.0), @(0.4), @(1.0)];


    /*动画4设置*/
    CAKeyframeAnimation * animation4  = [CAKeyframeAnimation animation];
    animation4.keyPath                = @"transform.rotation";
    CGFloat rotationValue1            = M_PI;
    CGFloat rotationValue2            = -M_PI;
    //注意数组存储基本数据类型的语法格式
    animation4.values                 = @[@(rotationValue2), @(rotationValue1), @(rotationValue2)];
    
    /*动画40设置*/
    CAKeyframeAnimation * animation40  = [CAKeyframeAnimation animation];
    animation40.keyPath                = @"transform.rotation";
    CGFloat rotationValue10            = M_PI/2;
    CGFloat rotationValue20            = 2*M_PI/3;
    //注意数组存储基本数据类型的语法格式
    animation40.values                 = @[@(rotationValue20), @(rotationValue10), @(rotationValue2)];


    /*动画5设置*/
    CAKeyframeAnimation * animation5 = [CAKeyframeAnimation animation];
    animation5.keyPath               = @"position";
    //初始化一个贝塞尔路径
    UIBezierPath * path              = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(originalX, originalY, 50, 20)];
    animation5.path                  = path.CGPath;


    /*  animation.keyPath = @"string" ，该string值是对应动画的内部key值，所以不能乱写，并且多个重复string，内容不同，也只会执行最后一个*/
    
    /*设置动画组*/
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.animations         = @[animation1, animation2, animation3, animation4, animation5, animation40];
    animationGroup.duration           = 2.0;
    animationGroup.repeatCount        = MAXFLOAT;
    
    [self.snowIV.layer addAnimation:animationGroup forKey:nil];
}


//利用selected值判断开始动画还是暂停动画
#pragma mark -- 通过layer.timeOffset属性记录时间
- (IBAction)clickBtn:(id)sender {
    
    if (self.palyBtn.selected == NO) {
        
        //播放动画
        [self playAnimation];
        
        //修改按钮状态
        self.palyBtn.selected = YES;
    }
    else if (self.palyBtn.selected == YES) {
        
        //暂停播放
        [self pauseAnimation];
        
        //修改按钮状态
        self.palyBtn.selected = NO;
    }
    
}


//利用layer.speed的值判断是继续播放还是开始播放，刚开始layer.speed的值为1
- (void)playAnimation {
    
    //根据layer.speed的值来处理 开始--暂停--继续 逻辑
    if (self.snowIV.layer.speed == 1.0) {
        
        [self beginAnimation]; //开始播放
    }
    else if (self.snowIV.layer.speed == 0.0) {
        
        [self resumeAnimation];//继续播放
    }
    
}


/*暂停播放*/
- (void)pauseAnimation {
    
    CALayer * layer           = self.snowIV.layer;
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed               = 0.0;
    layer.timeOffset          = pausedTime;
    
}


/*继续播放*/
- (void)resumeAnimation {
    
    CALayer *layer                = self.snowIV.layer;
    CFTimeInterval pausedTime     = [layer timeOffset];
    layer.speed                   = 1.0;
    layer.timeOffset              = 0.0;
    layer.beginTime               = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime               = timeSincePause;
    
}



@end
