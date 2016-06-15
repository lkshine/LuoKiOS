//
//  NSBlockOperationVC.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/22.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "NSBlockOperationVC.h"
#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 100
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING 10


@interface NSBlockOperationVC ()
{
    UIImageView     * _imageView;
    NSMutableArray  * _imageViews;
    NSMutableArray  * _imageNames;
    NSMutableArray  * _threads;
}
@end



@implementation NSBlockOperationVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self layoutUI2];
    
}

#pragma mark -- 加载图片的延时展示2
- (void)layoutUI2 {
    
    //创建多个图片控件用于显示图片
    _imageViews = [NSMutableArray array];
    
    for (int r = 0; r < ROW_COUNT; r++) {
        
        for (int c = 0; c < COLUMN_COUNT; c++) {
            
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(c*ROW_WIDTH+(c*CELL_SPACING), r*ROW_HEIGHT+(r*CELL_SPACING                           ), ROW_WIDTH, ROW_HEIGHT)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.backgroundColor = [UIColor redColor];
            [self.view addSubview:imageView];
            [_imageViews addObject:imageView];
            
        }
    }
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(50, 500, 220, 25);
    [button setTitle:@"加载图片" forState:UIControlStateNormal];
    
    //添加方法
    [button addTarget:self
               action:@selector(loadImageWithMultiThreadByOrder)//(loadImageWithMultiThread)//(loadImageWithMultiThreadWithInvacation)//(loadImageWithMultiThread2)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

#pragma mark 将图片显示到界面 -- NSBlockOperation
-(void)updateImageWithData:(NSData *)data andIndex:(int )index {
    
    UIImage * image = [UIImage imageWithData:data];
    UIImageView * imageView = _imageViews[index];
    imageView.image = image;
    
}


#pragma mark 请求图片数据 -- NSBlockOperation
- (NSData *)requestData:(int)index {
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%d.jpg", index]];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    return data;
}


#pragma mark 加载图片 -- NSBlockOperation
- (void)loadImage:(NSNumber *)index {
    
    int i = (int)[index integerValue];
    
    //请求数据
    NSData * data = [self requestData:i];
    NSLog(@"%@", [NSThread currentThread]);
    
    //更新UI界面,此处调用了主线程队列的方法（mainQueue是UI主线程）
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [self updateImageWithData:data andIndex:i];
    }];
    
}


#pragma mark 多线程下载图片 -- NSBlockOperation
- (void)loadImageWithMultiThread {
    
    int count = ROW_COUNT*COLUMN_COUNT;
    
    //创建操作队列
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc]init];
    operationQueue.maxConcurrentOperationCount = 5;//设置最大并发线程数
    
    //创建多个线程用于填充图片
    for (int i = 0; i < count; ++i) {
        
        //方法1：创建操作块添加到队列
//        //创建多线程操作
//        NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
//
//            [self loadImage:[NSNumber numberWithInt:i]];
//        }];
//        //创建操作队列
//
//        [operationQueue addOperation:blockOperation];
        
        //方法2：直接使用操队列添加操作
        [operationQueue addOperationWithBlock:^{
            
            [self loadImage:[NSNumber numberWithInt:i]];
        }];
        
    }
}


#pragma mark -- 线程执行顺序
- (void)loadImageWithMultiThreadByOrder {
    
    int count = ROW_COUNT*COLUMN_COUNT;
    
    //创建操作队列
    NSOperationQueue * operationQueue = [[NSOperationQueue alloc]init];
    operationQueue.maxConcurrentOperationCount = 5;//设置最大并发线程数
    
    NSBlockOperation * lastBlockOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        [self loadImage:[NSNumber numberWithInt:(count-1)]];
    }];
    
    //创建多个线程用于填充图片
    for (int i = 0; i < count-1; ++i) {
        //方法1：创建操作块添加到队列
        //创建多线程操作
        NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            [self loadImage:[NSNumber numberWithInt:i]];
        }];
        //设置依赖操作为最后一张图片加载操作
        [blockOperation addDependency:lastBlockOperation];
        
        [operationQueue addOperation:blockOperation];
        
    }
    //将最后一个图片的加载操作加入线程队列
    [operationQueue addOperation:lastBlockOperation];
    
    /*
     
     可以看到虽然加载最后一张图片的操作最后被加入到操作队列，但是它却是被第一个执行的。操作依赖关系可以设置多个，例如A依赖于B、B依赖于C…但是千万不要设置为循环依赖关系（例如A依赖于B，B依赖于C，C又依赖于A），否则是不会被执行的。
     
     */
    
}


/*
 
 对比之前NSThread加载张图片很发现核心代码简化了不少，这里着重强调两点：
 
 使用NSBlockOperation方法，所有的操作不必单独定义方法，同时解决了只能传递一个参数的问题。
 调用主线程队列的addOperationWithBlock:方法进行UI更新，不用再定义一个参数实体（之前必须定义一个KCImageData解决只能传递一个参数的问题）。
 使用NSOperation进行多线程开发可以设置最大并发线程，有效的对线程进行了控制（上面的代码运行起来你会发现打印当前进程时只有有限的线程被创建，如上面的代码设置最大线程数为5，则图片基本上是五个一次加载的）。
 
 
 */


@end
