//
//  TempViewController.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/20.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "TempViewController.h"

@interface TempViewController ()

@end

@implementation TempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];//导航栏背景颜色
    self.navigationController.navigationBar.tintColor = [UIColor cyanColor];//导航栏背景颜色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;//导航栏样式
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"greenNav"]forBarMetrics:UIBarMetricsDefault];//设置导航栏背景图片
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
