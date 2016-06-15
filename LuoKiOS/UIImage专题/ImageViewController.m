//
//  ImageViewController.m
//  iOS知识点总结项目 ---- Image的帧动画
//
//  Created by lkshine on 16/5/12.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView    * imageView;
@property (weak, nonatomic) IBOutlet UIImageView    * tomCat;
@property (nonatomic, weak) NSMutableArray          * fpsArray;     //这里是weak还是strong至关重要噢！，详细看代码说明
@property (weak, nonatomic) IBOutlet UIImageView    * web1Image;
@property (weak, nonatomic) IBOutlet UIImageView    * web2Image;

@end


/*
    iOS9以后改为了 变为 HTTPS，所以要在 工程的 Info.plist文件做相对应的修改，以适配 http 协议的链接url
    Info.plist -> 新增 App Transport Security Settings -> 新增 Allow Arbitrary Loads -> 设置为：YES;
 */


@implementation ImageViewController

#pragma mark -- LazyLoad
- (NSMutableArray *)fpsArray {
    
    if (!_fpsArray) {
        
        _fpsArray = [NSMutableArray array];
        
        for (int i = 0; i < 40; i++) {
            NSString * imageFileName = [NSString stringWithFormat:@"eat_%02d.jpg", i];
            NSString * filePath = [[NSBundle mainBundle] pathForResource:imageFileName ofType:nil];
            
            UIImage * image = [UIImage imageWithContentsOfFile:filePath];
            [_fpsArray addObject:image];
        }
    }
    
    return _fpsArray;
}


#pragma mark -- 帧动画封装代码
- (void)AnimationByFPSArray {
    
    self.tomCat.animationImages = self.fpsArray;
    NSLog(@"1==== %@",  self.tomCat.animationImages);
    
    //动画播放速度及次数
    self.tomCat.animationDuration = _fpsArray.count * .08;
    self.tomCat.animationRepeatCount = 1;
    
    //开始播放动画
    [self.tomCat startAnimating];
    
    // 动画播放完毕后，清空animationImages所一直占用的内存
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((self.tomCat.animationDuration + 0.2) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //PS重点：这里讲数组至为空非常重要，如果单纯直接给animationImages赋予nil，将不会释放内存，因为我们之前是对_fpsArray设置的是strong，而不是weak，所以anitionImages内存也指向了_fpsArray
//        _fpsArray = nil;
        
        self.tomCat.animationImages = nil;//_fpsArray;
        
        NSLog(@"2==== %@",  self.tomCat.animationImages);
    });
    
    /*
     or =
     
     CGFloat delay = self.tomCat.animationDuration + 0.2;
     [self.tomCat performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:delay];
     
     */
    
}


#pragma mark -- 隐藏状态栏（时间，电池显示的最上面一栏）
- (BOOL)prefersStatusBarHidden {
    
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configure];
    [self setImageByPathFile];
//    [self setImageByImageNamed];
    
}


#pragma mark -- imageNamed: 有内存缓存直到程序退出才释放(传入文件名)
- (void)setImageByImageNamed {
    
    
    /*
     
         这个方法用一个指定的名字在系统缓存中查找并返回一个图片对象如果它存在的话。
         如果缓存中没有找到相应的图片，这个方法从指定的文档中加载然后缓存并返回这个对象。
         因此imageNamed的优点是当加载时会缓存图片。所以当图片会频繁的使用时，
         那么用imageNamed的方法会比较好。例如：你需要在 一个TableView里的TableViewCell里都加载同样一个图标，
         那么用imageNamed加载图像效率很高。系统会把那个图标Cache到内存，在TableViewCell里每次利用那个图 像的时候，
         只会把图片指针指向同一块内存。正是因此使用imageNamed会缓存图片，即将图片的数据放在内存中，
         iOS的内存非常珍贵并且在内存消耗过大时，会强制释放内存，即会遇到memory warnings。
         而在iOS系统里面释放图像的内存是一件比较麻烦的事情，有可能会造成内存泄漏。
         例如：当一 个UIView对象的animationImages是一个装有UIImage对象动态数组NSMutableArray，
         并进行逐帧动画。当使用imageNamed的方式加载图像到一个动态数组NSMutableArray，
         这将会很有可能造成内存泄露。原因很显然的。
     
     */
    
    self.imageView.image = [UIImage imageNamed:@"Leo.jpg"];
    
}

#pragma mark -- imageWithContentsOfFile: 没有缓存,自动释放(传入文件的全路径)
- (void)setImageByPathFile {
    
    /* 仅加载图片，图像数据不会缓存。因此对于较大的图片以及使用情况较少时，那就可以用该方法，降低内存消耗。*/
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Leo" ofType:@"jpg"];
    NSData *image = [NSData dataWithContentsOfFile:filePath];
    self.imageView.image = [UIImage imageWithData:image]; //or = [UIImage imageWithContentsOfFile:filePath];
    
    //ps：从文件路径上学习到，如果将图片放到Assets.xcassets文件里，再通过NSBundle找不到资源了，但是放在其他任意位子（比如多个文件夹的子目录下）都是可以找到图片的
    
}

- (void)configure {
    
    //设置圆角
    self.imageView.layer.cornerRadius = 5;
    self.imageView.layer.masksToBounds = YES;
    
    
    //设置边框
    self.imageView.layer.borderWidth = 5;
    self.imageView.layer.borderColor = [UIColor redColor].CGColor;
    
    
    //添加手势点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.imageView addGestureRecognizer:tap];
    self.imageView.userInteractionEnabled = YES;
    
}


- (void)tap:(UIGestureRecognizer *)sender {
    
    NSLog(@"%s",__func__);
    
}


#pragma mark -- 帧动画触发事件
- (IBAction)TomCatEatAction:(UITapGestureRecognizer *)sender {
    
    NSLog(@"%s", __func__);

    //对于帧动画而言，如果希望在播放时，别再打断重新播放的话，添加如下代码即可
    if (self.tomCat.isAnimating) return;
    
    [self AnimationByFPSArray];

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSURL *url = [NSURL URLWithString:@"http://img1.imgtn.bdimg.com/it/u=2505641315,3514568628&fm=21&gp=0.jpg"];
    [self.web1Image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"3"] options:SDWebImageRetryFailed];
    
    NSURL *url1 = [NSURL URLWithString:@"http://img3.imgtn.bdimg.com/it/u=3779415739,908914254&fm=21&gp=0.jpg"];
    [self.web2Image sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"2"] options:SDWebImageRetryFailed];
    
}

- (IBAction)clearCache:(UIButton *)sender {
    
    [SDWebImageManager.sharedManager.imageCache clearMemory];
    [SDWebImageManager.sharedManager.imageCache clearDisk];
    
}

#pragma mark -- 图片压缩三种方法
- (UIImage*)scaleFromImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    if (width <= newSize.width && height <= newSize.height) {
        
        return image;
    }
    
    if (width == 0 || height == 0) {
        
        return image;
    }
    
    CGFloat widthFactor = newSize.width / width;
    CGFloat heightFactor = newSize.height / height;
    CGFloat scaleFactor = (widthFactor<heightFactor?widthFactor:heightFactor);
    
    CGFloat scaledWidth = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize targetSize = CGSizeMake(scaledWidth,scaledHeight);
    
    UIGraphicsBeginImageContext(targetSize);
    [image drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


#pragma mark -- 2（这是个uiimage的扩展）
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size {
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize {
    
    UIImage * sourceImage  = self;
    UIImage * newImage     = nil;
    CGSize imageSize       = sourceImage.size;
    CGFloat width          = imageSize.width;
    CGFloat height         = imageSize.height;
    CGFloat targetWidth    = targetSize.width;
    CGFloat targetHeight   = targetSize.height;
    CGFloat scaleFactor    = 0.0;
    CGFloat scaledWidth    = targetWidth;
    CGFloat scaledHeight   = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor) {
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor) {
                
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}


#pragma mark -- 3
- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth {
    
    CGSize imageSize     = sourceImage.size;
    CGFloat width        = imageSize.width;
    CGFloat height       = imageSize.height;
    CGFloat targetWidth  = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage * newImage   = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end


/*
 
 SDWebImage提供了极其简单的方法下载网络图片，最简单的情况下，只要提供图片素材的URL即可。
 SDWebImage提供的常见下载图片方法如下：
 -(void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
 -(void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options;
 -(void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;
 - (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;
 其中的主要参数有：
 
 URL：图片下载的URL
 placeholder：占位图，当图片无法下载时，显示占位图；
 option：下载图片时的下载选项，如:下载失败是否重新下载，后详述；
 progressBlock：下载过程中被不断调用，经常用于显示下载进度；
 completedBlock：下载后调用的代码。
 3、option选项
 
 SDWebImageRetryFailed = 1 << 0,  //失败后重试
 SDWebImageLowPriority = 1 << 1, //UI交互期间开始下载，导致延迟下载比如UIScrollView减速。
 SDWebImageCacheMemoryOnly = 1 << 2,//只进行内存缓存
 SDWebImageProgressiveDownload = 1 << 3,//这个标志可以渐进式下载,显示的图像是逐步在下载
 SDWebImageRefreshCached = 1 << 4,//刷新缓存
 SDWebImageContinueInBackground = 1 << 5,//后台下载
 SDWebImageHighPriority = 1 << 8,//优先下载
 SDWebImageDelayPlaceholder = 1 << 9, //延迟占位符
 SDWebImageTransformAnimatedImage = 1 << 10,//改变动画形象
 
 
 清除缓存以及内存
 
 由于SDWebImage提供了缓存机制，即下载过的图片，当需要再次显示时，则无需下载，因此SDWebImage也提供了清除缓存的方法。
 另外也可以支持当手机内存紧张时，暂停内存中的下载任务方法。
 [SDWebImageManager.sharedManager.imageCache clearMemory];
 [SDWebImageManager.sharedManager.imageCache clearDisk];
 
 
 */



