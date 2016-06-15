//
//  DeviceCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/31.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "DeviceCtrl.h"


@interface DeviceCtrl ()

@property (weak, nonatomic  ) IBOutlet UILabel  * orientationLabel;
@property (nonatomic, strong)          UIDevice * device;

@end

/*
 通过UIDevice类可以获取iOS设备的状态信息，
 例如设备的名称、操作系统版本号、UUID等基本信息，
 同时还能够获取诸如电池状态、设备朝向等信息，
 借助通知机制，当系统状态发生改变时，
 可以通知应用做出对应的响应动作。
 */

@implementation DeviceCtrl


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self device];
    
}

- (UIDevice *)device {
    
    if (!_device) {
        
        //获取当前设备对象
        _device = [UIDevice currentDevice];
    }
    
    return _device;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    NSLog(@"name: %@"               , _device.name);
    NSLog(@"model:%@"               , _device.model);
    NSLog(@"localizedModel: %@"     , _device.localizedModel);
    NSLog(@"systemVersion: %@"      , _device.systemVersion);
    
    //获取设备的UUID
    NSLog(@"identifierForVendor: %@", _device.identifierForVendor.UUIDString);
    
    [self registerNotificationProximityState];
    [self registerNotificationBatteryInfo];
    [self registerNotifOrientation];
}


#pragma mark -- 注册电池信息通知
- (void)registerNotificationBatteryInfo {
    
    //开启电池检测
    _device.batteryMonitoringEnabled = YES;
    
    //注册通知，当充电状态改变时调用batteryStateChange方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryStateChange) name:UIDeviceBatteryStateDidChangeNotification object:nil];
    
}


-(void)batteryStateChange {
    
    UIDevice *device = [UIDevice currentDevice];
    
    //获取当前电量
    float batteryVolume = device.batteryLevel * 100;
    
    //计算电池电量百分比
    NSString *batteryVolumeString = [NSString stringWithFormat:@"当前电量：%.0f%%",batteryVolume];
    
    //根据电池状态切换时，给出提醒
    switch (device.batteryState) {
            
        case UIDeviceBatteryStateUnplugged: {
            
            //提醒
            NSString *string = [NSString stringWithFormat:@"未充电，%@",batteryVolumeString];
            [self showAlert:string];
            break;
        }
        case UIDeviceBatteryStateCharging: {
            
            NSString *string = [NSString stringWithFormat:@"充电中，%@",batteryVolumeString];
            [self showAlert:string];
            break;
        }
        case UIDeviceBatteryStateFull: {
            
            NSString *string = [NSString stringWithFormat:@"已充满，%@",batteryVolumeString];
            [self showAlert:string];
            break;
        }
        case UIDeviceBatteryStateUnknown: {
            
            [self showAlert:@"未知状态"];
            break;
        }
            
        default:
            break;
    }
    
}

-(void) showAlert:(NSString *) string {
    
    UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertview show];
}


#pragma mark -- 注册通知接近传感器信息
- (void)registerNotificationProximityState {
    
    //开启接近传感器
    _device.proximityMonitoringEnabled = YES;
    //接近传感器通知
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(proximityStateChange) name:UIDeviceProximityStateDidChangeNotification object:nil];
    
}


-(void) proximityStateChange {
    UIDevice *device = [UIDevice currentDevice];
    
    if (device.proximityState == YES) {
        NSLog(@"物体靠近");
    }
    else {
        NSLog(@"物体离开");
    }
}


#pragma mark -- 注册方向改变器
- (void)registerNotifOrientation {
    
    //开启方向改变通知
    [_device beginGeneratingDeviceOrientationNotifications];
    //注册方向改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}


#pragma mark -方向改变
- (void)orientationChange {
    
    UIDevice * device = [UIDevice currentDevice];
    
    switch (device.orientation) {
            
        case UIDeviceOrientationPortrait:
            self.orientationLabel.text = [NSString stringWithFormat:@"竖屏/正常"];
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            self.orientationLabel.text = [NSString stringWithFormat:@"竖屏/倒置"];
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            self.orientationLabel.text = [NSString stringWithFormat:@"横屏/左侧"];
            break;
            
        case UIDeviceOrientationLandscapeRight:
            self.orientationLabel.text = [NSString stringWithFormat:@"横屏/右侧"];
            break;
            
        case UIDeviceOrientationFaceUp:
            self.orientationLabel.text = [NSString stringWithFormat:@"正面朝上"];
            break;
            
        case UIDeviceOrientationFaceDown:
            self.orientationLabel.text = [NSString stringWithFormat:@"正面朝下"];
            break;
            
        default:
            self.orientationLabel.text = [NSString stringWithFormat:@"未知朝向"];
            break;
    }
    
}

#pragma mark -- 移除通知
- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}



@end
