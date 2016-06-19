//
//  CoreAnimationCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/6/5.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "CoreAnimationCtrl.h"



/*
 
 iOS的Core Animation，有很多概念，包括Layer（层）、Animation（动画）和Timing（时序）、Layout（布局）和constraint（约束）、Transaction（处理）。其中Layer是最基础的。
 Layer有多种，最基本的是CALayer，它也是其他种类Layer的父类。CALayer的子类有：
 CAScrollLayer，用于简化显示层的一部分
 CATextLayer，便于从字符串生成内容是文本的层
 CATiledLayer，可用于显示复杂的图片
 CAOpenGLLayer，提供OpenGLES渲染环境
 Core Animation是基于QuartzCore的，需要在项目中引入框架
 
 */


/*
 我个人对动画的理解（LKAnimat），都是基于CALayer类来展现，
 1.首先说隐式动画，凭借layer本身属性的变化，默认在0.25s内展现的一套动画，但是该动画单一，单调，死板，没灵性;
 2.在单一的动画不能满足需求时，升级为了----基本动画，也就是可控时间，重复率，再layer上添加CABasicAnimation对象即可;
 3.依然没解决动画单调问题，升级成----关键帧，增加路线设定，由多个单一动画构成的“数组”，这样一来就可以按照既定的轨迹完成多个单一的动画，依托CAKeyframeAnimation对象完成；
 4.可是还是很死板，进化----动画组，变成了一个由多个关键帧组成的“集合”，就像一个字典一样，丰富了，有生气了~依托CAAnimationGroup对象完成
 5.但是它依然不是最完美的，最终形态----转场动画，增加过渡效果，使得每个动画衔接得更水灵，依托CATransition对象，终于有灵性了
 PS:这里我写的数组就是数组，集合就是集合，想表达的很明白，数组元素同一可重复，集合元素同一不可重复（重复keyPath只留最后一个），但是都会依照添加次序执行动画效果
 */

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

        _modalBtn       = [UIButton buttonWithType:UIButtonTypeSystem];
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



