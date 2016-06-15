//
//  NavigationAnimationController.m
//  TransitionDemo
//
//  Created by Frog Tan on 16/4/16.
//  Copyright © 2016年 Frog Tan. All rights reserved.
//

#import "NavigationAnimationController.h"

#define TRANSITION_DURATION 0.5f

@implementation NavigationPushAnimationController
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    return TRANSITION_DURATION;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

    UIView * fromView            = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView * toView              = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView * containerView       = [transitionContext containerView];

    [containerView addSubview:toView];
    toView.frame                 = containerView.bounds;

    CATransform3D scaleTransform = CATransform3DMakeScale(0.6f, 0.6f, 0.6f);
    CATransform3D translationR   = CATransform3DMakeTranslation(containerView.frame.size.width, 0, 0);
    CATransform3D translationL   = CATransform3DMakeTranslation(-containerView.frame.size.width, 0, 0);
    
    CATransform3D rotationTransform = CATransform3DMakeRotation(0.6f, 0.6f, 0.6f,0.6f);
    toView.layer.transform       = translationR;
    
    [UIView animateWithDuration:TRANSITION_DURATION
                     animations:^{
                         
                         toView.layer.transform   = CATransform3DIdentity;
                         fromView.layer.transform = CATransform3DConcat(translationL, rotationTransform);
                     }
                     completion:^(BOOL finished) {
                         
                         toView.layer.transform   = CATransform3DIdentity;
                         fromView.layer.transform = CATransform3DIdentity;
                         BOOL cancelled           = [transitionContext transitionWasCancelled];
                         [transitionContext completeTransition:!cancelled];
                     }];
    
}


@end



@implementation NavigationPopAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    return TRANSITION_DURATION;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:toView];
    toView.frame = containerView.bounds;
    
    CATransform3D scaleTransform = CATransform3DMakeScale(0.6f, 0.6f, 0.6f);
    CATransform3D translationR = CATransform3DMakeTranslation(containerView.frame.size.width, 0, 0);
    CATransform3D translationL = CATransform3DMakeTranslation(-containerView.frame.size.width, 0, 0);
    CATransform3D rotationTransform = CATransform3DMakeRotation(0.6f, 0.6f, 0.6f,0.6f);
    toView.layer.transform = translationL;
    
    [UIView animateWithDuration:TRANSITION_DURATION
                     animations:^{
                         
                         toView.layer.transform = CATransform3DIdentity;
                         fromView.layer.transform = CATransform3DConcat(translationR, rotationTransform);
                     }
                     completion:^(BOOL finished) {
                         
                         toView.layer.transform = CATransform3DIdentity;
                         fromView.layer.transform = CATransform3DIdentity;
                         BOOL cancelled = [transitionContext transitionWasCancelled];
                         [transitionContext completeTransition:!cancelled];
                     }];
}


@end



