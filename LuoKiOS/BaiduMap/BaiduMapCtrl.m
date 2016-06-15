//
//  BaiduMapCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/31.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "BaiduMapCtrl.h"


@interface BaiduMapCtrl ()<BMKMapViewDelegate>

@property (nonatomic, strong) BMKMapView * mapView;
@property (nonatomic, strong) BMKPointAnnotation * annotation;

@end



@implementation BaiduMapCtrl


- (void)viewDidLoad {
    
    [super viewDidLoad];
    _mapView = [[BMKMapView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    /*  地图类型  */
    _mapView.mapType = BMKMapTypeNone;//设置地图为空白类型
    //切换为卫星图
    [_mapView setMapType:BMKMapTypeSatellite];
    //切换为普通地图
    [_mapView setMapType:BMKMapTypeStandard];
    
    
    /*  实时交通图  */
    //打开实时路况图层
    [_mapView setTrafficEnabled:YES];
    //关闭实时路况图层
//    [_mapView setTrafficEnabled:NO];
    
    
    /*  百度城市热力图  */
    //打开百度城市热力图图层（百度自有数据）
    [_mapView setBaiduHeatMapEnabled:YES];
    //关闭百度城市热力图图层（百度自有数据）
//    [_mapView setBaiduHeatMapEnabled:NO];
    
    
    
    /*  地图控制和手势  */
    /*
    地图Logo
         默认在左下角显示，不可以移除。 通过logoPosition属性，
        使用枚举类型控制显示的位置，共支持6个显示位置(左下，中下，右下，左上，中上，右上)。
         地图Logo不允许遮挡，可通过mapPadding属性可以设置地图边界区域，来避免UI遮挡。
    指南针
         指南针默认为开启状态，可以关闭显示 。
    比例尺
         比例尺默认为开启状态，可以关闭显示。同时支持设置MaxZoomLevel和minZoomLevel。
     */
    
    
    /*  地图手势  */
    /*
    地图平移
         控制是否启用或禁用平移的功能，默认开启。如果启用，则用户可以平移地图
    地图缩放
         控制是否启用或禁用缩放手势，默认开启。如果启用，用户可以双指点击或缩放地图视图。
    地图俯视（3D）
         控制是否启用或禁用俯视（3D）功能，默认开启。如果启用，则用户可使用双指 向下或向上滑动到俯视图。
    地图旋转
         控制是否启用或禁用地图旋转功能，默认开启。如果启用，则用户可使用双指 旋转来旋转地图。
    3D-Touch手势
         自2.10.0起，支持3D Touch回调，可控制是否开启或关闭回调3D-Touch手势，默认为关闭。
    禁止所有手势
         控制是否一并禁止所有手势，默认关闭。如果启用，所有手势都将被禁用。
     */
    
    
    
    
    
    
    self.view = _mapView;
    
}



/*  地图标注  */
- (void) viewDidAppear:(BOOL)animated {
    
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = 39.915;
    coor.longitude = 116.404;
    annotation.coordinate = coor;
    annotation.title = @"这里是北京";
    [_mapView addAnnotation:annotation];
    
}

// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        
        return newAnnotationView;
    }
    
    return nil;
}




-(void)viewWillAppear:(BOOL)animated {
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
}


-(void)viewWillDisappear:(BOOL)animated {
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    
    if (_annotation != nil) {
        
        [_mapView removeAnnotation:_annotation];
    }
    
}





- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}



@end


