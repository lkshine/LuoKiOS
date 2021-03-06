//
//  FrontCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/6/2.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "FrontCtrl.h"
#import "HATestView.h"                      //仿照网易新闻栏【没做完】
#import "AdvertiseVC.h"         //启动广告控制器



@interface FrontCtrl ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray * titles;
@property (nonatomic, strong) NSMutableArray * pageViews;

@end

@implementation FrontCtrl

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    //侧滑菜单交互设置
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    
    // presentView:为执行界面跳转的方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentView:) name:@"presentView" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAd) name:@"pushtoad" object:nil];
    
}

- (void)pushToAd {
    
    AdvertiseVC * adVc = [[AdvertiseVC alloc] init];
    [self.navigationController pushViewController:adVc animated:YES];
    
}

- (void)initNetEaseMenu {
    
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    
    //不允许有重复的标题
    self.titles = @[@"网易",@"新浪",@"腾讯",@"苹果",@"搜狐",@"淘宝",@"京东",@"百度",@"有道",@"小米",@"华为",@"三星"];
    
    HACursor *cursor = [[HACursor alloc]init];
    cursor.frame = CGRectMake(0, 64, self.view.width, 45);
    cursor.titles = self.titles;
    cursor.pageViews = [self createPageViews];
    //设置根滚动视图的高度
    cursor.rootScrollViewHeight = self.view.frame.size.height -109;
    //默认值是白色
    cursor.titleNormalColor = [UIColor whiteColor];
    //默认值是白色
    cursor.titleSelectedColor = [UIColor redColor];
    //是否显示排序按钮
    cursor.showSortbutton = YES;
    //默认的最小值是5，小于默认值的话按默认值设置
    cursor.minFontSize = 11;
    //默认的最大值是25，小于默认值的话按默认值设置，大于默认值按设置的值处理
    //cursor.maxFontSize = 30;
    //cursor.isGraduallyChangFont = NO;
    //在isGraduallyChangFont为NO的时候，isGraduallyChangColor不会有效果
    //cursor.isGraduallyChangColor = NO;
    [self.view addSubview:cursor];
    
}

- (NSMutableArray *)createPageViews{
    NSMutableArray *pageViews = [NSMutableArray array];
    for (NSInteger i = 0; i < self.titles.count; i++) {
        if(i % 3 == 0){
            UITableView *textView = [[UITableView alloc]init];
            textView.delegate = self;
            textView.dataSource = self;
            textView.tag = i;
            [pageViews addObject:textView];
        }else{
            HATestView *textView = [[HATestView alloc]init];
            //textView.tag = i;
            textView.label.text = self.titles[i];
            [pageViews addObject:textView];
        }
        
    }
    return pageViews;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Cell - %@",self.titles[tableView.tag]];
    return cell;
}



#pragma mark -- 本地推送打开后跳转到其他页面
- (void)presentView:(NSNotification *)notifition {
    
    SysSchemesCtrl * viewController = [[SysSchemesCtrl alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end



