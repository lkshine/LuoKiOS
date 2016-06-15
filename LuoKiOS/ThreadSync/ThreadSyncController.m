//
//  ThreadSyncController.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/23.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "ThreadSyncController.h"
#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 100
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING 10



@interface ThreadSyncController ()

{
    NSMutableArray *_imageViews;
    NSMutableArray *_imageNames;
}


@end

/*
 
    iOS中的其他锁

    常用：
        1.NSLock;
        2.@synchronized代码块;
        3.GCD信号机制(dispatch_semaphore_t);
        4.NSCondition控制线程通信.

    在iOS开发中，除了同步锁有时候还会用到一些其他锁类型，在此简单介绍一下：

    NSRecursiveLock ：递归锁，有时候“加锁代码”中存在递归调用，递归开始前加锁，递归调用开始后会重复执行此方法以至于反复执行加锁代码最终造成死锁，这个时候可以使用递归锁来解决。使用递归锁可以在一个线程中反复获取锁而不造成死锁，这个过程中会记录获取锁和释放锁的次数，只有最后两者平衡锁才被最终释放。

    NSDistributedLock：分布锁，它本身是一个互斥锁，基于文件方式实现锁机制，可以跨进程访问。

    pthread_mutex_t：同步锁，基于C语言的同步锁机制，使用方法与其他同步锁机制类似。

    提示：在开发过程中除非必须用锁，否则应该尽可能不使用锁，因为多线程开发本身就是为了提高程序执行顺序，而同步锁本身就只能一个进程执行，这样不免降低执行效率。
     
 */


@implementation ThreadSyncController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
}

#pragma mark 界面布局
- (void)layoutUI {
    
    //创建多个图片控件用于显示图片
    _imageViews=[NSMutableArray array];
    for (int r = 0; r < ROW_COUNT; r++) {
        
        for (int c = 0; c < COLUMN_COUNT; c++) {
            
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(c*ROW_WIDTH+(c*CELL_SPACING), r*ROW_HEIGHT+(r*CELL_SPACING                           ), ROW_WIDTH, ROW_HEIGHT)];
            imageView.contentMode=UIViewContentModeScaleAspectFit;
//            imageView.backgroundColor=[UIColor redColor];
            [self.view addSubview:imageView];
            [_imageViews addObject:imageView];
            
        }
    }
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(50, 500, 220, 25);
    [button setTitle:@"加载图片" forState:UIControlStateNormal];
    //添加方法
    [button addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //创建图片链接
    _imageNames = [NSMutableArray array];
    for (int i = 0; i < ROW_COUNT*COLUMN_COUNT; i++) {
        
        [_imageNames addObject:[NSString stringWithFormat:@"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%i.jpg", i]];
    }
    
}

#pragma mark 将图片显示到界面
- (void)updateImageWithData:(NSData *)data andIndex:(int )index {
    
    UIImage * image = [UIImage imageWithData:data];
    UIImageView * imageView = _imageViews[index];
    imageView.image = image;
    
}

#pragma mark 请求图片数据
- (NSData *)requestData:(int)index {
    
    NSData * data;
    NSString * name;
    
    if (_imageNames.count > 0) {
        
        name = [_imageNames lastObject];
        [_imageNames removeObject:name];
    }
    if (name) {
        
        NSURL * url = [NSURL URLWithString:name];
        data = [NSData dataWithContentsOfURL:url];
    }
    
    return data;
}

#pragma mark 加载图片
- (void)loadImage:(NSNumber *)index {
    
    int i = (int)[index integerValue];
//    [NSThread sleepForTimeInterval:0.2];
    
    //请求数据
    NSData * data = [self requestData:i];
    
    //更新UI界面,此处调用了GCD主线程队列的方法
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_sync(mainQueue, ^{
        
        [self updateImageWithData:data andIndex:i];
    });
    
}

#pragma mark 多线程下载图片
- (void)loadImageWithMultiThread {
    
    int count = ROW_COUNT*COLUMN_COUNT;
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建多个线程用于填充图片
    for (int i = 0; i < count; ++i) {
        //异步执行队列任务
        dispatch_async(globalQueue, ^{
            
            [self loadImage:[NSNumber numberWithInt:i]];
        });
    }
    
}


@end

/*

    上面这个结果不一定每次都出现，关键要看从_imageNames读取链接、删除链接的速度，
    如果足够快可能不会有任何问题，但是如果速度稍慢就会出现上面的情况，
    很明显上面情况并不满足前面的需求。

    分析这个问题造成的原因主：当一个线程A已经开始获取图片链接，
    获取完之后还没有来得及从_imageNames中删除，另一个线程B已经进入相应代码中，
    由于每次读取的都是_imageNames的最后一个元素，
    因此后面的线程其实和前面线程取得的是同一个图片链接这样就造成图中看到的情况。
    要解决这个问题，只要保证线程A进入相应代码之后B无法进入，
    只有等待A完成相关操作之后B才能进入即可。
    下面分别使用NSLock和@synchronized对代码进行修改。

 */
