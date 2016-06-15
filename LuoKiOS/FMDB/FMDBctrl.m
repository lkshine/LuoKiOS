//
//  FMDBctrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/28.
//  Copyright © 2016年 lkshine. All rights reserved.
//


/*
 
 什么是FMDB
 FMDB是iOS平台的SQLite数据库框架
 
 FMDB以OC的方式封装了SQLite的C语言API
 
 为什么使用FMDB
 使用起来更加面向对象，省去了很多麻烦、冗余的C语言代码
 
 对比苹果自带的Core Data框架，更加轻量级和灵活
 
 提供了多线程安全的数据库操作方法，有效地防止数据混乱
 
 */


#import "FMDBctrl.h"

@interface FMDBctrl ()
{
    FMDatabase  * database;
    NSString    * filePath;
    
}


@end



@implementation FMDBctrl

/*
 使用FMDatabaseQueue可以比较有效的解决多线程下对数据库的访问。FMDatabaseQueue解决多线程问题的思路大致是：创建一个队列，然后将需要执行的数据库操作放入block中，队列中的block按照添加进队列的顺序依次执行，实际上还是同步的操作，避免了多个线程同时对数据库的访问。
 
 创建一个全局FMDatabaseQueue 对象，这样做的目的是为了避免发生并发访问数据库的操作，项目开发过程中可以创建一个单例来共享这个FMDatabaseQueue 对象。
 */

//创建一个FMDatabaseQueue队列
static FMDatabaseQueue *queue;

- (void)viewDidLoad {
    
    [super viewDidLoad];
}


#pragma mark -- 使用FMDB
- (void)usdDB {
    
    //获取沙盒路径
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //设置数据库路径
    filePath = [path stringByAppendingPathComponent:@"student.sqlite"];
    //创建FMDatabase对象，参数为SQLite数据库文件路径
    database = [FMDatabase databaseWithPath:filePath];
    
    /*
        数据库文件路径可以是以下三种之一：
        1.具体文件路径。该文件路径如果不存在会自动创建。
        2.空字符串(@””)。表示会在临时目录创建一个空的数据库，当FMDatabase 链接关闭时，文件也会被删除。
        3.NULL。 将创建一个内存中的临时数据库。同样的，当FMDatabase连接关闭时，数据文件会被销毁。
        打开数据库（任何与数据库的交互都必须先打开数据库）
     */
    if ([database open]) {
        //这里写执行操作代码
    } else {
        //数据库打开失败
        return;
    }
    
    
}

#pragma mark -- 创建数据表
//使用FMDB建立数据表的方法十分简单，先创建sql语句，然后调用executeUpdate方法执行操作
- (void)createList {
    
    //创建数据表person(id, name, sex, telephone)
    NSString * createSql = [NSString stringWithFormat:@"create table if not exists person (id integer primary key, name text, sex text, telephone text)"];
    
    //执行更新操作（创建表）
    if (![database executeUpdate:createSql]) {
        
        NSLog(@"create table failed!");
    }
    else {
        
        [self add];
        [self update];
        [self delete];
        [self select];
    }
    
}


#pragma mark -- 添加数据
//在executeUpdate方法后直接加sql语句时要注意数据类型的使用，必须使用OC的对象类型
- (void)add {
    
    //插入一条记录，(1,jack,male,12345678)
    NSString *insertSql = [NSString stringWithFormat:@"insert into person (id, name, sex, telephone) values (%d, '%@', '%@', '%@')", 1, @"jack", @"male", @"12345678"];
    
    //执行更新操作（插入记录）
    if (![database executeUpdate:insertSql]) {
        
        NSLog(@"insert failed!");
    }
    
    //在executeUpdate后面直接加sql语法时，使用?来表示OC中的对象，integer对应NSNumber，text对应NSString，blob对应NSData，数据内部转换FMDB已经完成，只要sql语法正确就没有问题
    if (![database executeUpdate:@"insert into person (id, name, sex, telephone) values (?, ?, ?, ?)", @4, @"gary", @"male", @"99996666"]) {
        
        NSLog(@"insert failed!");
    }
    
}


#pragma mark -- 修改数据
- (void)update {
    
    //更新（修改）一条记录，将id = 1的记录姓名修改为mike
    NSString *updateSql = [NSString stringWithFormat:@"update person set name = '%@' where id = 1", @"mike"];
    
    //执行更新操作
    if (![database executeUpdate:updateSql]) {
        
        NSLog(@"update failed!");
    }
}


#pragma mark -- 删除数据
- (void)delete {
    
    //删除一条记录，从person表中将id= 2的记录删除
    NSString *deleteSql = [NSString stringWithFormat:@"delete from person where id = 2"];
    
    //执行删除操作
    if (![database executeUpdate:deleteSql]) {
        
        NSLog(@"delete failed!");
    }
    
}


#pragma mark -- 查询数据
//FMDB中一切不是SELECT命令的数据库操作都视为更新，使用executeUpdate方法，SELECT命令的数据库操作使用executeQuery方法
- (void)select {
    
    //查询数据库中记录
    NSString * selectSql = [NSString stringWithFormat:@"select * from person"];
    
    //使用executeQuery方法来执行查询语句，使用FMResultSet *来接收查询到的数据
    FMResultSet *rs = [database executeQuery:selectSql];
    
    //[rs next]相当于sqlite3_step语句，用来逐行检索数据表中记录
    while ([rs next]) {
        
        //使用字段位置查询
        NSLog(@"id = %d", [rs intForColumnIndex:0]);
        //使用字段名称查询[rs stringForColumn:@"name"]
        NSLog(@"name = %@", [rs stringForColumn:@"name"]);
        NSLog(@"sex = %@", [rs stringForColumnIndex:2]);
        NSLog(@"telephone = %@", [rs stringForColumnIndex:3]);
    }
    
}


#pragma mark -- FMDatabaseQueue比较有效的解决多线程下对数据库的访问
- (void)createQueue {
    
    //初始化队列
    queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    
    //调用inDatabase方法来将需要执行的操作添加到队列queue中去
    [queue inDatabase:^(FMDatabase *db) {
        //添加需要执行的操作
        [db executeUpdate:@"insert into person (id, name, sex, telephone) values (?, ?, ?, ?)", @100, @"test1", @"male", @"11114321"];
        [db executeUpdate:@"insert into person (id, name, sex, telephone) values (?, ?, ?, ?)", @101, @"test2", @"male", @"22224321"];
        //继续添加想要执行的操作...
    }];
    
    //调用inTransaction方法将需要执行的操作添加到队列中去
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //在事务中添加需要执行的操作，出现异常时及时回滚
        if (![db executeUpdate:@"insert into person (id, name, sex, telephone) values (?, ?, ?, ?)", @104, @"test3", @"male", @"11114321"]) {
            *rollback = YES;
            return ;
        }
        if (![db executeUpdate:@"insert into person (id, name, sex, telephone) values (?, ?, ?, ?)", @105, @"test4", @"male", @"11114321"]) {
            *rollback = YES;
            return ;
        }
    }];
}

/*
 
 总结
 
 FMDatabaseQueue虽然看似一个队列，实际上它本身并不是，它通过内部创建一个Serial的dispatch_queue_t来处理通过inDatabase和inTransaction传入的Blocks，所以当我们在主线程（或者后台）调用inDatabase或者inTransaction时，代码实际上是同步的，这样就避免了多个线程同时访问数据库的问题。如果在后台执行大量的更新操作时，主线程又需要执行少量的数据库操作，那么在后台操作执行完之前，它还是需要等待，这时就会阻塞主线程。
 
 如果在后台使用inDatabase来更新大批量的数据时，可以考虑使用inTransaction，因为后者的更新效率高很多，特别是更新大量操作（如1000条以上）
 如果非必须一次性的、完整性的大批量数据，可以考虑使用数据拆解，将大量数据分成较多批少量的数据，再进行更新操作，这样能有效地避免长时间的阻塞
 如果UI上不需要在更新数据时产生交互，可以将FMDatabaseQueue放入一个子线程中异步执行，这是一个不错的选择
 
 */


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
