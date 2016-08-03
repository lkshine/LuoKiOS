//
//  NSInvocationOperationVC.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/22.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "NSInvocationOperationVC.h"
#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 100
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING 10

@interface NSInvocationOperationVC ()
{
    UIImageView     * _imageView;
    NSMutableArray  * _imageViews;
    NSMutableArray  * _imageNames;
    NSMutableArray  * _threads;
}
@end



@implementation NSInvocationOperationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI2];
}

#pragma mark -- 加载图片的延时展示2
- (void)layoutUI2 {
    
    //创建多个图片控件用于显示图片
    _imageViews = [NSMutableArray array];
    
    for (int r = 0; r<ROW_COUNT; r++) {
        
        for (int c = 0; c < COLUMN_COUNT; c++) {
            
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(c*ROW_WIDTH+(c*CELL_SPACING), r*ROW_HEIGHT+(r*CELL_SPACING                           ), ROW_WIDTH, ROW_HEIGHT)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            //            imageView.backgroundColor = [UIColor redColor];
            [self.view addSubview:imageView];
            [_imageViews addObject:imageView];
            
        }
    }
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(50, 500, 220, 25);
    [button setTitle:@"加载图片" forState:UIControlStateNormal];
    
    //添加方法
    [button addTarget:self action:@selector(loadImageWithMultiThreadWithInvacation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

#pragma mark 将图片显示到界面
- (void)updateImage2:(KCImageData *)imageData {
    
    UIImage * image = [UIImage imageWithData:imageData.data];
    UIImageView * imageView = _imageViews[imageData.index];
    imageView.image = image;
    
}

#pragma mark 请求图片数据
- (NSData *)requestData2:(int)index {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%d.jpg", index]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    return data;
}


#pragma mark 加载图片
- (void)loadImage2:(NSNumber *)index {
    
//    NSLog(@"%i",i);
//currentThread方法可以取得当前操作线程
    NSLog(@"current thread:%@", [NSThread currentThread]);
    
    int i = [index integerValue];
    
//    NSLog(@"%i",i);//未必按顺序输出
    
    NSData * data= [self requestData2:i];
    
    KCImageData * imageData = [[KCImageData alloc]init];
    imageData.index = i;
    imageData.data = data;
//    [self performSelectorOnMainThread:@selector(updateImage2:) withObject:imageData waitUntilDone:YES];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [self updateImage2:imageData];
    }];
    
    
}


#pragma mark 多线程下载图片
- (void)loadImageWithMultiThread2 {
    
    //创建多个线程用于填充图片
    for (int i = 0; i < ROW_COUNT*COLUMN_COUNT; ++i) {
        
        //        [NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:[NSNumber numberWithInt:i]];
        NSThread * thread = [[NSThread alloc]initWithTarget:self selector:@selector(loadImage2:) object:[NSNumber numberWithInt:i]];
        thread.name = [NSString stringWithFormat:@"myThread%i", i];//设置线程名称
        [thread start];
        
    }
}

/*
 
    首先使用NSInvocationOperation进行一张图片的加载演示，
    整个过程就是：创建一个操作，在这个操作中指定调用方法和参数，然后加入到操作队列。
    其他代码基本不用修改，直接修加载图片方法如下
 
 */
#pragma mark 多线程下载图片 -- NSInvocationOperation
- (void)loadImageWithMultiThreadWithInvacation {
    
    /*
     创建一个调用操作
     object:调用方法参数
     */
    
    for (int i = 0; i < ROW_COUNT*COLUMN_COUNT; ++i) {
        
        NSInvocationOperation * invocationOperation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(loadImage2:) object:[NSNumber numberWithInt:i]];
        //创建完NSInvocationOperation对象并不会调用，它由一个start方法启动操作，但是注意如果直接调用start方法，则此操作会在主线程中调用，一般不会这么操作,而是添加到NSOperationQueue中
        //    [invocationOperation start];
        
        //创建操作队列
        NSOperationQueue * operationQueue = [[NSOperationQueue alloc]init];
        //注意添加到操作队后，队列会开启一个线程执行此操作
        [operationQueue addOperation:invocationOperation];
        
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
