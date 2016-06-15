//
//  GCDViewCtrl.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/22.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "GCDViewCtrl.h"
#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 100
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING 10

@interface GCDViewCtrl ()
{
    NSMutableArray * _imageViews;
    NSMutableArray * _imageNames;
}
@end

/*
 由于GCD对线程管理进行了封装，因此，当工程师使用GCD时，
 只需要把任务（通常封装在一个block中）添加到一个队列中执行，
 有关线程调度的工作，完全交由GCD完成。
 
 在使用GCD处理多任务执行时，只要按照如下步骤执行即可，
 
 1.在block中定义需要执行的任务内容；
 2.把任务添加到队列queue中
 
 在GCD中，需要处理的事务统一使用block封装起来，称为任务。任务有两种类型，同步任务和异步任务。
 
 异步任务：执行任务时，会在另外的线程中执行；
 同步任务：执行任务时，会在当前的线程中执行，当前线程有可能是主线程，也有可能是子线程。
 
 并行队列：并行队列中的任务可以在多个线程之间分配执行，分配的原则由GCD控制，因此，并行队列中的任务，虽然分配执行时按照先进先出进行分配的，但由于各个任务被分配到不同的线程执行，因此其完成时间有可能不同，即：后分配的任务有可能先执行完成；并发队列一定需要和异步执行的任务(使用dispatch_async())结合起来使用才有意义。
 
 串行队列：串行队列中的任务是按照顺序一个一个完成的，当一个任务完成后，才去执行下一个任务；因此，串行队列对应一个线程执行。
 
 主队列：主队列也是一个串行队列，主队列中的任务都在主线程中执行。
 
 */

@implementation GCDViewCtrl

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
    button.frame=CGRectMake(50, 500, 220, 25);
    [button setTitle:@"加载图片" forState:UIControlStateNormal];
    //添加方法
    [button addTarget:self
               action:@selector(loadImageWithMultiThreadBySerial)//(loadImageWithMultiThreadByParallel)
     forControlEvents:UIControlEventTouchUpInside];
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
    
    NSURL * url = [NSURL URLWithString:_imageNames[index]];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    return data;
}

#pragma mark 加载图片
- (void)loadImage:(NSNumber *)index {
    
    //如果在串行队列中会发现当前线程打印变化完全一样，因为他们在一个线程中
    NSLog(@"thread is :%@", [NSThread currentThread]);
    
    int i = (int)[index integerValue];
    //请求数据
    NSData * data = [self requestData:i];
    
    //更新UI界面,此处调用了GCD主线程队列的方法
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_sync(mainQueue, ^{
        
        [self updateImageWithData:data andIndex:i];
    });
    
//    dispatch_async(mainQueue, ^{
//        [self updateImageWithData:data andIndex:i];
//    });
    
    
}

#pragma mark 多线程下载图片 -- 串行
- (void)loadImageWithMultiThreadBySerial {
    
    int count = ROW_COUNT*COLUMN_COUNT;
    
    /*
         创建一个串行队列
         第一个参数：队列名称
         第二个参数：队列类型
     */
    dispatch_queue_t serialQueue = dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
    
    //创建多个线程用于填充图片
    for (int i = 0; i < count; ++i) {
        
        //异步执行队列任务
        dispatch_async(serialQueue, ^{
            
            [self loadImage:[NSNumber numberWithInt:i]];
        });
        
//        //同步执行队列任务
//        dispatch_sync(serialQueue, ^{
//            
//            [self loadImage:[NSNumber numberWithInt:i]];
//        });
    }
    
    //非ARC环境请释放
    //    dispatch_release(seriQueue);
    
}


#pragma mark 多线程下载图片 -- 并行
- (void)loadImageWithMultiThreadByParallel {
    
    int count = ROW_COUNT*COLUMN_COUNT;
    
    /*取得全局队列
     第一个参数：线程优先级
     第二个参数：标记参数，目前没有用，一般传入0
     */
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //创建多个线程用于填充图片
    for (int i = 0; i < count; ++i) {
        
        //异步执行队列任务
        dispatch_async(globalQueue, ^{
            
            [self loadImage:[NSNumber numberWithInt:i]];
        });
        
//        //同步执行队列任务
//        dispatch_sync(globalQueue, ^{
//            
//            [self loadImage:[NSNumber numberWithInt:i]];
//        });
        
    }
}


/*

    使用dispatch_sync，可以看点击按钮后按钮无法再次点击，因为所有图片的加载全部在主线程中（可以打印线程查看），主线程被阻塞，造成图片最终是一次性显示。可以得出结论：

    1.在GDC中一个操作是多线程执行还是单线程执行取决于当前队列类型和执行方法，只有队列类型为并行队列并且使用异步方法执行时才能在多个线程中执行。
 
    2.串行队列可以按顺序执行，并行队列的异步方法无法确定执行顺序。
 
    3.UI界面的更新最好采用同步方法，其他操作采用异步方法。
 
 
 */

@end


/*
 
    其他任务执行方法

    GCD执行任务的方法并非只有简单的同步调用方法和异步调用方法，还有其他一些常用方法：

    dispatch_apply():重复执行某个任务，但是注意这个方法没有办法异步执行（为了不阻塞线程可以使用dispatch_async()包装一下再执行）。
 
    dispatch_once():单次执行一个任务，此方法中的任务只会执行一次，重复调用也没办法重复执行（单例模式中常用此方法）。
 
    dispatch_time()：延迟一定的时间后执行。
 
    dispatch_barrier_async()：使用此方法创建的任务首先会查看队列中有没有别的任务要执行，如果有，则会等待已有任务执行完毕再执行；同时在此方法后添加的任务必须等待此方法中任务执行后才能执行。（利用这个方法可以控制执行顺序，例如前面先加载最后一张图片的需求就可以先使用这个方法将最后一张图片加载的操作添加到队列，然后调用dispatch_async()添加其他图片加载任务）
 
    dispatch_group_async()：实现对任务分组管理，如果一组任务全部完成可以通过dispatch_group_notify()方法获得完成通知（需要定义dispatch_group_t作为分组标识）。
 
 */


