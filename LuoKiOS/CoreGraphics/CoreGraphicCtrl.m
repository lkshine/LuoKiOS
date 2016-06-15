//
//  CoreGraphicCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/31.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "CoreGraphicCtrl.h"
#import "CustomDrawView.h"
#import "BezierPathView.h"
#import "GraffitiView.h"

@interface CoreGraphicCtrl ()

{
    CGRect mFrame;
}
@property (nonatomic, strong) CustomDrawView                * customView;
@property (nonatomic, strong) BezierPathView                * bezierPathView;
@property (nonatomic, strong) GraffitiView                  * graffitiView;
@property (weak, nonatomic  ) IBOutlet UIView               * contentView;
@property (weak, nonatomic  ) IBOutlet UISegmentedControl   * colorControl;
@property (weak, nonatomic  ) IBOutlet UISegmentedControl   * sharpControl;

@end



@implementation CoreGraphicCtrl


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//        [self bezierPathView];
//        [self customView];
    //    [self evaa];
    //    [self evee];
    
}


- (IBAction)changeColor:(UISegmentedControl *)sender {
    
    BezierPathView * myView = self.bezierPathView;
    ColorTabIndex color = [sender selectedSegmentIndex];
    
    switch (color) {
        case kRedColor:
            myView.currentColor = [UIColor redColor];
            myView.useRandomColor = NO;
            break;
            
        case kBlueColor:
            myView.currentColor = [UIColor blueColor];
            myView.useRandomColor = NO;
            break;
            
        case kRandomColor:
            myView.useRandomColor = YES;
            break;
            
        default:
            break;
    }
    
}


- (IBAction)changeShape:(UISegmentedControl *)sender {
    
    //绘图形状
    SharpType sharpType = [sender selectedSegmentIndex];
    [self.bezierPathView setSharpType:sharpType];
    
    //如果选中图片，则隐藏顶部的颜色选择器
    self.colorControl.hidden = [sender selectedSegmentIndex] == kImageShape;
    
}


- (IBAction)clearScreen:(UIButton *)sender {
    
    [self.graffitiView clearAllPath];

}


- (void)evaa {
    
    //create particle emitter layer
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.frame = self.view.bounds;
    [self.view.layer addSublayer:emitter];
    //configure emitter
    emitter.renderMode = kCAEmitterLayerAdditive;
    emitter.emitterPosition = CGPointMake(emitter.frame.size.width / 2.0, emitter.frame.size.height / 2.0);
    //create a particle template
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    cell.contents = (__bridge id)[UIImage imageNamed:@"spark"].CGImage;
    cell.birthRate = 150;
    cell.lifetime = 5.0;
    cell.color = [UIColor colorWithRed:1 green:0.5 blue:0.1 alpha:1.0].CGColor;
    cell.alphaSpeed = -0.4;
    cell.velocity = 50;
    cell.velocityRange = 50;
    cell.emissionRange = M_PI * 2.0;
    //add particle template to emitter
    emitter.emitterCells = @[cell];
    
}


- (void)evee {
    CAEmitterLayer *snowEmitter = [CAEmitterLayer layer];
    //例子发射位置
    snowEmitter.emitterPosition = CGPointMake(120,20);
    //发射源的尺寸大小
    snowEmitter.emitterSize = CGSizeMake(self.view.bounds.size.width * 20, 20);
    //发射模式
    snowEmitter.emitterMode = kCAEmitterLayerSurface;
    //发射源的形状
    snowEmitter.emitterShape = kCAEmitterLayerLine;
    
    //创建雪花类型的粒子
    CAEmitterCell *snowflake = [CAEmitterCell emitterCell];
    //粒子的名字
    snowflake.name = @"snow";
    //粒子参数的速度乘数因子
    snowflake.birthRate = 1.0;
    snowflake.lifetime = 120.0;
    //粒子速度
    snowflake.velocity =10.0;
    //粒子的速度范围
    snowflake.velocityRange = 10;
    //粒子y方向的加速度分量
    snowflake.yAcceleration = 2;
    //周围发射角度
    snowflake.emissionRange = 0.5 * M_PI;
    //子旋转角度范围
    snowflake.spinRange = 0.25 * M_PI;
    snowflake.contents = (id)[[UIImage imageNamed:@"spark"] CGImage];
    //设置雪花形状的粒子的颜色
    snowflake.color = [[UIColor colorWithRed:0.200 green:0.258 blue:0.543 alpha:1.000] CGColor];
    
    //创建星星形状的粒子
    CAEmitterCell *snowflake1 = [CAEmitterCell emitterCell];
    //粒子的名字
    snowflake1.name = @"snow";
    //粒子参数的速度乘数因子
    snowflake1.birthRate = 1.0;
    snowflake1.lifetime = 120.0;
    //粒子速度
    snowflake1.velocity =10.0;
    //粒子的速度范围
    snowflake1.velocityRange = 10;
    //粒子y方向的加速度分量
    snowflake1.yAcceleration = 2;
    //周围发射角度
    snowflake1.emissionRange = 0.5 * M_PI;
    //子旋转角度范围
    snowflake1.spinRange = 0.25 * M_PI;
    //粒子的内容和内容的颜色
    snowflake1.contents = (id)[[UIImage imageNamed:@"spark"] CGImage];
    snowflake1.color = [[UIColor colorWithRed:0.600 green:0.658 blue:0.743 alpha:1.000] CGColor];
    
    snowEmitter.shadowOpacity = 1.0;
    snowEmitter.shadowRadius = 0.0;
    snowEmitter.shadowOffset = CGSizeMake(0.0, 1.0);
    //粒子边缘的颜色
    snowEmitter.shadowColor = [[UIColor redColor] CGColor];
    
    snowEmitter.emitterCells = [NSArray arrayWithObjects:snowflake,snowflake1,nil];
    [self.view.layer insertSublayer:snowEmitter atIndex:0];
    
}



#pragma mark -- 只有在该方法里，获得的尺寸才会是xib里的完成autolayout适配时的尺寸，storyboard同理
- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    //    or  [super.view layoutSubviews];
    
//    [self bezierPathView];
    [self graffitiView];

}



- (CustomDrawView *)customView {
    
    if (!_customView) {
        
        _customView = [[CustomDrawView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _customView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_customView];
    }
    
    return _customView;
}


- (BezierPathView *)bezierPathView {
    
    if (!_bezierPathView) {
        
        _bezierPathView = [[BezierPathView alloc]initWithFrame:self.contentView.bounds];
        _bezierPathView.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:_bezierPathView];
        NSLog(@"\n\t🚩\n 0000self.contentView.rect = %@ \n\t📌", NSStringFromCGRect(self.contentView.bounds));
    }
    
    return _bezierPathView;
}


- (GraffitiView *)graffitiView {
    
    if (!_graffitiView) {
        
        _graffitiView = [[GraffitiView alloc]initWithFrame:self.contentView.bounds];
        _graffitiView.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:_graffitiView];
        NSLog(@"\n\t🚩\n 0000self.contentView.rect = %@ \n\t📌", NSStringFromCGRect(self.contentView.bounds));
    }
    
    return _graffitiView;
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end


