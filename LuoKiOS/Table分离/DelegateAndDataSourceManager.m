//
//  DelegateAndDataSourceManager.m
//  LuoKiOS
//
//  Created by lkshine on 16/8/2.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "DelegateAndDataSourceManager.h"
#import "TableCell.h"



@interface DelegateAndDataSourceManager()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;

@end


@implementation DelegateAndDataSourceManager

- (id)init {
    
    return nil;
}


- (id)initWithItems:(NSArray *)anItems cellItentifier:(NSString *)aCellIdentifier configureCellBlock:(TableViewCellConfigureBlock)aConofigureCellBlock {
    
    self = [super init];
    
    if (self) {
        
        self.items = anItems;
        self.cellIdentifier = aCellIdentifier;
        self.configureCellBlock = [aConofigureCellBlock copy];
    }
    return self;
}

-(id)itemAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.items[(NSUInteger)indexPath.row];
}


#pragma mark UITableViewDelegate&&DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableCell * cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    
    if (cell== nil) {
        
        cell = [[TableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
    }
    id  item = [self itemAtIndexPath:indexPath]; //标题数据
    self.configureCellBlock(cell,item);
    
    cell.indexPath = indexPath; //千万别忽略了这里，block调用时最为关键点,再这里赋值给cell里的indexPath，才能回调时，让indexPath有值
    
    __weak typeof (self)weakSelf = self;
    
    //中转层block带block时，记得weak和strong化self的循环引用与持有
    cell.cellSwitchActionBlock = ^(NSIndexPath * indexPath, UISwitch * switchBtn) {
        
        __strong typeof (weakSelf)strongSelf = weakSelf;
        strongSelf.switchActionBlock(indexPath, switchBtn);
    };
    
    cell.cellBtnActionBlock = ^(NSIndexPath *indexPath, UIButton * btn) {
        
        __strong typeof (weakSelf)strongSelf = weakSelf;
        strongSelf.btnActionBlock(indexPath, btn);
    };
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.cellSelectedBlock(indexPath);
}



@end


