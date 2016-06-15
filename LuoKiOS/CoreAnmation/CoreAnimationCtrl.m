//
//  CoreAnimationCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/6/5.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "CoreAnimationCtrl.h"

@interface CoreAnimationCtrl ()

@property (nonatomic, weak  ) CoreAnimationView  * basicAnimationView;
@property (nonatomic, weak  ) KeyFrameView       * keyFrameAnimationView;
@property (nonatomic, weak  ) AnimationGroupView * animationGroupView;
@property (nonatomic, weak  ) TransitionView     * transitionView;
@property (nonatomic, strong) UIButton           * modalBtn;
@end


/* 转场动画（navi/modal）参考：http://www.cocoachina.com/ios/20160215/15263.html*/

@implementation CoreAnimationCtrl


- (UIButton *)modelBtn {
    
    if (!_modalBtn) {
        
        _modalBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _modalBtn.frame = CGRectMake(wSrceem-70, 80, 50, 40);
        [_modalBtn setTitle:@"modal" forState:UIControlStateNormal];
        [_modalBtn setTintColor:[UIColor redColor]];
        [self.view addSubview:_modalBtn];
        [_modalBtn addTarget:self action:@selector(modelAction:) forControlEvents:UIControlEventTouchDown];
    }
    
    return _modalBtn;
}


#pragma mark -- 转场Modal动画
- (void)modelAction:(UIButton *)sender {
    
    CameraCtrl * cameraCtrl = [CameraCtrl new];
    
    //系统modal动画
//    cameraCtrl.modalTransitionStyle = 1;

    // 自定义modal动画
    cameraCtrl.view.frame = [UIScreen mainScreen].bounds; // 这里设置下个视图控制器的frame很有必要效果自检
    cameraCtrl.modalPresentationStyle = UIModalPresentationCustom;
    // 过渡的delegate
    cameraCtrl.transitioningDelegate = [TransitionModal sharedTransitioning];
    
    [self presentViewController:cameraCtrl animated:YES completion:nil];
    
}


- (CoreAnimationView *)basicAnimationView {
    
    if (_basicAnimationView == nil) {
        
        CoreAnimationView * basicAnimationView = [CoreAnimationView basicAnimationView];
//        basicAnimationView.backgroundColor     = [UIColor orangeColor];
        _basicAnimationView                    = basicAnimationView;

        //设置frame
        basicAnimationView.frame               = CGRectMake(0, 20, 375, 150);
        [self.view addSubview:basicAnimationView];
    }
    
    return _basicAnimationView;
}


- (KeyFrameView *)keyFrameAnimationView {
    
    if (_keyFrameAnimationView == nil) {
        
        KeyFrameView * keyFrameAnimationView  = [KeyFrameView keyFrameAnimationView];
//        keyFrameAnimationView.backgroundColor = [UIColor redColor];
        _keyFrameAnimationView                = keyFrameAnimationView;
        
        //设置frame
        keyFrameAnimationView.frame           = CGRectMake(0, 190, 375, 100);
        [self.view addSubview:keyFrameAnimationView];
    }
    
    return _keyFrameAnimationView;
}


-  (AnimationGroupView *)animationGroupView {
    
    if (_animationGroupView == nil) {
        
        AnimationGroupView *animationGroupView = [AnimationGroupView animationGroupView];
        _animationGroupView                    = animationGroupView;
        
        //设置frame
        animationGroupView.frame               = CGRectMake(0, 310, 375, 200);
        [self.view addSubview:animationGroupView];
    }
    
    return _animationGroupView;
}


- (TransitionView *)transitionView {
    
    if (_transitionView == nil) {
        
        TransitionView * transitionView = [TransitionView transitionView];
        _transitionView                 = transitionView;

        transitionView.frame            = CGRectMake(0, 530, 375, 182);

        [self.view addSubview:transitionView];
    }
    
    return _transitionView;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self basicAnimationView];
    [self keyFrameAnimationView];
    [self animationGroupView];
    [self transitionView];
    [self modelBtn];
    
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end



