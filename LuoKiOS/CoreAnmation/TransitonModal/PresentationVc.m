//
//  PresentationVc.m
//  LuoKiOS
//
//  Created by lkshine on 16/6/6.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "PresentationVc.h"

@implementation PresentationVc

#pragma mark - 设置大小的frame，自定义动画时无用
//- (CGRect)frameOfPresentedViewInContainerView{
//    return CGRectMake(10, 20, 200, 200);
//}

#pragma mark - 开始动画添加的
- (void)presentationTransitionWillBegin {
    
    [self.containerView addSubview:self.presentedView];
}


- (void)presentationTransitionDidEnd:(BOOL)completed {
    
    NSLog(@"presentationTransitionDidEnd");
}


- (void)dismissalTransitionWillBegin {
    
    NSLog(@"dismissalTransitionWillBegin");
}


#pragma mark - dismiss动画结束后移除的
- (void)dismissalTransitionDidEnd:(BOOL)completed {
    
    [self.presentedView removeFromSuperview];
    NSLog(@"dismissalTransitionDidEnd");
}


@end
