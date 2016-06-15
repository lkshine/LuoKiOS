//
//  TransitionModal.m
//  LuoKiOS
//
//  Created by lkshine on 16/6/6.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "TransitionModal.h"
#import "PresentationVc.h"
#import "ModalAnimatedTransitioning.h"


@implementation TransitionModal

static id _instance = nil;

+ (instancetype)sharedTransitioning {
    
    if (!_instance) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            _instance = [[self alloc] init];
        });
    }
    
    return _instance;
}

#pragma mark - PrsentView的
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    
    return [[PresentationVc alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}


#pragma mark - 开始动画调用
- (id )animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    ModalAnimatedTransitioning * startA = [[ModalAnimatedTransitioning alloc] init];
    startA.presented = YES;
    
    return startA;
}

#pragma mark - disMiss调用
- (id )animationControllerForDismissedController:(UIViewController *)dismissed {
    
    ModalAnimatedTransitioning * endA = [[ModalAnimatedTransitioning alloc] init];
    endA.presented = NO;
    
    return endA;
}



@end


