//
//  CALayerView.m
//  LuoKiOS
//
//  Created by lkshine on 16/6/5.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "CALayerView.h"

@interface CALayerView ()

@property (weak, nonatomic) IBOutlet UIImageView * imageView;
@property (weak, nonatomic) IBOutlet UIImageView * clipImageView;

@end


@implementation CALayerView

+ (instancetype)caLayerView {
    
    CALayerView * caLayerView = [[[NSBundle mainBundle] loadNibNamed:@"CALayerView" owner:self options:nil] lastObject];
    
    return caLayerView;
}

- (IBAction)clickChange:(UIButton *)sender {
    
    [self changeImageViewLayerState];
    
    [self clipImageViewByLayer];
    
    [self addLayer];
}


- (void)changeImageViewLayerState {
    
    //设置背景颜色，注意：设置为clearColor后，添加shadow可以出现特殊效果
    self.imageView.layer.backgroundColor   = [UIColor whiteColor].CGColor;


    //边框属性
    self.imageView.layer.borderWidth       = 2;
    self.imageView.layer.borderColor       = [UIColor clearColor].CGColor;

    //阴影属性
    self.imageView.layer.shadowColor       = [UIColor redColor].CGColor;
    self.imageView.layer.shadowRadius      = 5;
    self.imageView.layer.shadowOpacity     = 1;

}

- (void)clipImageViewByLayer {

    //设置边框属性
    self.clipImageView.layer.borderWidth   = 3;
    self.clipImageView.layer.borderColor   = [UIColor whiteColor].CGColor;

    //设置圆角
    self.clipImageView.layer.cornerRadius  = _imageView.frame.size.width/2;;
    self.clipImageView.layer.masksToBounds = YES;

    /*
    //UIKIT中也提供了裁剪方法
    self.clipImageView.clipsToBounds       = YES;
     */
}

- (void)addLayer {
    
    //新建一个图层
    CALayer *layer        = [CALayer layer];

    //设置位置，位置属性是父图层中的坐标
    layer.position        = CGPointMake(269, 34);

    //设置锚点
    layer.anchorPoint     = CGPointMake(0, 0);

    //设置bounds
    layer.bounds          = CGRectMake(0, 0, 80, 80);

    //设置contents，一般情况下都是放图片CGImageRef
    layer.contents        = (__bridge id)([UIImage imageNamed:@"spiderMan"].CGImage);

    //设置属性
    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.cornerRadius    = 10;
    layer.masksToBounds   = YES;
    layer.opacity         = 0.2;
    
    //添加到父layer
    [self.layer addSublayer:layer];
    
}


@end



