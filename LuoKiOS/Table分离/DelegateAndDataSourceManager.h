//
//  DelegateAndDataSourceManager.h
//  LuoKiOS -- 代理数据源管理者对象
//
//  Created by lkshine on 16/8/2.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TableViewCellConfigureBlock) (id cell,id item);
typedef void(^cellSelectedBlock) (id indexPath);



@interface DelegateAndDataSourceManager : NSObject<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) cellSelectedBlock cellSelectedBlock;
@property (nonatomic, copy) void(^btnActionBlock)(NSIndexPath * indexPath, UIButton * btn);
@property (nonatomic, copy) void(^switchActionBlock)(NSIndexPath * indexPath, UISwitch * btn);



//初始化管理类时需要添加进来些参数，为了直接赋值给那几个方法
- (id)initWithItems:(NSArray *)anItems cellItentifier:(NSString *)aCellIdentifier configureCellBlock:(TableViewCellConfigureBlock)aConofigureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end


