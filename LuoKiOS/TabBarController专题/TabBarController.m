//
//  TabBarController.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/20.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "TabBarController.h"


@interface TabBarController ()<UITabBarDelegate, UITabBarControllerDelegate>

@property (nonatomic, strong) UITabBar              * tabBar;
@property (nonatomic, strong) UITabBarController    * tabBarCtrl;
@property (nonatomic, strong) UITabBarItem          * firstItem;
@property (nonatomic, strong) UITabBarItem          * secondItem;
@property (nonatomic, strong) UITabBarItem          * thirdItem;
@property (nonatomic, strong) UIView                * firstView;
@property (nonatomic, strong) UIView                * secondView;
@property (nonatomic, strong) UIView                * thirdView;

@end



@implementation TabBarController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self tabBar];
//    [self creatCtrls];
    
}

#pragma mark -- tabBar视图
- (UITabBar *)tabBar {
    
    if (!_tabBar) {
        
        _tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0,hSrceem-55, wSrceem, 50)];
        //将tabBar加到父视图
        [self.view addSubview:_tabBar];
        
        //初始化三个item
        _firstItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:0];//系统图标创建标签项
        _secondItem = [[UITabBarItem alloc] initWithTitle:@"百度" image:[UIImage imageNamed:@"weChat.png"]  tag:1];//用用户图标创建标签项
        _thirdItem = [[UITabBarItem alloc] initWithTitle:@"宏创" image:[UIImage imageNamed:@"weChat.png"] tag:2];
        //为secondItem设置徽标
        _secondItem.badgeValue = @"2";//item的徽标
        
        _tabBar.items = @[self.firstItem,self.secondItem,self.thirdItem];//设置多个标签项
        //tabBar.barStyle = UIBarStyleBlack;
        _tabBar.backgroundColor = [UIColor redColor];//背景色
        // tabBar.backgroundImage = [UIImage imageNamed:@"1"];//背景图片
        _tabBar.tintColor = [UIColor blackColor];//选中item的颜色
        // tabBar.barTintColor = [UIColor greenColor];//bar的颜色
        _tabBar.translucent = YES;//是否半透明
        
        _tabBar.delegate = self;
        [self configCustomTabBarStlye];
    }
    
    return _tabBar;
}

#pragma mark -- 配置自定义bar样式
- (void)configCustomTabBarStlye {
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -15, self.tabBar.frame.size.width, self.tabBar.frame.size.height)];
    [imageView setImage:[UIImage imageNamed:@"tabbar_bg"]];
    [imageView setContentMode:UIViewContentModeCenter];
    [self.tabBar insertSubview:imageView atIndex:0];
    //覆盖原生Tabbar的上横线
    [[UITabBar appearance] setShadowImage:[self createImageWithColor:[UIColor clearColor]]];
    [[UITabBar appearance] setBackgroundImage:[self createImageWithColor:[UIColor clearColor]]];
    //设置TintColor
    UITabBar.appearance.tintColor = [UIColor orangeColor];
    
}


//设置中间按钮不受TintColor影响
- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    NSArray * items        = self.tabBar.items;
    UITabBarItem * btnAdd  = items[1];//因为只有个3个按钮，中间的index自然是1了
    btnAdd.image           = [btnAdd.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    btnAdd.selectedImage   = [btnAdd.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem * btnAdd1 = items[0];//因为只有个3个按钮，中间的index自然是1了
    btnAdd1.image          = [btnAdd1.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    btnAdd1.selectedImage  = [btnAdd1.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem * btnAdd2 = items[2];//因为只有个3个按钮，中间的index自然是1了
    btnAdd2.image          = [btnAdd2.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    btnAdd2.selectedImage  = [btnAdd2.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


- (UIImage*)createImageWithColor:(UIColor*) color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

- (UIView *)firstView {
    
    if (!_firstView) {
        
        _firstView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 375, self.view.bounds.size.height - 50)];
        _firstView.backgroundColor = [UIColor redColor];
        [self.view addSubview:_firstView];
    }
    
    return _firstView;
}


- (UIView *)secondView {
    
    if (!_secondView) {
        
        _secondView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 375, self.view.bounds.size.height - 50)];
        _secondView.backgroundColor = [UIColor blueColor];
        [self.view addSubview:_secondView];
    }
    
    return _secondView;
}


- (UIView *)thirdView {
    
    if (!_thirdView) {
        
        _thirdView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 375, self.view.bounds.size.height - 50)];
        _thirdView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_thirdView];
    }
    
    return _thirdView;
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    NSLog(@"didSelect");
    
    switch (item.tag) {
            
        case 0:
            self.secondView = nil;
            self.thirdView = nil;
            [self firstView];
            break;
        case 1:
            self.firstView = nil;
            self.thirdView = nil;
            [self secondView];
            break;
        case 2:
            self.secondView = nil;
            self.thirdView = nil;
            [self thirdView];
            break;
        default:
            break;
            
    }
}


#pragma mark -- tabBar控制器
- (void)creatCtrls {
    
    //创建UITabBarController
    _tabBarCtrl = [[UITabBarController alloc] init];
    
    //创建UIViewController对象
    UIViewController *firstController = [[UIViewController alloc] init];
    firstController.view.backgroundColor = [UIColor redColor];
    //设置它的Item
    UITabBarItem *firstItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:0];
    firstController.tabBarItem = firstItem;
    
    UIViewController *secondController = [[UIViewController alloc] init];
    secondController.view.backgroundColor = [UIColor greenColor];
    UITabBarItem *secondItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:1];
    secondController.tabBarItem = secondItem;
    
    UIViewController *thirdController = [[UIViewController alloc] init];
    thirdController.view.backgroundColor = [UIColor grayColor];
    UITabBarItem *thirdItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:2];
    thirdController.tabBarItem = thirdItem;
    
    //设置UIViewController的viewController属性
    _tabBarCtrl.viewControllers = @[firstController,secondController,thirdController];//有几个添加几个
    
    
    //创建程序窗口
    [UIApplication sharedApplication].keyWindow.rootViewController = _tabBarCtrl;
    /*
         [UIApplication sharedApplication] 是单例，所以可以直接替换rootviewcontroller为tabBarCtrl就可以管理多个控制器了
     
     */
    
    _tabBarCtrl.delegate = self;
    
}


/*
 
 UITabBarController类 的方法
 //是否允许切换
 - (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
 return YES;
 }
 
 //当选中某一个item时候调用
 - (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
 NSLog(@"didSelect");
 }
 
 //当more中edit按钮点击时候调用
 - (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers {
 NSLog(@"willBeginCustomizing");
 }
 
 //当more中edit页面开始退出时调用
 - (void)tabBarController:(UITabBarController *)tabBarController willEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
 NSLog(@"willEndCustomizing");
 }
 
 //当more中edit页面退出以后调用
 - (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed{
 NSLog(@"didEndCustomizing");
 }

 
 
 */

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}



@end


/*
 
 A addSubview B  是将B直接覆盖在A的最上层
 A insertSubView B AtIndex:2 是将B插入到A的子视图index为2的位置（最底下是0）
 A insertSubView B aboveSubview:C  是将B插入A并且在A已有的子视图C的上面
 A insertSubView B belowSubview:C  是将B插入A并且在A已有的子视图C的下面
 
 */

