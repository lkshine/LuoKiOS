//
//  CABasicAnimationView.m
//  LuoKiOS  --- 隐式动画
//
//  Created by lkshine on 16/6/5.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "CABasicAnimationView.h"

@interface CABasicAnimationView ()

@property (nonatomic, weak) CALayer * moveLayer;
@property (nonatomic, weak) CALayer * scaleLayer;
@property (nonatomic, weak) CALayer * rotateLayer;

@property (weak, nonatomic) IBOutlet UIView  *view;

@end



@implementation CABasicAnimationView

- (IBAction)clickPlay:(id)sender {
    
    [self move];
    [self scale];
    [self rotate];
    [self changeView];
    
}


+ (instancetype) layerTransformView {
    
    CABasicAnimationView *view = [[[NSBundle mainBundle] loadNibNamed:@"CABasicAnimationView" owner:self options:nil] lastObject];
    
    return view;
}

/*懒加载*/
- (CALayer *)moveLayer {
    
    if (_moveLayer == nil) {
        
        CALayer *layer        = [CALayer layer];

        layer.backgroundColor = [UIColor orangeColor].CGColor;
        layer.bounds          = CGRectMake(0, 0, 80, 80);
        layer.position        = CGPointMake(20, 50);
        layer.anchorPoint     = CGPointMake(0, 0);//锚点（取值0~1之间）
        //锚点介绍：http://www.cnblogs.com/wendingding/p/3800736.html
        _moveLayer            = layer;
 
        [self.layer addSublayer:layer];
    }
    
    return _moveLayer;
}


- (CALayer *)scaleLayer {
    
    if (_scaleLayer == nil) {

        CALayer * layer       = [CALayer layer];
        
        layer.backgroundColor = [UIColor redColor].CGColor;
        layer.bounds          = CGRectMake(0, 0, 80, 80);
        layer.position        = CGPointMake(220, 50);
        layer.anchorPoint     = CGPointMake(0, 0);
        layer.opacity         = 0.8;
        _scaleLayer           = layer;
        
        [self.layer addSublayer:layer];
    }
    
    return _scaleLayer;
}


- (CALayer *)rotateLayer {
    
    if (_rotateLayer == nil) {
        
        CALayer * layer       = [CALayer layer];
        
        layer.backgroundColor = [UIColor blueColor].CGColor;
        layer.bounds          = CGRectMake(0, 0, 80, 80);
        layer.position        = CGPointMake(120, 150);
        layer.anchorPoint     = CGPointMake(0, 0);
        layer.opacity         = 0.6;
        _rotateLayer          = layer;
        
        [self.layer addSublayer:layer];
    }
    
    return _rotateLayer;
}


- (void)awakeFromNib {
    
    //    [super awakeFromNib];
    
    [self moveLayer];
    [self scaleLayer];
    [self rotateLayer];
}


/*
 反复点击按钮，显示不会改变，说明transform是一个静态的状态，记录了形变后的最终样式
 */

/*位移*/
#pragma mark -- CALayer类的隐式动画同一时刻只能有一组效果展现

/* 
    每一个UIView内部都默认关联着一个CALayer，我们可称这个Layer为Root Layer（根层），
    所有的非Root Layer，也就是手动创建的CALayer对象，都存在着隐式动画。
    当对非Root Layer的部分属性进行修改时，
    默认会自动产生一些动画效果而这些属性称为Animatable Properties(可动画属性)，
    隐式动画均是执行的CABasicAnimation类型的动画。
 */
- (void)move {
    
    //CATransform3DMakeTranslation参数为相对于当前位置的位移量
    self.moveLayer.transform = CATransform3DMakeTranslation(100, 0, 0);
    
//    self.moveLayer.transform = CATransform3DMakeScale(0.5, 0.5, 1);
//    self.moveLayer.opacity = 0.2;
//    
//    self.moveLayer.transform = CATransform3DMakeRotation(M_PI_4, 0, 0, 1);
    
}

/*缩放*/
- (void)scale {
    
    //CATransform3DMakeScale参数为缩放的比例
    self.scaleLayer.transform = CATransform3DMakeScale(0.5, 0.5, 1);
    self.scaleLayer.opacity = 0.2;
    
}


/*旋转*/
- (void)rotate {
    
    //CATransform3DMakeRotation：第一个参数为旋转角度，后面的3个参数标示旋转轴
    self.rotateLayer.transform = CATransform3DMakeRotation(M_PI_4, 0, 0, 1);
    
}


/*
 系统view的锚点是（0.5，0.5），因此缩放后是向中心点缩放的。
 缩放后，view的bounds是没有变化的，变化的仅仅是layer的样式,frame是变化的，再次说明frame只有在第一次设置位置的时候有用，形变后就不准确了。
 */
- (void)changeView {
    
    [UIView animateWithDuration:1.0 animations:^{
        
        NSLog(@"pre-frame:%@------pre-bounds:%@--------pre-center:@%@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.view.bounds), NSStringFromCGPoint(self.view.center));
        self.view.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1);
        self.view.layer.opacity = 0.2;
    }
                     completion:^(BOOL finished) {
        
        NSLog(@"frame:%@------bounds:%@-------center:%@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.view.bounds), NSStringFromCGPoint(self.view.center));
        
    }];
    
}
/*
 
 //通过uiview设置（2D效果）
 12 //    self.iconView.transform = CGAffineTransformMakeTranslation(0, -100);
 13     //通过layer来设置（3D效果,x，y，z三个方向）
 14 //    self.iconView.layer.transform = CATransform3DMakeTranslation(100, 20, 0);
 15
 16     //通过KVC来设置
 17 //    NSValue *v = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(100, 20, 0)];
 18 //    [self.iconView.layer setValue:v forKeyPath:@"transform"];
 19 //    //如果是只需要设置在某一个方向上的移动，可以参考下面的代码
 20 //    //在x的方向上向左移动100
 21 //    [self.iconView.layer setValue:@(-100) forKeyPath:@"transform.translation.x"];
 22
 23     //旋转
 24     self.iconView.layer.transform=CATransform3DMakeRotation(M_PI_4, 1, 1, 0.5);
 
 */


@end


