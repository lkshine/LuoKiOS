//
//  SliderController.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/20.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "SliderController.h"


@interface SliderController ()

@property (strong, nonatomic) UISlider *mySlider;
@property (strong, nonatomic) UIImageView *myImageView;

@end



@implementation SliderController

- (UISlider *)mySlider {
    
    if (!_mySlider) {
        
        _mySlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 300, wSrceem, 10)];
        _mySlider.value = 0.5;//设置当前滑块处于滑动条中间
        _mySlider.continuous = NO;//不连续触发事件
        _mySlider.minimumTrackTintColor = [UIColor redColor];//设置完成部分的轨道颜色为红色
        _mySlider.maximumTrackTintColor = [UIColor blueColor];//设置未完成部分的轨道颜色为蓝色
        _mySlider.thumbTintColor = [UIColor grayColor];//设置滑块颜色为灰色
        [_mySlider addTarget:self action:@selector(change) forControlEvents:UIControlEventValueChanged];//绑定ValueChange方法
        [self.view addSubview:_mySlider];
    }
    
    return _mySlider;
}


- (UIImageView *)myImageView {
    
    if (!_myImageView) {
        
        _myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 300)];
        _myImageView.image = [UIImage imageNamed:@"1"];
        _myImageView.alpha = .5;//设置图片刚开始透明度为0.5与滑块对应的value保持一致
        [self.view addSubview:_myImageView];
    }
    
    return _myImageView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self myImageView];
    [self mySlider];
    
}


- (void)change{
    [self.myImageView setAlpha:self.mySlider.value];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end
