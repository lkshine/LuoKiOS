//
//  MotionEffectCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/6/19.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "MotionEffectCtrl.h"
#import "UIView+MotionEffect.h"



//http://www.tuicool.com/articles/FZV3qi
@interface MotionEffectCtrl ()
@property (nonatomic, strong) UIMotionEffectGroup *foregroundMotionEffect;
@end

@implementation MotionEffectCtrl

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SpiderMan"]];
    [self.view addSubview:imageView];
    imageView.center = self.view.center;
    
    imageView.effectGroup = [UIMotionEffectGroup new];
    [imageView addXAxisWithValue:50.f YAxisWithValue:50.f];
    
    
    
//    {
//        UIInterpolatingMotionEffect *xAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
//        xAxis.minimumRelativeValue = @(-150.0);
//        xAxis.maximumRelativeValue = @(150.0);
//        
//        UIInterpolatingMotionEffect *yAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
//        yAxis.minimumRelativeValue = @(-150.0);
//        yAxis.maximumRelativeValue = @(150.0);
//        
//        self.foregroundMotionEffect = [[UIMotionEffectGroup alloc] init];
//        self.foregroundMotionEffect.motionEffects = @[xAxis, yAxis];
//        
//        [imageView addMotionEffect:self.foregroundMotionEffect];
//    }
}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}



@end
