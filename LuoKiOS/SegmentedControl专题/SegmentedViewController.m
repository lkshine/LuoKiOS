//
//  SegmentedViewController.m
//  iOS知识点总结项目 ---- 分段控件
//
//  Created by lkshine on 16/5/18.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "SegmentedViewController.h"

@interface SegmentedViewController ()

@property (nonatomic, strong) UISegmentedControl  * segment;
@property (nonatomic, weak)     UIView            * firstview;
@property (nonatomic, weak)     UIView            * secondview;
@property (nonatomic, weak)     UIView            * thirdview;

@end



@implementation SegmentedViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self segment];
}


- (UISegmentedControl *)segment {
    
    
    if ((!_segment)) {
        
        NSArray* segmenteArray = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4", nil];
        _segment = [[UISegmentedControl alloc]initWithItems:segmenteArray];//设置段数
        _segment.frame = CGRectMake(0, 20+64, wSrceem, 20);//设置位置
        [self configureSegment];
        [self.view addSubview:_segment];
        
        [_segment addTarget:self action:@selector(click:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _segment;
    
}


- (UIView *)firstview {
    
    if (_firstview == nil) {
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 40+20+64, self.view.bounds.size.width, 100);
        view.backgroundColor = [UIColor redColor];
        _firstview = view;
        
        [self.view addSubview:_firstview];
    }
    
    return _firstview;
}


- (UIView *)secondview {
    
    if (_secondview == nil) {
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 40+20+64+100, self.view.bounds.size.width, 100);
        view.backgroundColor = [UIColor blueColor];
        _secondview = view;
        
        [self.view addSubview:_secondview];
    }
    
    return _secondview;
}


- (UIView *)thirdview {
    
    if (_thirdview == nil) {
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 40+20+64+100+100, self.view.bounds.size.width, 100);
        view.backgroundColor = [UIColor orangeColor];
        _thirdview = view;
        [self.view addSubview:_thirdview];
    }
    
    return _thirdview;
}


- (void)configureSegment {
    
    [_segment setTitle:@"one" forSegmentAtIndex:0];//将第一段的标题设置为one
    [_segment insertSegmentWithTitle:@"insert" atIndex:1 animated:NO];//指定位置插入索引
    [_segment removeSegmentAtIndex:1 animated:NO];//移除指定位置的索引
    [_segment setWidth:10.0f forSegmentAtIndex:2];//设置指定索引的宽度
    _segment.selectedSegmentIndex = 1;//设置默认选择项索引
    _segment.tintColor = [UIColor redColor];
//    _segment.momentary = YES;//在点击后是否恢复原样
    
    /*  //如果需要用图片替代时，要非常小心其使用哟！
    [_segment setImage:[UIImage imageNamed:@"greenChat.png"] forSegmentAtIndex:1];//用1的图片为第二段命名
    [_segment insertSegmentWithImage:[UIImage imageNamed:@"purpleChat.png"] atIndex:2 animated:NO];
    
    //获取指定索引选项的图片imageForSegmentAtIndex：
    UIImageView *imageForSegmentAtIndex1 = [[UIImageView alloc]initWithImage:[_segment imageForSegmentAtIndex:1]];
    imageForSegmentAtIndex1.frame = CGRectMake(wSrceem/4, 20+64, 47, 20);
    
    UIImageView *imageForSegmentAtIndex = [[UIImageView alloc]initWithImage:[_segment imageForSegmentAtIndex:2]];
    imageForSegmentAtIndex.frame = CGRectMake(wSrceem/4*2, 20+64, 47, 20);
    
    [self.view addSubview:imageForSegmentAtIndex1];
    [self.view addSubview:imageForSegmentAtIndex];
     */
    
}


#pragma mark -- segmentClickAction
- (void)click:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
            
        case 0:{
            
            [self firstview];
            [self.secondview removeFromSuperview];
            [self.thirdview removeFromSuperview];
            NSLog(@"0");
        }
            break;
            
        case 1:{
            
            [self secondview];
            [self.firstview removeFromSuperview];
            [self.thirdview removeFromSuperview];
            NSLog(@"1");
        }
            break;
            
        case 2:{
            
            [self thirdview];
            [self.secondview removeFromSuperview];
            [self.firstview removeFromSuperview];
            NSLog(@"2");
        }
            break;
            
        default: {
            
            [self.secondview removeFromSuperview];
            [self.thirdview removeFromSuperview];
            [self.firstview removeFromSuperview];
            NSLog(@"3");
        }
            break;
    }
    
    
    /*
     
         三个view一定要设置成weak属性，否则removeFromSuperview 之后本身是不会销毁，
     也就导致remove了形体，灵魂还在，依然存在这个世间一样的概念，也就无法回轮投胎似得，
     详细参见：http://www.jianshu.com/p/6a222d693d50
     
     注意
     1. MRC中调用removeFromSuperview会执行retain操作，这一点估计没有用过MRC的iOS新人都不知道，可以考虑当作面试题😄。
     
     2. 永远不要在你的View的drawRect:方法中调用removeFromSuperview。
     
     
     */
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
