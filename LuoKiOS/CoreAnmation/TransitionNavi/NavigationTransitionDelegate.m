//
//  NavigationTransitionDelegate.m
//  TransitionDemo
//
//  Created by Frog Tan on 16/4/16.
//  Copyright © 2016年 Frog Tan. All rights reserved.
//

#import "NavigationTransitionDelegate.h"
#import "NavigationAnimationController.h"

@interface NavigationTransitionDelegate ()

@property (nonatomic, strong) NavigationPushAnimationController * pushAnimationController;
@property (nonatomic, strong) NavigationPopAnimationController  * popAnimationController;
@property (nonatomic, assign) BOOL                                isInteractiveMode;

@end



@implementation NavigationTransitionDelegate

- (instancetype)init {
    
    if(self = [super init]) {
        self.pushAnimationController = [[NavigationPushAnimationController alloc] init];
        self.popAnimationController  = [[NavigationPopAnimationController alloc] init];
        self.percentTransition       = [[UIPercentDrivenInteractiveTransition alloc] init];
    }
    
    return self;
}


- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    return self.isInteractiveMode ? self.percentTransition : nil;
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    
    if(operation == UINavigationControllerOperationPush) {
        
        return self.pushAnimationController;
    }
    else if(operation == UINavigationControllerOperationPop) {
        
        return self.popAnimationController;
    }
    
    return nil;
}


- (void)enterInteractiveMode {
    
    self.isInteractiveMode = YES;
}


- (void)leaveInteractiveMode {

    self.isInteractiveMode = NO;
}



@end


