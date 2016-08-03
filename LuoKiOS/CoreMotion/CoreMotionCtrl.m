//
//  CoreMotionCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/31.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "CoreMotionCtrl.h"
#import <CoreMotion/CoreMotion.h>  //导入CoreMotion框架后导入头文件


@interface CoreMotionCtrl ()
@property (nonatomic, strong) CMMotionManager * motionMgr;
/*
 Core Motion的使用就是一三部曲：初始化，获取数据，处理后事。
 */
@end

/*
 
 从Core Motion中获取数据主要是两种方式，一种是Push，就是你提供一个线程管理器NSOperationQueue，再提供一个Block（有点像C中 的回调函数），这样，Core Motion自动在每一个采样数据到来的时候回调这个Block，进行处理。在这中情况下，block中的操作会在你自己的主线程内执行。另一种方式叫做 Pull，在这个方式里，你必须主动去像Core Motion Manager要数据，这个数据就是最近一次的采样数据。你不去要，Core Motion Manager就不会给你。当然，在这种情况下，Core Motion所有的操作都在自己的后台线程中进行，不会有任何干扰你当前线程的行为。
 
 */

@implementation CoreMotionCtrl


- (void)viewDidLoad {
    
    [super viewDidLoad];
    // 在初始化阶段，不管你要获取的是什么数据，首先需要做的就是
    [self motionMgr];
}


- (CMMotionManager *)motionMgr {
    
    if (!_motionMgr) {
        
        _motionMgr = [CMMotionManager new];
    }
    
    return _motionMgr;
}


- (IBAction)pushStartAccAction:(UIButton *)sender {
    
    NSLog(@"%s",__func__);
    //设置采样间隔
    self.motionMgr.accelerometerUpdateInterval = 1.0;
    //开始采样
    [self.motionMgr startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        
        NSLog(@"x:%f, y:%f, z:%f",accelerometerData.acceleration.x, accelerometerData.acceleration.y,accelerometerData.acceleration.z);
        
    }];
    
}


- (IBAction)pushStopAccAction:(UIButton *)sender {
    
    NSLog(@"%s",__func__);
    [self.motionMgr stopAccelerometerUpdates];
    
}


- (IBAction)pullStarAccAction:(UIButton *)sender {
    
    NSLog(@"%s",__func__);
    
    //Pull模式--加速计Accelerometer
    if (self.motionMgr.isAccelerometerAvailable) {
        
        //启动采样
        [self.motionMgr startAccelerometerUpdates];
    }
    else {
        
        NSLog(@"加速计Accelerometer不可用");
    }
    
}


- (IBAction)pullStopAccAction:(UIButton *)sender {
    
    NSLog(@"%s",__func__);
    CMAcceleration acceleration = self.motionMgr.accelerometerData.acceleration;
    NSLog(@"accelerometer current state：x:%f, y:%f, z:%f", acceleration.x, acceleration.y, acceleration.z);
}


- (IBAction)pushStartCyroAction:(UIButton *)sender {
    
    NSLog(@"%s",__func__);
    //设置采样间隔
    self.motionMgr.gyroUpdateInterval = 1.0;
    
    //开始采样
    [self.motionMgr startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
        
        NSLog(@"x:%f, y:%f, z:%f", gyroData.rotationRate.x, gyroData.rotationRate.y, gyroData.rotationRate.z);
    }];
    
}


- (IBAction)pushStopCyroAction:(UIButton *)sender {
    
    NSLog(@"%s",__func__);
    [self.motionMgr stopGyroUpdates];
    
}


- (IBAction)pullStartCyroAction:(UIButton *)sender {
    
    NSLog(@"%s",__func__);
    
    //Pull模式--陀螺仪
    if (self.motionMgr.isGyroAvailable) {
        
        [self.motionMgr startGyroUpdates];
    }
    else {
        
        NSLog(@"陀螺仪GyroScope不可用");
    }
    
}


- (IBAction)pullStopCyroAction:(UIButton *)sender {
   
    NSLog(@"%s",__func__);
    
    //获取陀螺仪当前状态
    CMRotationRate rationRate = self.motionMgr.gyroData.rotationRate;
    NSLog(@"gyroscope current state: x:%f, y:%f, z:%f", rationRate.x, rationRate.y, rationRate.z);
    
}


- (IBAction)pushStartMagnetoAction:(UIButton *)sender {
    
    //设置采样间隔
    self.motionMgr.magnetometerUpdateInterval = 1.0;
    
    //开始采样
    [self.motionMgr startMagnetometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMagnetometerData * _Nullable magnetometerData, NSError * _Nullable error) {
        NSLog(@"x:%f, y:%f, z:%f", magnetometerData.magneticField.x, magnetometerData.magneticField.y, magnetometerData.magneticField.z);
    }];
    
}


- (IBAction)pushStopMagntoAction:(UIButton *)sender {
    
    NSLog(@"%s",__func__);
    [self.motionMgr stopMagnetometerUpdates];
    
}


- (IBAction)pullStartMagntoAction:(UIButton *)sender {
    
    NSLog(@"%s",__func__);
    
    //Pull模式--磁力计
    if (self.motionMgr.isMagnetometerAvailable) {
        
        [self.motionMgr startMagnetometerUpdates];
    }
    else {
        
        NSLog(@"磁力计Magnetometer不可用");
    }
    
}


- (IBAction)pullStopMagntoAction:(UIButton *)sender {
    
    NSLog(@"%s",__func__);
    
    //获取磁力计当前状态
    CMMagneticField magneticField = self.motionMgr.magnetometerData.magneticField;
    NSLog(@"magnetometer current state: x:%f, y:%f, z:%f", magneticField.x, magneticField.y, magneticField.z);
    
}


- (IBAction)pullAction:(UIButton *)sender {
    
    //Pull模式--device motion
    if (self.motionMgr.isDeviceMotionAvailable) {
        [self.motionMgr startDeviceMotionUpdates];
    }else {
        NSLog(@"device motion不可用");
    }
    
    //Pull模式--陀螺仪
    if (self.motionMgr.isGyroAvailable) {
        [self.motionMgr startGyroUpdates];
    }else {
        NSLog(@"陀螺仪GyroScope不可用");
    }
    
    
    //通过deviceMotion获取陀螺仪当前状态
    CMDeviceMotion * deviceMotion = self.motionMgr.deviceMotion;
    NSLog(@"device motion rationRate: x:%f, y:%f, z:%f",deviceMotion.rotationRate.x, deviceMotion.rotationRate.y,deviceMotion.rotationRate.z);
    
    
    //获取陀螺仪当前状态
    CMRotationRate rationRate = self.motionMgr.gyroData.rotationRate;
    NSLog(@"gyroscope current state: x:%f, y:%f, z:%f", rationRate.x, rationRate.y, rationRate.z);
}


- (IBAction)pushAction:(UIButton *)sender {
    
    if (sender.selected) {
        
        sender.selected = 0;
        //设置采样间隔
        self.motionMgr.deviceMotionUpdateInterval = 1.0;
        //开始采样
        [self.motionMgr startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            NSLog(@"x:%f, y:%f, z:%f", motion.rotationRate.x, motion.rotationRate.y, motion.rotationRate.z);
        }];
        
    }
    else {
        
        sender.selected = 1;
        [self.motionMgr stopDeviceMotionUpdates];
        
    }
    
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark -- Instruments--leak总报错在这个类里 ，但是却是在调用CoreAnimationCtrl类时会出现问题
- (void)dealloc {
    
    self.motionMgr = nil;
    NSLog(@"xiaohuila ");
}

@end




