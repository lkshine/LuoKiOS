//
//  MyViewController.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/20.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

/*
 
 navigationController的方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated; // 入栈操作，显示新的子控制器

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated;//出栈操作，显示栈顶的控制器
- (nullable NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated; // 出栈操作，显示指定的控制器
- (nullable NSArray *)popToRootViewControllerAnimated:(BOOL)animated; // 出栈操作，显示导航控制器的根控制器


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

*/

@end


/*
 
 控制器之间也可以嵌套，不过一定要用strong属性哟
 
 @property(nonatomic,readonly) NSArray *childViewControllers NS_AVAILABLE_IOS(5_0);
 //存放所有子控制器的数组
 
 - (void)addChildViewController:(UIViewController *)childController NS_AVAILABLE_IOS(5_0);//添加子控制器
 
 - (void) removeFromParentViewController NS_AVAILABLE_IOS(5_0);//移除子控制器
 
 
 
 如果执行多次presentViewController：操作，新显示的控制器view会覆盖之前的控制器view，但旧的控制器view不会销毁，而是会被隐藏，直至执行了dismissViewControllerAnimated：方法，才会被销毁。
 
 
 
 显示一个普通类型的控制器可以使用如下方法
 - (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion;
 移除一个普通类型的控制器可以使用如下方法
 - (void)dismissViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion ;
 
 */
