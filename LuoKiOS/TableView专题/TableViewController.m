//
//  TableViewController.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/15.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "TableViewController.h"

#define kSectionCount 4

@interface TableViewController ()

@property (nonatomic, strong) NSMutableArray * dataList;

@end

@implementation TableViewController


- (NSMutableArray *)dataList {
    
    if (!_dataList) {
        
        _dataList = [NSMutableArray new];
        for (int i = 0; i < kSectionCount; i++) {
            
            NumberGroup * numberGroup = [NumberGroup numberGroup];
            [_dataList addObject:numberGroup];
            NSLog(@"\n\t🚩\n Data_numberGroup = %@ \n\t📌", numberGroup);
        }
    }
    
    return _dataList;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    // AMScrollingNavbar 使用 https://github.com/andreamazz/AMScrollingNavbar/tree/v1.x
    [self setUseSuperview:NO];  //UIViewController的子类使用时要添加该段代码
    [self followScrollView:self.tableView]; //设置控件滑动事件（有约束版和非约束版，参考git上使用教程）
    //    [self.navigationController.navigationBar setTranslucent:NO]; //不允许导航栏透明
    
    
    
    //1,在viewDidLoad， http://www.jb51.net/article/82325.htm
//    if([self.tableView respondsToSelector:@selector(setLayoutMargins:)]){
//        self.tableView.layoutMargins = UIEdgeInsetsZero;
//    }
//    if([self.tableView respondsToSelector:@selector(setSeparatorInset:)]){
//        self.tableView.separatorInset = UIEdgeInsetsZero;
//    }
    
    // self默认的会在viewWillAppear的时候，清空所有选中cell，下面设置则是来禁用该功能
    self.clearsSelectionOnViewWillAppear = NO;
    
    //下面两行代码是让右竖滑动条显示并闪烁一下提醒用户可滑动操作，不过现在默认不设置也如此了，如果有索引将会被遮挡不显示
//    [self.tableView flashScrollIndicators];
//    self.tableView.showsVerticalScrollIndicator = YES;
    
    //cell的移动，要么设置editing属性，要么玩个系统自带的按钮
//    self.navigationItem.rightBarButtonItem = self.editButtonItem; //右上角显示一个编辑move cell功能按钮
    
//    self.tableView.editing = YES; //or
    [self.tableView setEditing:YES animated:YES];

    
    
    //添加索引后，索引会承包那个区域，会遮挡住列表，所以需要将索引栏背景设置为透明
    self.tableView.sectionIndexColor = [UIColor redColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    // PS: 索引最常见的莫过于通讯录或是城市列表了
    
    
    
    //self sizing技术
//    self.tableView.estimatedRowHeight = 67;   //假设高度值
//    self.tableView.rowHeight = UITableViewAutomaticDimension;  //自动自适应变高
    
//    self.tableView.rowHeight = 80;   //统一设置行高
    
    /* 这里有个问题，代码计算字高度的时候，最后一点不能显示为一整行的字全部变成...了，不知道是为啥，而不能像self sizing那样显示全 */
    
    
    // 表头表尾设置
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    self.tableView.tableHeaderView = searchBar;
    
    //设置footerview
    /*
     当Cell的数量不够覆盖整个屏幕的时候，系统默认情况下，会自动添加一些分割线，而有时我们并不希望显示这些分割线，因此可以利用FooterView来去除这些分割线
     
     */
//    UIView *view = [UIView new];
//    view.backgroundColor = [UIColor clearColor];
//    self.tableView.tableFooterView = view;
    
    //or
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self refreshTable];

}


- (void)refreshTable {
    
    //导入#import "MJRefresh.h"，然后三个方法就OK应用了
    // 上啦下拉刷新加载
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadNewData];
            
        });
    }];
    
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    // 设置了底部inset
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    // 忽略掉底部inset
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = 30;

}

#pragma mark -- refreshTabelAction自定义方法
- (void)loadNewData {
    
    [self.tableView reloadData];
    
    [self.tableView.mj_header endRefreshing];
}

- (void)loadMoreData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        [self.tableView reloadData];
        
        [self.tableView.mj_footer endRefreshing];
    });
}


#pragma mark -- 单独定制行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //取出数据对象
    NumberGroup * group = self.dataList[indexPath.section];
    Number * number = group.groupNumbers[indexPath.row];
    
    NSLog(@"\n\t🚩\n Cell_Height_NumberGroup = %@ \n\t📌", group);
    
    return number.cellLabelHeight;  //ps: 不管是代码自动计算高度，还是self sizing技术，一定要在会变化的控件设置autorelazy自动布局限制底部的约束了
}

#pragma mark - customSection
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataList.count;//kSectionCount;
}


//设置header文字
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NumberGroup  *tempGroup = self.dataList[section];
    return tempGroup.groupHeader;
    
}

//设置footer文字
- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    NumberGroup  *tempGroup = self.dataList[section];
    return tempGroup.groupFooter;
    
}

// 定制section header样式
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    imageView.image = [UIImage imageNamed:@"0"];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, 100, 20)];
    label.text = @"guess your favour";
    label.font = [UIFont systemFontOfSize:10];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(250, 5, 60, 20);
    [button setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickOpenButton) forControlEvents:UIControlEventTouchUpInside    ];
    
    UIView * headerView = [UIView new];
    headerView.backgroundColor = [UIColor orangeColor];
    [headerView addSubview:imageView];
    [headerView addSubview:label];
    [headerView addSubview:button];
    
    return headerView;
    
}

- (void)clickOpenButton {
    
    NSLog(@"%s", __func__);
}

// 定制section footer样式
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView * view = nil;
    return view;
}


#pragma mark -- dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    //取出二维对象对应的section
    NumberGroup * tempGroup = self.dataList[section];
    return tempGroup.groupNumbers.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    static NSString *cellID = @"cell"; //保证唯一性
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];//从缓存池中获取cell
//    
//    if (cell == nil) {//如果缓存池中没有标识为CELLID的单元格，则创建
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
//    }
//    
//    //获取数据源
//    NumberGroup * tempGroup = self.dataList[indexPath.section];
//    NSString * numberString = tempGroup.groupNumbers[indexPath.row];
//    
//    //设置cell内容
//    cell.textLabel.text = numberString;
//    cell.detailTextLabel.text = numberString;
//    cell.imageView.image = [UIImage imageNamed:@"greenChat"];
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    // 初始化
    MyCell * cell = [MyCell myCellWithTableView:tableView];
    
    //从模型中取出数据
    NumberGroup * tempGroup = self.dataList[indexPath.section];
    NSString * numberString = tempGroup.groupNumbers[indexPath.row];
    
    //传数据给view
    cell.cellData = (Number*)numberString;
    NSLog(@"\n\t🚩\n Cell_Number = %@ \n\t📌", numberString);
   
    //2.在cellForRowAtIndexPath，添加后，tableview.separator将会对索引栏影响
//    if([cell respondsToSelector:@selector(setLayoutMargins:)]){
//        cell.layoutMargins = UIEdgeInsetsZero;
//    }
//    if([self.tableView respondsToSelector:@selector(setSeparatorInset:)]){
//        cell.separatorInset = UIEdgeInsetsZero;
//    }
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.row%2) return NO;
//    else
        return YES;
    
}


#pragma mark - 单元格移动

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath  {
     
     return YES;
 }

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSLog(@"%s",__func__);
    //取出Cell的数据源
    NumberGroup *sourceGroup = self.dataList[sourceIndexPath.section];
    //取出对应的Cell
    Number *sourceNumber = sourceGroup.groupNumbers[sourceIndexPath.row];
    //删除cell对应的数据源
    [sourceGroup.groupNumbers removeObjectAtIndex:sourceIndexPath.row];
    //取出新Group
    NumberGroup *descGroup = self.dataList[destinationIndexPath.section];
    //插入新位置
    [descGroup.groupNumbers insertObject:sourceNumber atIndex:destinationIndexPath.row];
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
}

- (nullable NSArray <UITableViewRowAction *>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction * action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"action1" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [tableView reloadData];
    }];

    UITableViewRowAction * action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"action2" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {

        [self.dataList removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }];
    
    NSArray * actionArray = @[action1, action2];
    
    return actionArray;
}

//开始编辑前调用
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%s", __func__);
}

//完成编辑调用
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%s", __func__);
}


#pragma mark -- 索引
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    NSMutableArray * indexArray = [NSMutableArray new];
    
    for (NumberGroup * numberGroup in self.dataList) {
        
        [indexArray addObject:numberGroup.groupIndex];
    }
    
    return indexArray;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    LKViewController *detailViewController = [[LKViewController alloc] initWithNibName:@"LKViewController" bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
}


@end



/*
 
 一般调试基本就是下全局断点，查看到底是哪步出的错，就是xcode最左下角“+“点击后选择第二个Add Symbolic Breakpoint...就可以了
 
 http://blog.csdn.net/liuyu832/article/details/24646863
 
 */
