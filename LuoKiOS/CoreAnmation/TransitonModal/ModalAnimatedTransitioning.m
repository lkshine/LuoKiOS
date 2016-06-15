//
//  ModalAnimatedTransitioning.m
//  LuoKiOS
//
//  Created by lkshine on 16/6/6.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "ModalAnimatedTransitioning.h"

@implementation ModalAnimatedTransitioning

// 动画执行的时间
static const CGFloat duration = 0.5;

#pragma mark - 返回动画执行的时间
- (NSTimeInterval)transitionDuration:(id )transitionContext {
    
    return duration;
}

#pragma mark - 执行动画的具体实例
- (void)animateTransition:(id )transitionContext {
    
    if (self.presented) {
        
        UIView * fromView        = [transitionContext viewForKey:UITransitionContextFromViewKey];
        UIView * toView          = [transitionContext viewForKey:UITransitionContextToViewKey];
        __block CGRect tempFrame = toView.frame;
        tempFrame.origin.y       = -toView.frame.size.height;
        toView.frame             = tempFrame;
        
        [UIView animateWithDuration:duration animations:^{

            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:fromView cache:YES];
            tempFrame.origin.y   = 0;
            toView.frame         = tempFrame;
                        
        } completion:^(BOOL finished) {

            [transitionContext completeTransition:YES];
        }];
    }
    else {

        UIView * toView          = [transitionContext viewForKey:UITransitionContextFromViewKey];
        __block CGRect tempFrame = toView.frame;
        
        [UIView animateWithDuration:duration animations:^{

            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:toView cache:YES];
            tempFrame.origin.y   = -toView.frame.size.height;;
            toView.frame         = tempFrame;
         
            
        } completion:^(BOOL finished) {
                             
            [transitionContext completeTransition:YES];
        }];
    }
    
}


#pragma mark -- 根据视图寻找控制器
- (UIViewController*)findViewController:(UIView *)view
{
    for (UIView* next = [view superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}



#pragma CATransition动画实现
- (void)transitionWithType:(NSString *)type WithSubtype:(NSString *)subtype ForView:(UIView *)view {
    
    //创建CATransition对象
    CATransition * animation = [CATransition animation];
    
    //设置运动时间
    animation.duration = duration;
    
    //设置运动type
    animation.type = type;
    animation.subtype = kCATransitionFromLeft;
 
    
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [view.layer addAnimation:animation forKey:@"animation"];
}



#pragma UIView实现动画
- (void) animationWithView : (UIView *)view WithAnimationTransition : (UIViewAnimationTransition) transition {
    
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:transition forView:view cache:YES];
    }];
}


@end
