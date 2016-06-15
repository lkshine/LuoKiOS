//
//  PageController.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/19.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "PageController.h"

@interface PageController ()

@property (nonatomic, strong) UIPageControl * myPageControl;//     CustomPageCtrl
@property (weak, nonatomic) IBOutlet UIPageControl *xibPageCtrl;

@end



@implementation PageController


- (UIPageControl *)myPageControl {
    
    if (!_myPageControl) {
        
        _myPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(180, 300, 50, 10)];
        
        _myPageControl.numberOfPages = 6;
        _myPageControl.currentPage = 1;
        _myPageControl.userInteractionEnabled = YES;
        _myPageControl.pageIndicatorTintColor = [UIColor greenColor];
        _myPageControl.currentPageIndicatorTintColor = [UIColor redColor];
        
        [_myPageControl addTarget:self action:@selector(change) forControlEvents:UIControlEventValueChanged];//当点击控件就会掉用change方法
        
        [self.view addSubview:_myPageControl];
    }
    
    return _myPageControl;
}


- (IBAction)xibPageCtrlAction:(UIPageControl *)sender {
    
    NSLog(@"%s",__func__);
}

//实现change方法
- (void)change {
    
    NSLog(@"change");
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self myPageControl];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}



@end

/*
 
 JScrollView_PageControl_AutoScroll 第三方轮播图
 
 */




