//
//  NavCtrl.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/20.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "NavCtrl.h"
#import "TempViewController.h"



@interface NavCtrl ()

@property (nonatomic, strong) TempViewController * tvc;
@property(nullable, nonatomic,strong) UIView          *titleView; //中间视图
@property(nullable, nonatomic,strong) UIBarButtonItem *leftBarButtonItem;//左侧按钮
@property(nullable, nonatomic,strong) UIBarButtonItem *rightBarButtonItem;//右侧按钮
@property(nullable,nonatomic,copy) NSArray <UIBarButtonItem *> *leftBarButtonItems ;//左侧安放多个按钮
@property(nullable,nonatomic,copy) NSArray <UIBarButtonItem *> *rightBarButtonItems ;//右侧安放多个按钮

@end




@implementation NavCtrl

- (TempViewController *)tvc {
    
    if (!_tvc) {
        
        _tvc = [TempViewController new];
        
    }
    
    return _tvc;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self navStart];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


- (IBAction)pushAction:(UIButton *)sender {
    
    [self.navigationController pushViewController:self.tvc animated:YES];
    
}

- (IBAction)toolBarAction:(UIButton *)sender {
    
    if (self.navigationController.isToolbarHidden) {
        
        self.navigationController.toolbarHidden = NO;
//        self.navigationController.toolbar.backgroundColor = [UIColor orangeColor];
        self.navigationController.toolbar.barTintColor = [UIColor orangeColor];
//        [self.navigationController.toolbar setBackgroundImage:[UIImage imageNamed:@"greenNav" ]forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
        
        //navi Item 属性
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"点我" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBtn)];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"zhu"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBtn)];
        
        NSArray * arr = [[NSArray alloc]initWithObjects:leftBarButtonItem, rightBarButtonItem, nil];
        
        
        self.navigationController.toolbarItems = arr;//@[leftBarButtonItem, rightBarButtonItem];
    }
    else {
      
        self.navigationController.toolbarHidden = YES;
     }
}

- (void)navStart {
    
//    self.navigationController.navigationBar.backgroundColor = [UIColor greenColor];//导航栏背景颜色, 但是这个方法设置的话，会感觉有种磨砂特效的感觉

    // navi Bar 属性
    self.navigationController.navigationBar.barTintColor = [UIColor greenColor];//导航栏背景颜色
    self.navigationController.navigationBar.tintColor = [UIColor redColor];//导航栏背景颜色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;//导航栏样式
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"blackNav"]forBarMetrics:UIBarMetricsDefault];//设置导航栏背景图片
    
    
    //navi Item 属性
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"点我" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBtn)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"zhu"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBtn)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, 100, 100)];
    titleView.backgroundColor = [UIColor greenColor];
    self.navigationItem.titleView = titleView;
    
    self.navigationController.navigationItem.title = @"gg";
    self.navigationController.navigationItem.prompt = @"bb";
    
    
    /*
   
   不论使用StoryBoard还是代码创建导航控制器，核心有两个步骤：
   
   实例化一个UINavigationController对象
   指定该导航控制器对象的rootViewcontroller
   
   
   在AppDelegate里
   
    - (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
        FirstViewController *viewController = [[FirstViewController alloc]
                                               initWithNibName:nil
                                               bundle:nil];
        self.navigationController = [[UINavigationController alloc]
                                     initWithRootViewController:viewController];
        self.window = [[UIWindow alloc]
                       initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = self.navigationController;
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        return YES;
    }
    
    */
    
}


- (void)clickLeftBtn {
    
    NSLog(@"%s",__func__);
}


- (void)clickRightBtn {
    
    NSLog(@"%s",__func__);
}

@end
