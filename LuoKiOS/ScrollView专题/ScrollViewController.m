//
//  ScrollViewController.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/13.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "ScrollViewController.h"

@interface ScrollViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView * scrollView;
@property (nonatomic, weak)          UIImageView  * imageView;

@end

/*
 
 UIScrollView的使用过程中有如下3个核心属性：
 
 contentSize：表示UIScrollView内容的尺寸，一般会大于屏幕大小；
 contentOffset：当前屏幕显示区域的原点（即左上角原点），在UIScrollView的位置；
 contentInset：可以在UIScrollView内容的四周增加额外的滚动区域。
 
 */

@implementation ScrollViewController


- (UIImageView *)imageView {
    
    if (!_imageView) {
        
        UIImage * image = [UIImage imageNamed:@"scoll.jpg"];
        UIImageView * tempImageview = [[UIImageView alloc]initWithImage:image];
        [self.scrollView addSubview:tempImageview];
        _imageView = tempImageview;
        
        /* 
            PS:
                 这里有个有意思的地方，
                 注意imageView的属性，是strong的话，不用tempImageview了，
                 这并不是关键，
                 我们需要注意的是 [self.scrollView addSubview:tempImageview];
                 是写在viewDidLoad里，还是LazyLoad里，这就取决于，
                 该图片是否能hold住，如果strong的话，哪儿都行，
                 如果是weak话，就在图片赋予的时候立刻给到scrollview才行，不然就失效无法显示了，
                 这里相当于补习了强弱引用的应用环境了
         */
    }
 
    return _imageView;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //ScrollView的属性
    self.scrollView.contentSize = self.imageView.bounds.size;
    self.scrollView.contentOffset = CGPointMake(100, 200);//CGPointZero;
    
    //边框效果
    self.scrollView.contentInset = UIEdgeInsetsMake(30, 50, 80, 100);
    //弹簧效果
    self.scrollView.bounces = NO;
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
//    [self.scrollView addSubview:_imageView];
    
    self.scrollView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark -- ScrollViewDelegate 
//当滚动时不断调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSLog(@"%s", __func__);
    
}

//即将开始滚动时调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    NSLog(@"%s", __func__);
}


//手指离开屏幕，停止滚动时调用

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    NSLog(@"%s", __func__);
}

#pragma mark -- 缩放图片专用代理
/*
 
 @property(nonatomic) CGFloat minimumZoomScale;     // 最小放大比例，取值范围0.0~1.0，默认1.0
 @property(nonatomic) CGFloat maximumZoomScale;    //最大放大比例，默认1.0
 
 */


//返回需要放大的控件，必须实现该方法
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    NSLog(@"%s", __func__);
    UIView * view = nil;
    return view;
}

// 即将开始缩放时调用
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    
    NSLog(@"%s", __func__);
}

//结束缩放时调用
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    
    NSLog(@"%s", __func__);
}

//缩放过程中不断调用该方法
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    NSLog(@"%s", __func__);
}


/*
 
 ScrollView应用场景一般就是轮播图，跑马灯这类应用，可以借鉴第三方 JScrollView+PageControl+AutoScroll 实现
 
 顺便说下实现的思路（"三刀流"）： 需要pageContrller, Image的数组, scrollview, NSTimer, 手势【可选】（用于选中相对于图片触发跳转事件）
 
 需要做的：设置scrollview的size为 3*屏宽， 设置一个滑动后定位 setContentOffset
 
 */


@end



