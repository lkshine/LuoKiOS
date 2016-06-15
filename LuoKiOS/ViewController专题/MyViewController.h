//
//  MyViewController.h
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/20.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyViewController : UIViewController

@end



/*
 代码，xib，storyboard三种创建viewcontroller的方法
 注意实例化控制器所使用的方法
 
 xib文件的File’s Owner属性为：MyViewController类
 MyViewController = [[MyViewController alloc] initWithNibName:@"MyViewController" bundle:nil];
 
 
 在StoryBoard中，也可以创建控制器，通过拖拉viewcontroller控件，可以添加一个控制器，需要注意：必须给该控制器指定其：Storyboard ID
 UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
 ViewController2 *VC2 = [storyBoard instantiateViewControllerWithIdentifier:@"SecondVC"];
 
 
 相对生命周期而言，storyboard创建的viewcontroller因为出来的早，所以“活的”最久，如下：
 2015-12-24 17:59:49.124 LifeCycle[15490:3842901] -[SBViewController1 initWithCoder:]
 2015-12-24 17:59:49.127 LifeCycle[15490:3842901] -[SBViewController1 awakeFromNib]
 2015-12-24 17:59:49.131 LifeCycle[15490:3842901] -[AppDelegate application:didFinishLaunchingWithOptions:]
 
 */