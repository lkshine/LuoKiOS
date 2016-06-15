//
//  TransitionView.m
//  LuoKiOS
//
//  Created by lkshine on 16/6/5.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "TransitionView.h"

@interface TransitionView ()

@property (weak, nonatomic  ) IBOutlet UIImageView * imageView;
@property (nonatomic, weak  ) IBOutlet UIButton    * button;
@property (nonatomic, strong) NSTimer              * timer;
@property (nonatomic, assign) int                    index;

@end



@implementation TransitionView

+ (instancetype) transitionView {
    
    TransitionView * view = [[[NSBundle mainBundle] loadNibNamed:@"TransitionView" owner:self options:nil] lastObject];
    
    return view;
}


- (IBAction)clickBtn:(UIButton *)sender {
    
    //更新按钮状态
    sender.enabled       = NO;

    //更新开始图片
    self.imageView.image = [UIImage imageNamed:@"CountDown3"];

    //初始化index
    self.index           = 2;

    //启动时钟
    self.timer           = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(updateImageView)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)updateImageView {
    
    //更新页面显示
    NSString * fileName      = [NSString stringWithFormat:@"CountDown%d",self.index];
    self.imageView.image     = [UIImage imageNamed:fileName];

    //添加动画
    CATransition * animation = [CATransition animation];
    animation.type           = @"cube";
    animation.duration       = 0.75;
    [self.imageView.layer addAnimation:animation forKey:nil];
    
    //更新Index
    self.index--;
    
    //index = 0，更新按钮状态，停止时钟，重置index，重置图片
    if (self.index < 0) {
        
        [self.timer invalidate];
        self.button.enabled = YES;
        self.index = 2;
        
    }
    
}


@end



