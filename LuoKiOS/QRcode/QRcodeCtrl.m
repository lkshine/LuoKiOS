//
//  QRcodeCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/6/8.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "QRcodeCtrl.h"
#import <AVFoundation/AVFoundation.h>
#import "QRcodeWebViewCtrl.h"

@interface QRcodeCtrl ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic,strong) AVCaptureSession *session;

@end




@implementation QRcodeCtrl


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self startWork];
    
}

- (void)startWork {
    
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    self.session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [self.session addInput:input];
    [self.session addOutput:output];
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    //扫描框的位置和大小
    layer.frame = CGRectMake(60, 100, 200, 200);
    [self.view.layer insertSublayer:layer atIndex:0];
    
    //开始捕获
    [self.session startRunning];
    
}


#pragma mark -- delegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSLog(@"%s",__func__);
    if (metadataObjects.count>0) {
        //[session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        NSLog(@"%@",metadataObject.stringValue);
        
        //停止扫描
        [self.session stopRunning];
        
        //跳转控制器
        QRcodeWebViewCtrl *webVC = [[QRcodeWebViewCtrl alloc] init];
        webVC.urlString = metadataObject.stringValue;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

@end
