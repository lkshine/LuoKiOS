//
//  DrawImageCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/6/4.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "DrawImageCtrl.h"




@interface DrawImageCtrl ()

{
    CGRect frame;

}
@property (weak, nonatomic) IBOutlet UIImageView * contentView;
@property (nonatomic, strong) DrawImageView      * drawImageView;
@property (nonatomic, strong) UIView             * customCover;


@end


/* Quartz2D进行图形绘制UIView的子类时，注意一个特殊情况：UIImageView的子类不会调用drawRect方法 */

@implementation DrawImageCtrl

- (DrawImageView *)drawImageView {
    
    if ((!_drawImageView)) {
        
        _drawImageView = [[DrawImageView alloc]initWithFrame:self.contentView.frame];
        _drawImageView.customImage = [UIImage imageNamed:@"3"];
        _drawImageView.backgroundColor = [UIColor redColor];
        [self.view addSubview:_drawImageView];
        
    }
    
    return _drawImageView;
}


- (void)viewDidLayoutSubviews {
    
    [self.view layoutSubviews];
//    [self drawImageView];
    
    NSMutableDictionary *dict =[NSMutableDictionary dictionary];
    
//    字体
    
    dict[NSFontAttributeName]=[UIFont systemFontOfSize:50];
    
//    颜色
    
    dict[NSForegroundColorAttributeName]=[UIColor redColor];
    
//    设置边框颜色
    
    dict[NSStrokeColorAttributeName]=[UIColor redColor];
    
    dict[NSStrokeWidthAttributeName]= @1;
    
//    阴影
    
    NSShadow *shadow =[[NSShadow alloc]init];
    
    shadow.shadowOffset = CGSizeMake(10, 10);
    
    shadow.shadowColor =[UIColor greenColor];
    
    shadow.shadowBlurRadius = 3;
    
    dict[NSShadowAttributeName]= shadow;
    
}

#pragma mark -- 代码段水印方法

- (void)addWaterMark {
    
    UIImage *image         = [UIImage imageNamed:@"3"];
    NSString *string       = @"WaterMark";

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame        = CGRectMake(0, 160, 400, 338);
    
    //添加水印
    imageView.image        = [self addWatermarkInImage:image WithText:string];
    
    [self.view addSubview:imageView];
    
}

#pragma mark -- http://www.jb51.net/article/70664.htm
- (UIImage *)addWatermarkInImage:(UIImage *)image WithText:(NSString *)string {
    
    //开启一个图形上下文
    UIGraphicsBeginImageContext(image.size);
    
    //绘制上下文：1-绘制图片
    [image drawAtPoint:CGPointZero];
    
    //绘制上下文：2-添加文字到上下文
    NSDictionary * dict = @{
                           NSFontAttributeName:[UIFont systemFontOfSize:58.0],
                           NSForegroundColorAttributeName:[UIColor redColor]
                           };
    
//    [string drawAtPoint:CGPointZero withAttributes:dict];
    
    CGPoint point = CGPointMake(20, 20);
    [string drawAtPoint:point withAttributes:dict];
    
    //从图形上下文中获取合成的图片
    UIImage * watermarkImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    
    return watermarkImage;
}

#pragma mark -- 对正方形图片剪切方法
- (UIImage *) clipImage:(UIImage *) image {
    
    //开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    
    //获取路径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    //裁剪圆形
    [path addClip];
    
    //把图片塞进上下文中
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    //保存新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    //返回图片
    return newImage;
    
}


- (IBAction)screenShot:(UIButton *)sender {
    
    [self screenshotSavePhoto];
    
}


#pragma mark -- 截屏保存到相册方法
- (void)screenshotSavePhoto {
    
    //开启一个图形上下文
    UIGraphicsBeginImageContext(self.view.bounds.size);
    
    //截屏
    if ([self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:NO]) {
        
        NSLog(@"Successfully draw the screenshot.");
    }
    else {
        
        NSLog(@"Failed to draw the screenshot.");
    }
    
    //获取当前上下文
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    
    [UIView animateWithDuration:0.7f animations:^{
        
        self.customCover.frame = CGRectMake(0, 0, wSrceem, hSrceem);
        
    } completion:^(BOOL finished) {
        
        self.customCover.frame = CGRectMake(0, hSrceem, wSrceem, hSrceem);
        
    }];
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    //保存到相册
    UIImageWriteToSavedPhotosAlbum(screenshot, self, nil, nil);
    
}


#pragma mark -- 蒙层
- (UIView *)customCover {
    
    if (!_customCover) {
        
        _customCover = [[UIView alloc]initWithFrame:CGRectMake(0, hSrceem, wSrceem, hSrceem)];
        UIView * bgcover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wSrceem, hSrceem)];
        [_customCover addSubview:bgcover];
        bgcover.backgroundColor = [UIColor blackColor];
        bgcover.alpha = 0.2;
        
        [[UIApplication sharedApplication].keyWindow addSubview:_customCover];
    }
    
    return _customCover;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self addWaterMark];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end


