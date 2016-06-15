//
//  CALayerCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/6/5.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "CALayerCtrl.h"




@interface CALayerCtrl ()

@property (nonatomic, weak) CALayerView * caLayerView;
@property (nonatomic, weak) CABasicAnimationView *layerTransformView; //隐式动画

@end




@implementation CALayerCtrl



- (CALayerView *)caLayerView {
    
    if (_caLayerView == nil) {
        
        CALayerView *caLayerView = [CALayerView caLayerView];
//        caLayerView.backgroundColor = [UIColor orangeColor];
        _caLayerView = caLayerView;
        
        //设置frame
        caLayerView.frame = CGRectMake(0, 30, 320, 180);
        
        [self.view addSubview:caLayerView];
    }
    
    return _caLayerView;
}

- (CABasicAnimationView *)layerTransformView {
    
    if (_layerTransformView == nil) {
        
        CABasicAnimationView * layerTransformView = [CABasicAnimationView layerTransformView];
        _layerTransformView = layerTransformView;
        
        _layerTransformView.frame = CGRectMake(0, 240, 320, 300);
        
        [self.view addSubview:_layerTransformView];
    }
    
    return _layerTransformView;
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self caLayerView];
    [self layerTransformView];
    
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end



