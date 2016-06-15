//
//  NSLockController.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/23.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "NSLockController.h"
#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 100
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING 10

@interface NSLockController ()

{
    NSMutableArray *_imageViews;
//    NSMutableArray *_imageNames;

    //1.全局锁
    NSLock *_lock;
}
@property (atomic, strong) NSMutableArray *imageNames;
@end

/*
 
    iOS中对于资源抢占的问题可以使用同步锁NSLock来解决，
    使用时把需要加锁的代码（以后暂时称这段代码为”加锁代码“）
    放到NSLock的lock和unlock之间
    ，一个线程A进入加锁代码之后由于已经加锁，另一个线程B就无法访问，
    只有等待前一个线程A执行完加锁代码后解锁，B线程才能访问加锁代码。
    需要注意的是lock和unlock之间的”加锁代码“应该是抢占资源的读取和修改代码，
    不要将过多的其他操作代码放到里面，否则一个线程执行的时候另一个线程就一直在等待，
    就无法发挥多线程的作用了。

    另外，在上面的代码中”抢占资源“_imageNames定义成了成员变量，这么做是不明智的，
    应该定义为“原子属性”。对于被抢占资源来说将其定义为原子属性是一个很好的习惯，
    因为有时候很难保证同一个资源不在别处读取和修改。
    nonatomic属性读取的是内存数据（寄存器计算好的结果），
    而atomic就保证直接读取寄存器的数据，
    这样一来就不会出现一个线程正在修改数据，
    而另一个线程读取了修改之前（存储在内存中）的数据，
    永远保证同时只有一个线程在访问一个属性。
 
 */

@implementation NSLockController

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
    
    //2.初始化锁对象
    _lock = [[NSLock alloc]init];
    
}

#pragma mark 将图片显示到界面
- (void)updateImageWithData:(NSData *)data andIndex:(int)index {
    
    UIImage * image = [UIImage imageWithData:data];
    UIImageView * imageView = _imageViews[index];
    imageView.image = image;
    
}

#pragma mark 请求图片数据
- (NSData *)requestData:(int)index {
    
    NSData * data;
    NSString * name;
    
    //3.加锁
    [_lock lock];
    
    if (_imageNames.count > 0) {
        
        name = [_imageNames lastObject];
        [_imageNames removeObject:name];
    }
    
    //4.使用完解锁
    [_lock unlock];
    
    if (name) {
        
        NSURL * url = [NSURL URLWithString:name];
        data = [NSData dataWithContentsOfURL:url];
    }
    
    NSLog(@"[_lock tryLock] = %i", [_lock tryLock]);
    NSLog(@"[_lock lockBeforeData:data] = %i", [_lock lockBeforeDate:[NSDate date]]);
/*
 
     前面也说过使用同步锁时如果一个线程A已经加锁，线程B就无法进入。
     那么B怎么知道是否资源已经被其他线程锁住呢？
     可以通过tryLock方法，此方法会返回一个BOOL型的值，
     如果为YES说明获取锁成功，否则失败。
     另外还有一个lockBeforeData:方法指定在某个时间内获取锁，
     同样返回一个BOOL值，如果在这个时间内加锁成功则返回YES，失败则返回NO。
 
 */
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
