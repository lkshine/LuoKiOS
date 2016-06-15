//
//  MapCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/30.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "MapCtrl.h"
#import <MapKit/MapKit.h> //导入MapKit框架后，要在工程中引入相应的头文件


@interface MapCtrl ()<MKMapViewDelegate>

@property (nonatomic, strong) MKMapView   * myMapView;
@property (nonatomic, strong) UITextField * myQueryText;//输入要查询的关键字
@property (nonatomic, strong) UIButton    * myBtn;//点击按钮进行查询

@end



@implementation MapCtrl

- (MKMapView *)myMapView {
    
    if (!_myMapView) {
        
        _myMapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        _myMapView.mapType = MKMapTypeHybrid;//混合类型地图
        _myMapView.delegate = self;
        _myMapView.zoomEnabled = YES;
        [self.view addSubview:_myMapView];
    }
    
    return _myMapView;
}


//懒加载方式初始化新增的控件
- (UIButton *)myBtn {
    
    if (!_myBtn) {
        
        _myBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20+64, 40, 40)];
        _myBtn.backgroundColor = [UIColor redColor];
        [_myBtn setTitle:@"查询" forState:UIControlStateNormal];
        [_myBtn addTarget:self action:@selector(geocodeQuery) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_myBtn];
    }
    
    return _myBtn;
}


- (UITextField *)myQueryText {
    
    if (!_myQueryText) {
        
        _myQueryText = [[UITextField alloc] initWithFrame:CGRectMake(40, 20+64, self.view.bounds.size.width - 40, 40)];
        _myQueryText.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_myQueryText];
    }
    
    return _myQueryText;
}


#pragma mark -- 在按钮的点击方法中完成“大头针的添加”
- (void)geocodeQuery {
    
    if (self.myQueryText != nil && [self.myQueryText.text length] != 0) {
        
        CLGeocoder * geocoder = [[CLGeocoder alloc] init];
        
        //根据文本框关键字进行查询
        [geocoder geocodeAddressString:self.myQueryText.text completionHandler:^(NSArray * _Nullable placemarks, NSError * _Nullable error) {
            
            if ([placemarks count] > 0) {
                
                //用来移除目前地图上的标注点，否则地图上的标注点会越来越多
                [self.myMapView removeAnnotations:self.myMapView.annotations];
            }
            for (int i = 0; i < [placemarks count]; i++) {
                
                CLPlacemark *placemark = placemarks[i];
                
                //调整地图位置和缩放比例
                MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(placemark.location.coordinate, 1000, 1000);
                [self.myMapView setRegion:viewRegion animated:YES];
                
                //得到查询点的位置信息
                NSArray *addressArray = placemark.addressDictionary[@"FormattedAddressLines"];
                
                //设置标注点标题的内容
                NSMutableString *addressStr = [[NSMutableString alloc] init];
                for (int i = 0; i < addressArray.count; i++) {
                    
                    [addressStr appendString:addressArray[i]];
                }
                
                //设置标注点
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                annotation.title = placemark.name;
                annotation.subtitle = addressStr;
                annotation.coordinate = placemark.location.coordinate;
                [self.myMapView addAnnotation:annotation];
            }
            
            //关闭键盘
            [self.myQueryText resignFirstResponder];
        }];
    }
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self myMapView];
    [self myBtn];
    [self myQueryText];
    
}


//开始加载时调用
- (void) mapViewWillStartLoadingMap:(MKMapView *)mapView {
    
    NSLog(@"StartLoadingMap");
}

//加载完毕后调用
-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    
    NSLog(@"FinishLoadingMap");
}

//加载失败调用
- (void) mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
    
    NSLog(@"DidFailLoadingMap%@",error);
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end


