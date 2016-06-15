//
//  RevealCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/6/2.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "RevealCtrl.h"
#import "FrontCtrl.h"
#import "RearCtrl.h"
#import "RightCtrl.h"


@interface RevealCtrl ()

@end



@implementation RevealCtrl


- (void)viewDidLoad {
    
    [super viewDidLoad];
  
    //左侧菜单栏
    RearCtrl *leftViewController = [[RearCtrl alloc] init];
    //    UIViewController * leftViewController = [UIViewController new];
    //    leftViewController.view.backgroundColor = [UIColor redColor];
    
    //首页
    FrontCtrl *centerView1Controller = [[FrontCtrl alloc] init];
    
    //右侧菜单栏
    RightCtrl *rightViewController = [[RightCtrl alloc] init];
    
    SWRevealViewController *revealViewController = [[SWRevealViewController alloc] initWithRearViewController:leftViewController frontViewController:centerView1Controller];
    revealViewController.rightViewController = rightViewController;
    
    //浮动层离左边距的宽度
    revealViewController.rearViewRevealWidth = 230;
    revealViewController.rightViewRevealWidth = 100;
    
    //是否让浮动层弹回原位
    //mainRevealController.bounceBackOnOverdraw = NO;
    [revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];

    [UIApplication sharedApplication].delegate.window.rootViewController = revealViewController;
    
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end


