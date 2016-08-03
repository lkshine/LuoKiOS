//
//  TableVC.m
//  LuoKiOS
//
//  Created by lkshine on 16/8/2.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "TableVC.h"
#import "DelegateAndDataSourceManager.h" //代理数据源管理者对象
#import "TableCell.h"



@interface TableVC ()
@property (strong,nonatomic) UITableView * mTableView;
@property (strong,nonatomic) NSArray * mArrayData;
@property (nonatomic, strong) DelegateAndDataSourceManager *dataSource;          // 中间人
@end

@implementation TableVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray * array = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", @"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20"];
    self.mArrayData = array;
    [self setUpTableView];
    NSLog(@"有没有搞错。。。为毛不显示啊");
}
- (void)setUpTableView
{
    UITableView * tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.tableFooterView = [UIView new];
    self.mTableView = tableView;
    self.mTableView.rowHeight = 100;
    TableViewCellConfigureBlock configureBlock = ^(TableCell *cell,NSString * titile){
        [cell configureForData:titile];
    };
    
    __weak typeof (self)weakSelf = self;
    _dataSource = [[DelegateAndDataSourceManager alloc]initWithItems:self.mArrayData cellItentifier:@"ID" configureCellBlock:configureBlock];
    
    _dataSource.cellSelectedBlock = ^(id obj){
        __strong typeof (weakSelf)strongSelf = weakSelf;
        NSIndexPath * index = (NSIndexPath *)obj;
        [strongSelf didSelectAction:index];
    };
    
    //经过两层block，将cell内部控件事件给带回了控制器层
    _dataSource.switchActionBlock = ^(NSIndexPath * indexPath, UISwitch * btn) {
        NSLog(@"vc block row = %ld", (long)indexPath.row);
    };
    _dataSource.btnActionBlock = ^(NSIndexPath * indexPath, UIButton * btn) {
        NSLog(@"vc block row = %ld", (long)indexPath.row);
    };
    
    self.mTableView.dataSource = _dataSource;
    self.mTableView.delegate = _dataSource;
    //    self.mTableView.delegate = self;
    [self.view addSubview:self.mTableView];
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 100;
//}


- (void)didSelectAction:(NSIndexPath * )indexPath {
    
    NSLog(@"didSelectAtion-- index.row = %ld", (long)indexPath.row);
}

@end
