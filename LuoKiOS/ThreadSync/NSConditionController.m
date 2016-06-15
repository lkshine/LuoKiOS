//
//  NSConditionController.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/23.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "NSConditionController.h"
#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 100
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING 10
#define IMAGE_COUNT 9


@interface NSConditionController ()

{
    NSMutableArray *_imageViews;
    NSCondition *_condition;
}
#pragma mark 图片资源存储容器
@property (atomic,strong) NSMutableArray *imageNames;

#pragma mark 当前加载的图片索引（图片链接地址连续）
@property (atomic,assign) int currentIndex;

@end

/*
 
    扩展--控制线程通信

    由于线程的调度是透明的，程序有时候很难对它进行有效的控制，
    为了解决这个问题iOS提供了NSCondition来控制线程通信(同前面GCD的信号机制类似)。
    NSCondition实现了NSLocking协议，所以它本身也有lock和unlock方法，
    因此也可以将它作为NSLock解决线程同步问题，此时使用方法跟NSLock没有区别，
    只要在线程开始时加锁，取得资源后释放锁即可，这部分内容比较简单在此不再演示。
    当然，单纯解决线程同步问题不是NSCondition设计的主要目的，
    NSCondition更重要的是解决线程之间的调度关系（当然，这个过程中也必须先加锁、解锁）。
    NSCondition可以调用wati方法控制某个线程处于等待状态，
    直到其他线程调用signal（此方法唤醒一个线程，如果有多个线程在等待则任意唤醒一个）
    或者broadcast（此方法会唤醒所有等待线程）方法唤醒该线程才能继续。

    假设当前imageNames没有任何图片，而整个界面能够加载15张图片（每张都不能重复），
    现在创建15个线程分别从imageNames中取图片加载到界面中。
    由于imageNames中没有任何图片，那么15个线程都处于等待状态，
    只有当调用图片创建方法往imageNames中添加图片后（每次创建一个）
    并且唤醒其他线程（这里只唤醒一个线程）才能继续执行加载图片。
    如此，每次创建一个图片就会唤醒一个线程去加载，
    这个过程其实就是一个典型的生产者-消费者模式。
 
 */


@implementation NSConditionController

#pragma mark - 事件
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self layoutUI];
}

#pragma mark - 内部私有方法
#pragma mark 界面布局
- (void)layoutUI {
    
    //创建多个图片控件用于显示图片
    _imageViews = [NSMutableArray array];
    
    for (int r = 0; r < ROW_COUNT; r++) {
        
        for (int c = 0; c < COLUMN_COUNT; c++) {
            
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(c*ROW_WIDTH+(c*CELL_SPACING), r*ROW_HEIGHT+(r*CELL_SPACING                           ), ROW_WIDTH, ROW_HEIGHT)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.view addSubview:imageView];
            [_imageViews addObject:imageView];
        }
    }
    
    UIButton * btnLoad = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnLoad.frame = CGRectMake(50, 500, 100, 25);
    [btnLoad setTitle:@"加载图片" forState:UIControlStateNormal];
    [btnLoad addTarget:self
                action:@selector(loadImageWithMultiThread)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLoad];
    
    UIButton * btnCreate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCreate.frame = CGRectMake(160, 500, 100, 25);
    [btnCreate setTitle:@"创建图片" forState:UIControlStateNormal];
    [btnCreate addTarget:self
                  action:@selector(createImageWithMultiThread)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCreate];
    
    //创建图片链接
    _imageNames = [NSMutableArray array];
    
    //初始化锁对象
    _condition = [[NSCondition alloc]init];
    
    _currentIndex = 0;
    
}


#pragma mark 创建图片
- (void)createImageName {
    
    [_condition lock];
    
    //如果当前已经有图片了则不再创建，线程处于等待状态
    if (_imageNames.count > 0) {
        
        NSLog(@"createImageName wait, current:%i", _currentIndex);
        [_condition wait];
    }
    else {
        
        NSLog(@"createImageName work, current:%i", _currentIndex);
        //生产者，每次生产1张图片
        [_imageNames addObject:[NSString stringWithFormat:@"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%i.jpg", _currentIndex++]];
        
        //创建完图片则发出信号唤醒其他等待线程
        [_condition signal];
    }
    
    [_condition unlock];
}


/*
 
    在上面的代码中loadImage:方法是消费者，
    当在界面中点击“加载图片”后就创建了15个消费者线程。
    在这个过程中每个线程进入图片加载方法之后都会先加锁，
    加锁之后其他进程是无法进入“加锁代码”的。
    但是第一个线程进入“加锁代码”后去加载图片却发现当前并没有任何图片，因此它只能等待。
 
    一旦调用了NSCondition的wait方法后其他线程就可以继续进入“加锁代码”(
    注意，这一点和前面说的NSLock、@synchronized等是不同的，
    使用NSLock、@synchronized等进行加锁后无论什么情况下，
    只要没有解锁其他线程就无法进入“加锁代码”），
 
    同时第一个线程处于等待队列中（此时并未解锁）。第二个线程进来之后同第一线程一样，
    发现没有图片就进入等待状态，然后第三个线程进入。。。
    如此反复，直到第十五个线程也处于等待。此时点击“创建图片”后会执行createImageName方法，
    这是一个生产者，它会创建一个图片链接放到imageNames中，
    然后通过调用NSCondition的signal方法就会在条件等待队列中选择一个线程（
    该线程会任意选取，假设为线程A）开启，那么此时这个线程就会继续执行。
    在上面代码中，wati方法之后会继续执行图片加载方法，
    那么此时线程A启动之后继续执行图片加载方法，当然此时可以成功加载图片。
    加载完图片之后线程A就会释放锁，整个线程任务完成。
    此时再次点击”创建图片“按钮重复前面的步骤加载其他图片。
 
 */



#pragma mark 加载图片并将图片显示到界面
- (void)loadAnUpdateImageWithIndex:(int)index {
    
    //请求数据
    NSData *data = [self requestData:index];
    
    //更新UI界面,此处调用了GCD主线程队列的方法
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_sync(mainQueue, ^{
        
        UIImage * image = [UIImage imageWithData:data];
        UIImageView * imageView = _imageViews[index];
        imageView.image = image;
    });
    
}

#pragma mark 请求图片数据
- (NSData *)requestData:(int)index {
    
    NSData      * data;
    NSString    * name;
    
    name=[_imageNames lastObject];
    [_imageNames removeObject:name];
    
    if(name) {
        
        NSURL *url = [NSURL URLWithString:name];
        data = [NSData dataWithContentsOfURL:url];
    }
    
    return data;
}

#pragma mark 加载图片
- (void)loadImage:(NSNumber *)index {
    
    int i = (int)[index integerValue];
    
    //加锁
    [_condition lock];
    
    //如果当前有图片资源则加载，否则等待
    if (_imageNames.count > 0) {
        
        NSLog(@"loadImage work,index is %i", i);
        [self loadAnUpdateImageWithIndex:i];
        [_condition broadcast];
    }
    else {
        
        NSLog(@"loadImage wait,index is %i", i);
        NSLog(@"%@", [NSThread currentThread]);
        
        //线程等待
        [_condition wait];
        
        NSLog(@"loadImage resore,index is %i", i);
        //一旦创建完图片立即加载
        [self loadAnUpdateImageWithIndex:i];
    }
    
    //解锁
    [_condition unlock];
    
}


#pragma mark - UI调用方法
#pragma mark 异步创建一张图片链接
- (void)createImageWithMultiThread {
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //创建图片链接
    dispatch_async(globalQueue, ^{
        
        [self createImageName];
    });
    
}

#pragma mark 多线程下载图片
- (void)loadImageWithMultiThread {
    
    int count = ROW_COUNT*COLUMN_COUNT;
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for (int i = 0; i < count; ++i) {
        
        //加载图片
        dispatch_async(globalQueue, ^{
            
            [self loadImage:[NSNumber numberWithInt:i]];
        });
    }
    
}

@end


