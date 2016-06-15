//
//  NavigationTransitionDelegate.h
//  TransitionDemo
//
//  Created by Frog Tan on 16/4/16.
//  Copyright © 2016年 Frog Tan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class NavigationPopAnimationController;


@interface NavigationTransitionDelegate : NSObject<UINavigationControllerDelegate>

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition * percentTransition;

- (void)enterInteractiveMode;
- (void)leaveInteractiveMode;

@end



