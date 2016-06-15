//
//  NSThreadController.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/22.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "NSThreadController.h"
#import "KCImageData.h"
#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 100
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING 10




@interface NSThreadController ()

{
    UIImageView     * _imageView;
    NSMutableArray  * _imageViews;
    NSMutableArray  * _imageNames;
    NSMutableArray  * _threads;
}
@property (weak, nonatomic) IBOutlet UILabel * label1;
@property (weak, nonatomic) IBOutlet UILabel * label2;
@property (weak, nonatomic) IBOutlet UILabel * label3;

@end



@implementation NSThreadController


- (void)viewDidLoad {
    
    [super viewDidLoad];
//    [self layoutUI1];
//    [self layoutUI2];
    [self layoutUI3];
    
}


- (NSString *)generateString1 {
    
    //阻塞主进程
    [NSThread sleepForTimeInterval:3.0];
    
    NSString * string = @"hello world!";
    
    return string;
}

- (NSString *)generateString2 {
    
    //阻塞主进程
    [NSThread sleepForTimeInterval:3.0];
    
    NSString *string = @"I am Apple!";
    
    return string;
}

- (NSString *)generateString3 {
    
    //阻塞主进程
    [NSThread sleepForTimeInterval:3.0];
    
    NSString *string = @"2016!";
    
    return string;
}

- (IBAction)showContent:(UIButton *)sender {
    
    //记录开始时间
    NSLog(@"\n Start Time:%@, \n Current Thread: %@, \n Main Thread: %@", [NSDate date], [NSThread currentThread], [NSThread mainThread]);
    self.label1.text = [self generateString1];
    self.label2.text = [self generateString2];
    self.label3.text = [self generateString3];
    //记录结束时间
    NSLog(@"\n End Time:%@, \n Current Thread: %@, \n Main Thread: %@", [NSDate date], [NSThread currentThread], [NSThread mainThread]);
    
}


#pragma mark -- 加载图片的延时展示1
#pragma mark 界面布局
- (void)layoutUI1 {
    
    _imageView =[[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(50, 500, 220, 25);
    [button setTitle:@"加载图片" forState:UIControlStateNormal];
    
    //添加方法
    [button addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

#pragma mark 将图片显示到界面
- (void)updateImage:(NSData *)imageData {
    
    UIImage * image = [UIImage imageWithData:imageData];
    _imageView.image = image;
    
}   //主线程UI更新操作

#pragma mark 请求图片数据
- (NSData *)requestData {
    
    NSURL * url = [NSURL URLWithString:@"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_1.jpg"];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    return data;
}   //网络请求延时操作

#pragma mark 加载图片
- (void)loadImage {
    
    //请求数据
    NSData * data = [self requestData];
    
    /*
        将数据显示到UI控件,注意只能在主线程中更新UI,
        另外performSelectorOnMainThread方法是NSObject的分类方法，每个NSObject对象都有此方法，
        它调用的selector方法是当前调用控件的方法，例如使用UIImageView调用的时候selector就是UIImageView的方法
        Object：代表调用方法的参数,不过只能传递一个参数(如果有多个参数请使用对象进行封装)
        waitUntilDone:是否线程任务完成执行
     */
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:data waitUntilDone:YES];


}

#pragma mark 多线程下载图片
- (void)loadImageWithMultiThread {
    
    //方法1：使用对象方法
    //创建一个线程，第一个参数是请求的操作，第二个参数是操作方法的参数
    //    NSThread * thread = [[NSThread alloc]initWithTarget:self selector:@selector(loadImage) object:nil];
    //    //启动一个线程，注意启动一个线程并非就一定立即执行，而是处于就绪状态，当系统调度时才真正执行
    //    [thread start];
    
    //方法2：使用类方法
    [NSThread detachNewThreadSelector:@selector(loadImage) toTarget:self withObject:nil];
    
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
    [button addTarget:self action:@selector(loadImageWithMultiThread2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

#pragma mark 将图片显示到界面
- (void)updateImage2:(KCImageData *)imageData {
    
    UIImage *image = [UIImage imageWithData:imageData.data];
    UIImageView *imageView = _imageViews[imageData.index];
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
    
    int i = (int)[index integerValue];
    
//    NSLog(@"%i",i);//未必按顺序输出
    
    NSData * data= [self requestData2:i];
    
    KCImageData * imageData = [[KCImageData alloc]init];
    imageData.index = i;
    imageData.data = data;
    [self performSelectorOnMainThread:@selector(updateImage2:) withObject:imageData waitUntilDone:YES];
    
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

#pragma mark -- 加载图片的延时展示3
#pragma mark 界面布局
- (void)layoutUI3 {
    
    //创建多个图片空间用于显示图片
    _imageViews = [NSMutableArray array];
    
    for (int r = 0; r < ROW_COUNT; r++) {
        
        for (int c = 0; c < COLUMN_COUNT; c++) {
            
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(c*ROW_WIDTH+(c*CELL_SPACING), r*ROW_HEIGHT+(r*CELL_SPACING                           ), ROW_WIDTH, ROW_HEIGHT)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
//            imageView.backgroundColor = [UIColor redColor];
            [self.view addSubview:imageView];
            [_imageViews addObject:imageView];
            
        }
    }
    
    //加载按钮
    UIButton *buttonStart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonStart.frame = CGRectMake(50, 500, 100, 25);
    [buttonStart setTitle:@"加载图片" forState:UIControlStateNormal];
    [buttonStart addTarget:self action:@selector(loadImageWithMultiThread3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonStart];
    
    //停止按钮
    UIButton *buttonStop = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonStop.frame = CGRectMake(160, 500, 100, 25);
    [buttonStop setTitle:@"停止加载" forState:UIControlStateNormal];
    [buttonStop addTarget:self action:@selector(stopLoadImage3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonStop];
    
    //创建图片链接
    _imageNames = [NSMutableArray array];
    for (int i = 0; i < ROW_COUNT*COLUMN_COUNT; i++) {
        
        [_imageNames addObject:[NSString stringWithFormat:@"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%i.jpg", i]];
   
    }
         
}
     
#pragma mark 将图片显示到界面
- (void)updateImage3:(KCImageData *)imageData {
 
     UIImage * image = [UIImage imageWithData:imageData.data];
     UIImageView * imageView = _imageViews[imageData.index];
     imageView.image = image;
 
}
     
#pragma mark 请求图片数据
- (NSData *)requestData3:(int)index {
 
    NSLog(@"index = %d", index);
    NSURL * url = [NSURL URLWithString:_imageNames[index]];
    NSData * data = [NSData dataWithContentsOfURL:url];

    return data;
}
 
#pragma mark 加载图片
- (void)loadImage3:(NSNumber *)index {
    
    int i = (int)[index integerValue];

    NSData *data = [self requestData3:i];

    NSThread *currentThread = [NSThread currentThread];

    //    如果当前线程处于取消状态，则退出当前线程
    if (currentThread.isCancelled) {
     
        NSLog(@"thread(%@) will be cancelled!", currentThread);
        [NSThread exit];//取消当前线程
    }

    KCImageData * imageData = [[KCImageData alloc]init];
    imageData.index = i;
    imageData.data = data;
    [self performSelectorOnMainThread:@selector(updateImage3:) withObject:imageData waitUntilDone:YES];

}
     
#pragma mark 多线程下载图片
- (void)loadImageWithMultiThread3 {
    
    int count = ROW_COUNT*COLUMN_COUNT;
    NSLog(@"count = %d", count);
    _threads = [NSMutableArray arrayWithCapacity:count];
     
    //创建多个线程用于填充图片
    for (int i = 0; i < count; ++i) {
         
        NSThread * thread = [[NSThread alloc]initWithTarget:self selector:@selector(loadImage3:) object:[NSNumber numberWithInt:i]];
        thread.name = [NSString stringWithFormat:@"myThread%i", i];//设置线程名称
        [_threads addObject:thread];
        
    }
    //循环启动线程
    for (int i = 0; i < count; ++i) {
         
        NSThread * thread = _threads[i];
        [thread start];
    }
    
//    //等同下面效果
//    //在后台执行一个操作，本质就是重新创建一个线程执行当前方法。
//    for (int i = 0; i<count; ++i) {
//        [self performSelectorInBackground:@selector(loadImage3:) withObject:[NSNumber numberWithInt:i]];
//    }
    
}

     
#pragma mark 停止加载图片
- (void)stopLoadImage3 {

    for (int i = 0; i < ROW_COUNT*COLUMN_COUNT; i++) {
     
         NSThread *thread = _threads[i];
         //判断线程是否完成，如果没有完成则设置为取消状态
         //注意设置为取消状态仅仅是改变了线程状态而言，并不能终止线程
         
         if (!thread.isFinished) {
             
             [thread cancel];
         }
    }
    
}

     
- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];

}
 
/*
 
    使用NSThread在进行多线程开发过程中操作比较简单，但是要控制线程执行顺序并不容易（前面万不得已采用了休眠的方法），另外在这个过程中如果打印线程会发现循环几次就创建了几个线程，这在实际开发过程中是不得不考虑的问题，因为每个线程的创建也是相当占用系统开销的。


    扩展--NSObject分类扩展方法

    为了简化多线程开发过程，苹果官方对NSObject进行分类扩展(本质还是创建NSThread)，对于简单的多线程操作可以直接使用这些扩展方法。

    - (void)performSelectorInBackground:(SEL)aSelector withObject:(id)arg：在后台执行一个操作，本质就是重新创建一个线程执行当前方法。

    - (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait：在指定的线程上执行一个方法，需要用户创建一个线程对象。

    - (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait：在主线程上执行一个方法（前面已经使用过）。

 */
 
 
@end
     
     
