//
//  GCDSemaphoreController.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/23.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "GCDSemaphoreController.h"
#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 100
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING 10



@interface GCDSemaphoreController ()
{
    NSMutableArray *_imageViews;
//    NSMutableArray *_imageNames; 
    NSLock *_lock;
    dispatch_semaphore_t _semaphore;//定义一个信号量
}
@property (atomic, strong) NSMutableArray *imageNames;
@end

/*
    扩展--使用GCD解决资源抢占问题

    在GCD中提供了一种信号机制，也可以解决资源抢占问题（和同步锁的机制并不一样）。
    GCD中信号量是dispatch_semaphore_t类型，支持信号通知和信号等待。
    每当发送一个信号通知，则信号量+1；每当发送一个等待信号时信号量-1,；
    如果信号量为0则信号会处于等待状态，直到信号量大于0开始执行。
    根据这个原理我们可以初始化一个信号量变量，默认信号量设置为1，
    每当有线程进入“加锁代码”之后就调用信号等待命令（此时信号量为0）开始等待，
    此时其他线程无法进入，执行完后发送信号通知（此时信号量为1），
    其他线程开始进入执行，如此一来就达到了线程同步目的。
 
    另外，在上面的代码中”抢占资源“_imageNames定义成了成员变量，这么做是不明智的，
    应该定义为“原子属性”。对于被抢占资源来说将其定义为原子属性是一个很好的习惯，
    因为有时候很难保证同一个资源不在别处读取和修改。
    nonatomic属性读取的是内存数据（寄存器计算好的结果），
    而atomic就保证直接读取寄存器的数据，
    这样一来就不会出现一个线程正在修改数据，
    而另一个线程读取了修改之前（存储在内存中）的数据，
    永远保证同时只有一个线程在访问一个属性。
 
 */

@implementation GCDSemaphoreController


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
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(c*ROW_WIDTH+(c*CELL_SPACING), r*ROW_HEIGHT+(r*CELL_SPACING                           ), ROW_WIDTH, ROW_HEIGHT)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
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
    
/*
    初始化信号量
    参数是信号量初始值
 */
    _semaphore = dispatch_semaphore_create(1);
    
}

#pragma mark 将图片显示到界面
- (void)updateImageWithData:(NSData *)data andIndex:(int)index {
    
    UIImage * image = [UIImage imageWithData:data];
    UIImageView * imageView = _imageViews[index];
    imageView.image = image;
    
}

#pragma mark 请求图片数据
- (NSData *)requestData:(int)index {
    
    NSData      * data;
    NSString    * name;
    
/*
    信号等待
    第二个参数：等待时间
 */
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (_imageNames.count>0) {
        
        name = [_imageNames lastObject];
        [_imageNames removeObject:name];
    }
    
    //信号通知
    dispatch_semaphore_signal(_semaphore);
    
    
    if(name) {
        
        NSURL *url = [NSURL URLWithString:name];
        data = [NSData dataWithContentsOfURL:url];
    }
    
    return data;
}

#pragma mark 加载图片
- (void)loadImage:(NSNumber *)index {
    
    int i = (int)[index integerValue];
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
    //    dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //这里创建一个并发队列（使用全局并发队列也可以）
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
    
    for (int i = 0; i < count; i++) {
        
        dispatch_async(queue, ^{
            
            [self loadImage:[NSNumber numberWithInt:i]];
        });
    }
    
}



@end



