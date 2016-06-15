//
//  CameraCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/30.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "CameraCtrl.h"



@interface CameraCtrl ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView * imageView;
@property (nonatomic, strong) UIButton * modalBtn;
@end



@implementation CameraCtrl

- (UIButton *)modelBtn {
    
    if (!_modalBtn) {
        
        _modalBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _modalBtn.frame = CGRectMake(wSrceem-70, 80, 50, 40);
        [_modalBtn setTitle:@"modal" forState:UIControlStateNormal];
        [_modalBtn setTintColor:[UIColor redColor]];
        [self.view addSubview:_modalBtn];
        [_modalBtn addTarget:self action:@selector(modalDismiss:) forControlEvents:UIControlEventTouchDown];
    }
    
    return _modalBtn;
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self modelBtn];
    
}

- (void)modalDismiss:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)chooseImage:(UIButton *)sender {
    
    // 创建UIImagePickerController实例
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc] init];
    
    // 设置代理
    imagePickerController.delegate = self;
    
    // 是否允许编辑（默认为NO）
    imagePickerController.allowsEditing = YES;
    
    
    // 创建一个警告控制器
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选取图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 设置警告响应事件
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 设置照片来源为相机
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        // 设置进入相机时使用前置或后置摄像头
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        
        // 展示选取照片控制器
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }];
    
    UIAlertAction *photosAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        // 添加警告按钮
        [alert addAction:cameraAction];
    }
    
    [alert addAction:photosAction];
    [alert addAction:cancelAction];
    
    // 展示警告控制器
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark - UIImagePickerControllerDelegate
// 完成图片的选取后调用的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // 选取完图片后跳转回原控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    /* 此处参数 info 是一个字典，下面是字典中的键值 （从相机获取的图片和相册获取的图片时，两者的info值不尽相同）
     * UIImagePickerControllerMediaType; // 媒体类型
     * UIImagePickerControllerOriginalImage;  // 原始图片
     * UIImagePickerControllerEditedImage;    // 裁剪后图片
     * UIImagePickerControllerCropRect;       // 图片裁剪区域（CGRect）
     * UIImagePickerControllerMediaURL;       // 媒体的URL
     * UIImagePickerControllerReferenceURL    // 原件的URL
     * UIImagePickerControllerMediaMetadata    // 当数据来源是相机时，此值才有效
     */
    
    // 从info中将图片取出，并加载到imageView当中
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    
    // 创建保存图像时需要传入的选择器对象（回调方法格式固定）
    SEL selectorToCall = @selector(image:didFinishSavingWithError:contextInfo:);
    
    // 将图像保存到相册（第三个参数需要传入上面格式的选择器对象）
    UIImageWriteToSavedPhotosAlbum(image, self, selectorToCall, NULL);
    
}

// 取消选取调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


// 保存图片后到相册后，回调的相关方法，查看是否保存成功
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (error == nil){
        
        NSLog(@"Image was saved successfully.");
    }
    else {
        
        NSLog(@"An error happened while saving the image.");
        NSLog(@"Error = %@", error);
    }
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end
