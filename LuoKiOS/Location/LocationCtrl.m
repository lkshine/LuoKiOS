//
//  LocationCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/30.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "LocationCtrl.h"
#import <CoreLocation/CoreLocation.h>


@interface LocationCtrl ()<CLLocationManagerDelegate>

@property (weak, nonatomic  ) IBOutlet UITextField * textLng;
@property (weak, nonatomic  ) IBOutlet UITextField * textLat;
@property (weak, nonatomic  ) IBOutlet UITextField * textHeight;
@property (weak, nonatomic  ) IBOutlet UITextView  * txtView;

@property (nonatomic, strong) CLLocationManager    * locationManager;
@property (nonatomic, strong) CLLocation           * currlocation;

@property (weak, nonatomic  ) IBOutlet UITextField * textQuery;
@property (weak, nonatomic  ) IBOutlet UITextField * lat;
@property (weak, nonatomic  ) IBOutlet UITextField * lng;

@end



@implementation LocationCtrl


- (CLLocationManager *)locationManager {
    
    if (!_locationManager) {
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;//精度设置
        _locationManager.distanceFilter = 1000.0f;//设备移动后获得位置信息的最小距离
        _locationManager.delegate = self;
        [_locationManager requestWhenInUseAuthorization];//弹出用户授权对话框，使用程序期间授权
        //[_locationManager requestAlwaysAuthorization];//始终授权
    }
    
    return _locationManager;
}


- (IBAction)geocoderQuery:(UIButton *)sender {
    
    //判断是否有字符输入
    if (self.textQuery.text != nil && [self.textQuery.text length] != 0) {
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        //根据输入的字符进行地理编码
        [geocoder geocodeAddressString:self.textQuery.text completionHandler:^(NSArray * _Nullable placemarks, NSError * _Nullable error) {
            
            //判断是否有返回信息
            if ([placemarks count] > 0) {
                
                // placemarks数组中第一个为地标信息
                CLPlacemark *placemark = placemarks[0];
                
                //获得相应的经纬度
                CLLocationCoordinate2D coordinate = placemark.location.coordinate;
                
                //显示到对应的label上面
                self.lat.text = [NSString stringWithFormat:@"%3.5f",coordinate.latitude];
                self.lng.text = [NSString stringWithFormat:@"%3.5f",coordinate.longitude];
            }
        }];
    }
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self locationManager];
    
}

/* 
     对于授权属性使用之前，需要对Info.plist属性列表文件进行配置(新增Key)。
        NSLocationWhenInUseUsageDescription, 使用期间使用定位的说明
        NSLocationAlwaysUsageDescription, 用于描述应用程序始终使用
*/


- (IBAction)reverseGeocode:(UIButton *)sender {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //currlocation里面包含需要反向编码的信息，在代理方法中获得数据
    [geocoder reverseGeocodeLocation:self.currlocation completionHandler:^(NSArray * _Nullable placemarks, NSError * _Nullable error) {
        //placemarks表示反向编码成功的地标集合
        if ([placemarks count] > 0) {
            //返回描述信息
            CLPlacemark *placemark = placemarks[0];
            //获取所需信息
            NSString *state = placemark.administrativeArea;
            NSString *city = placemark.locality;
            NSString *street = placemark.thoroughfare;
            //在textView上面显示
            self.txtView.text = [NSString stringWithFormat:@"%@ %@ %@",state,city,street];
        }
    }];
    
}


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    //开始定位
    [self.locationManager startUpdatingLocation];
    
}


//定位成功时调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    self.currlocation    = [locations lastObject];//获取当前位置
    self.textLat.text    = [NSString stringWithFormat:@"%3.5f",self.currlocation.coordinate.latitude];//获取纬度
    self.textLng.text    = [NSString stringWithFormat:@"%3.5f",self.currlocation.coordinate.longitude];//获取经度
    self.textHeight.text = [NSString stringWithFormat:@"%3.5f",self.currlocation.altitude];//获取高度
    
}
/*
    在 locationManager：didUpdateLocations:方法中，
    参数locations是位置变化的集合，它是按照时间变化的顺序存放的，
    最后一个元素就是当前位置，altitude属性是高度值，coordinate属性是封装经纬度的结构体。
*/

//定位失败调用
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"%@",error);
}

//授权状态发生变化调用
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
   
    NSLog(@"change");
}


- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    //停止定位
    [self.locationManager stopUpdatingLocation];
    
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}



@end


