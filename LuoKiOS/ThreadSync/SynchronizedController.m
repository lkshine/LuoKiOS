//
//  SynchronizedController.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/23.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "SynchronizedController.h"
#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 100
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING 10


@interface SynchronizedController ()

{
    NSMutableArray *_imageViews;
//    NSMutableArray *_imageNames;
}
@property (atomic, strong) NSMutableArray * imageNames;
@end

/*
    使用@synchronized解决线程同步问题相比较NSLock要简单一些，
    日常开发中也更推荐使用此方法。首先选择一个对象作为同步对象（一般使用self），
    然后将”加锁代码”（争夺资源的读取、修改代码）放到代码块中。
    @synchronized中的代码执行时先检查同步对象是否被另一个线程占用，
    如果占用该线程就会处于等待状态，直到同步对象被释放。
 
    代码中”抢占资源“_imageNames定义成了成员变量，这么做是不明智的，
    应该定义为“原子属性”。对于被抢占资源来说将其定义为原子属性是一个很好的习惯，
    因为有时候很难保证同一个资源不在别处读取和修改。
    nonatomic属性读取的是内存数据（寄存器计算好的结果），
    而atomic就保证直接读取寄存器的数据，这样一来就不会出现一个线程正在修改数据，
    而另一个线程读取了修改之前（存储在内存中）的数据，永远保证同时只有一个线程在访问一个属性。
 */

@implementation SynchronizedController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self layoutUI];
}

#pragma mark 界面布局
- (void)layoutUI {
    
    //创建多个图片控件用于显示图片
    _imageViews = [NSMutableArray array];
    for (int r = 0; r < ROW_COUNT; r++) {
        
        for (int c = 0; c < COLUMN_COUNT; c++) {
            
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(c*ROW_WIDTH+(c*CELL_SPACING), r*ROW_HEIGHT+(r*CELL_SPACING                           ), ROW_WIDTH, ROW_HEIGHT)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
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
- (void)updateImageWithData:(NSData *)data andIndex:(int)index {
    
    UIImage * image = [UIImage imageWithData:data];
    UIImageView * imageView = _imageViews[index];
    imageView.image = image;
    
}

#pragma mark 请求图片数据
- (NSData *)requestData:(int)index {
    
    NSData *data;
    NSString *name;
    
    //线程同步
    @synchronized(self) {
        
        if (_imageNames.count > 0) {
            
            name = [_imageNames lastObject];
            [NSThread sleepForTimeInterval:0.001f];
            [_imageNames removeObject:name];
        }
    }
    if (name) {
        
        NSURL *url=[NSURL URLWithString:name];
        data=[NSData dataWithContentsOfURL:url];
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
