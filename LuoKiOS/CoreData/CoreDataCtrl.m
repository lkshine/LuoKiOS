//
//  CoreDataCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/29.
//  Copyright © 2016年 lkshine. All rights reserved.
//



/*
 
CoreData中的关键类

    NSManagedObjectModel(被管理的对象模型)
    数据库所有表格或数据结构，包含各实体的定义信息

    作用：添加实体的属性，建立属性之间的关系

    操作方法：视图编辑器，或代码

    NSManagedObjectContext(被管理的对象上下文)
    操作实际内容（操作持久层）

    作用：插入，更新，查询，删除数据

    NSManagedObject（被管理的数据对象）
    相当于数据库中的一条记录

    NSPersistentStoreCoordinator(持久化存储协调器)
    相当于数据库的连接器

    作用：设置数据存储的名字，位置，存储方式，和存储时机

    NSFetchRequest(获取数据的请求)
    相当于数据库的查询语句

    NSPredicate(谓词)
    查询数据的过滤条件

    NSEntityDescription(实体描述)
    对实体结构的描述
 
 */



#import "CoreDataCtrl.h"
#import <CoreData/CoreData.h>
#import "Wife.h"


@interface CoreDataCtrl ()


@end

/*
 添加CoreData框架，并在合适的地方引入头文件<CoreData/CoreData.h>

 打印隐藏的SQL语句
 
 在Edit Scheme中选择Run，之后进入Arguments标签，添加参数：“-com.apple.CoreData.SQLDebug 1”


 */

@implementation CoreDataCtrl

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self useCoreData];
    
}

/*
 http://www.jianshu.com/p/6e874cd2b133
 http://www.2cto.com/kf/201508/434028.html
 http://blog.csdn.net/ruglcc/article/details/50557344
 
 MagicRecord，是对CoreData的深度封装：（必读，尤其结尾的两个链接内容）http://www.jianshu.com/p/07cd30f2d1e1
 
 
 */

#pragma mark -- 设置上下文
- (void)useCoreData {
    
    /***************设置上下文******************/
    
    // 从应用程序包中加载模型文件
    NSManagedObjectModel * model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // 传入模型对象，初始化NSPersistentStoreCoordinator
    NSPersistentStoreCoordinator * psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    // 构建SQLite数据库文件的路径
    NSString * filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"LKCoreData.data"];
    
    // 将数据库路径转成URL
    NSURL * url = [NSURL fileURLWithPath:filePath];
    
    // 添加持久化存储库，这里使用SQLite作为存储库
    NSError * error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    
    // 判断数据库是否添加成功
    if (store == nil) {
        
        [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
    }
    
    // 初始化上下文
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    // 设置persistentStoreCoordinator属性
    context.persistentStoreCoordinator = psc;
    
    
    
    /****************************插入记录*******************************/
    
    /*
     // 创建一个Husband实体对象，传入上下文
     NSManagedObject *husband = [NSEntityDescription insertNewObjectForEntityForName:@"Husband" inManagedObjectContext:context];
     
     // 通过键值编码的方式设置Husband的name属性
     [husband setValue:@"jack2" forKey:@"name"];
     
     // 通过coredata生成的实体类来创建一个Wife实体对象，传入上下文
     Wife *wife = [NSEntityDescription insertNewObjectForEntityForName:@"Wife" inManagedObjectContext:context];
     
     // 通过setter方法设置属性
     wife.name = @"rose2";
     
     // 设置Husband和Wife之间的关联关系（一方关联，另一方自动关联）
     wife.husband = husband;
     
     // 利用上下文对象，将数据同步到持久化存储库
     BOOL success = [context save:&error];
     if (!success) {
     
        [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
     }
     
     // 如果是想做更新操作：需要将实体对象先查询出来，在更改了实体对象的属性后调用[context save:&error]，就能将更改的数据同步到数据库
     
     */
    
    
    
    /********************************查询操作***************************/
    
    /*
     // 初始化一个查询请求
     NSFetchRequest *request = [[NSFetchRequest alloc] init];
     
     // 设置要查询的实体
     request.entity = [NSEntityDescription entityForName:@"Husband" inManagedObjectContext:context];
     
     // 设置排序（按照name降序）
     NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];
     request.sortDescriptors = [NSArray arrayWithObject:sort];
     
     // 设置条件过滤(搜索name中包含字符串"ja"的记录)
     NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name like %@", @"*ja*"];
     request.predicate = predicate;
     
     // 执行请求,返回一个数组
     NSArray * objs = [context executeFetchRequest:request error:&error];
     
     if (error) {
     
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
     }
     
     // 遍历数据
     for (NSManagedObject *obj in objs) {
     
        NSLog(@"name=%@", [obj valueForKey:@"name"]);
        // 实体属性中包含另一个实体，不需要再次设置查询请求，Core Data会根据关联关系查询到关联的实体信息
        NSLog(@"wife = %@", [[obj valueForKey:@"wife"] valueForKey:@"name"]);
     }
     
     */
    
    
    /******************************删除操作**********************************/
    
    // 初始化一个查询请求
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    
    // 设置要查询的实体
    request.entity = [NSEntityDescription entityForName:@"Husband" inManagedObjectContext:context];
    
    // 设置条件过滤(搜索name等于jack2的实体)
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name == %@", @"jack2"];
    request.predicate = predicate;
    
    // 执行请求,返回一个数组
    NSArray * objs = [context executeFetchRequest:request error:&error];
    
    if (error) {
        
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    
    // 遍历数据
    for (NSManagedObject * obj in objs) {
        
        // 传入需要删除的实体对象
        [context deleteObject:obj];
        // 将结果同步到数据库
        [context save:&error];
        
        if (error) {
            
            [NSException raise:@"删除错误" format:@"%@", [error localizedDescription]];
        }
    }
    
    // 打印操作结果
    request.predicate = nil;
    objs = [context executeFetchRequest:request error:&error];
    
    if (error) {
        
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    for (NSManagedObject *obj in objs) {
        
        NSLog(@"name=%@", [obj valueForKey:@"name"]);
        // 实体属性中包含另一个实体，不需要再次设置查询请求，Core Data会根据关联关系查询到关联的实体信息
        NSLog(@"wife = %@", [[obj valueForKey:@"wife"] valueForKey:@"name"]);
    }
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

@end



