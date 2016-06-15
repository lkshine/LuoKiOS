//
//  SearchBarController.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/19.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "SearchBarController.h"

@interface SearchBarController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UISearchBar    * searchBar;
@property (nonatomic, strong) UITableView    * myTableView;
@property (nonatomic, strong) NSMutableArray * dataList;//原始数据
@property (nonatomic, strong) NSMutableArray * searchList;//显示数据

@end

/*
 
    iOS8之后用UISearchBarController
    http://blog.csdn.net/icetime17/article/details/46883479
 
 */

@implementation SearchBarController

- (UISearchBar *)searchBar {
    
    if (!_searchBar) {
        
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 20+64, wSrceem, 50)];
        
        _searchBar.barStyle = UIBarStyleDefault; //默认风格 白色搜索框，多出的背景为灰色
        _searchBar.searchBarStyle = UISearchBarStyleMinimal; //设置搜索框整体的风格为不显示背景,默认为Prominent显示
        _searchBar.text = @"搜索框"; //设置搜索框的文字
        _searchBar.prompt = @"prompt"; //显示在searchBar顶部的一行文字，基本不会用到
        _searchBar.placeholder = @"站位符"; //当输入框没有内容时候显示的文字
        _searchBar.showsBookmarkButton = YES; //是否在搜索框右侧显示一个图书的按钮，默认为NO，
        _searchBar.showsCancelButton = YES; //是否显示取消按钮，默认为NO;
        // searchBar.showsSearchResultsButton = YES;//是否显示搜索结果按钮，默认为NO,与bookmarkButton只能存在一个
        _searchBar.tintColor = [UIColor yellowColor]; //设置搜索框中的光标的颜色为黄色
        _searchBar.barTintColor = [UIColor redColor]; //设置搜索框的背景颜色
        _searchBar.translucent = NO;//设置是否半透明
        
        
        //searchBar输入框及其输入文字位置的调整
        _searchBar.searchFieldBackgroundPositionAdjustment = UIOffsetMake(20,0); //调整搜索框field的位置，其他searchbar上面其他控件位置不发生改变
        _searchBar.searchTextPositionAdjustment = UIOffsetMake(50, 0); //field里面的文字在field中的位置调整
        
        
        //searchBar特定图标的设置
        [_searchBar setImage:[UIImage imageNamed:@"1"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal]; //自定义搜索框放大镜的图标
        [_searchBar setImage:[UIImage imageNamed:@"1"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal]; //Bookmark图标的设置
        
        self.searchBar.delegate = self;//设置代理
        [self.view addSubview:_searchBar];
    }
    
    return _searchBar;
}


- (UITableView *)myTableView {
    
    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc] init];
        _myTableView.frame = CGRectMake(0, 20+64+50+5, wSrceem, hSrceem-(20+64+50+5));
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.backgroundColor = [UIColor orangeColor];
        
        [self.view addSubview:_myTableView];
    }
    
    return _myTableView;
}

//原始数组
- (NSMutableArray *)dataList {
    
    if (!_dataList) {
        
        _dataList = [NSMutableArray arrayWithCapacity:100];//容量
        for (NSInteger i=0; i<100; i++) {
            [_dataList addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
    }
    
    return _dataList;
}

//要显示在myTableView上面的数组
- (NSMutableArray *)searchList {
    
    if (!_searchList) {
        
        _searchList = [NSMutableArray array];
    }
    
    return _searchList;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self searchBar];
    [self myTableView];
    
}


#pragma mark -- UISearchBarDelegate
//当搜索框将要开始使用时调用。yes表示搜索框可以使用，默认为yes否则搜索框无法使用
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    NSLog(@"ShouldBegin");
    return YES;
}


//当搜索框开始编辑时候调用
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    NSLog(@"DidBegin");
}


//当搜索框将要将要结束使用时调用。
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    NSLog(@"ShouldEnd");
    return YES;
}


//当搜索框结束编辑时候调用
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    NSLog(@"DidEnd");
}


//当field里面内容改变时候就开始调用。
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSLog(@"DidChange");
    
    if (searchText!=nil && searchText.length>0) {
        
        [_searchList removeAllObjects];//清空searchlist里面的数据
        for (NSString *tempStr in self.dataList) {
            
            if ([tempStr rangeOfString:searchText options:NSCaseInsensitiveSearch].length >0 ) {
                
                [self.searchList addObject:tempStr];
                NSLog(@"%ld",[self.searchList count]);
            }
        }
        
        [self.myTableView reloadData];
    }
    else {
        
        self.searchList = [NSMutableArray arrayWithArray:self.dataList];
        [self.myTableView reloadData];
    }
}


//在field里面输入时掉用，询问是否允许输入，yes表示允许，默认为yes，否则无法输入
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"shouldChange");
    return YES;
}

//点击SearchButton调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"SearchButtonClicked");
}

//点击BookmarkButton调用
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"BookmarkButtonClicked");
    
}

//点击CancelButton调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"CancelButton");
}

//点击ResultsListButton调用
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"ResultsListButton");
}


/*
 
 使用代理方法时需要注意以下问题
 
 调用BookmarkButton的点击方法，需要先设置showsBookmarkButton = YES,并且showsSearchResultsButton 不能同时设置为yes，否则不会显示BookmarkButton，导致无法调用方法
 _searchBar.showsBookmarkButton = YES;//是否在搜索框右侧显示一个图书的按钮，默认为NO，
 调用ResultsListButton的点击方法，设置showsSearchResultsButton ＝ YES;
 _searchBar.showsSearchResultsButton = YES;
 
 */


#pragma mark -- UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.searchList count] > 0 ? [self.searchList count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *tableIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    
    if (self.searchList != nil && self.searchList.count > 0) {
        
        NSInteger row = [indexPath row];
        cell.textLabel.text = [self.searchList objectAtIndex:row];
    }
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
