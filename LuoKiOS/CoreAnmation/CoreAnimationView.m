//
//  CoreAnimationView.m
//  LuoKiOS --- 关键帧（KeyFrame）
//
//  Created by lkshine on 16/6/5.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "CoreAnimationView.h"

@interface CoreAnimationView ()

@property (weak, nonatomic) IBOutlet UIImageView * moveView;

@end


@implementation CoreAnimationView

+ (instancetype) basicAnimationView {
    
    CoreAnimationView * view = [[[NSBundle mainBundle] loadNibNamed:@"CoreAnimationView" owner:self options:nil] lastObject];
    
    return view;
}


/*移动动画实现*/
- (void)move {
    
    
    
    [UIView animateWithDuration:2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.moveView cache:YES];
        
        //初始化一个动画对象
        CABasicAnimation * animation  = [CABasicAnimation animation];
        
        //设置动画keyPath
        animation.keyPath             = @"position";
        
        //设置重复次数
        animation.repeatCount         = 0;//MAXFLOAT;
        
        //设置动画时长
        animation.duration            = 2.0;
        
        //不返回原位置
//        animation.removedOnCompletion = NO;
//        animation.fillMode            = kCAFillModeForwards;
        
        //设置变化的属性值
        CGPoint orignalPosition       = self.moveView.layer.position;
        CGFloat orignalX              = orignalPosition.x;
        CGFloat orignalY              = orignalPosition.y;
        animation.toValue             = [NSValue valueWithCGPoint:CGPointMake(orignalX + 150, orignalY)];
        
        
        //添加动画对象到view.layer
        [self.moveView.layer addAnimation:animation forKey:nil];
    }];
    
}

//初始化xib时候加载图片
- (void)awakeFromNib {
    
    self.moveView.layer.contents = (__bridge id)([UIImage imageNamed:@"SpiderMan"].CGImage);
}


//点击按钮开始动画
- (IBAction)clickChange:(id)sender {
    
    [self move];
    
}

@end
