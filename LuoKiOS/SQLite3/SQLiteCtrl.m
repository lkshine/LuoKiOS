//
//  SQLiteCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/28.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "SQLiteCtrl.h"

typedef int (*sqlite3_callback)(void* ,int , char**, char**);
//sqlite3_exec执行select语句时需要的回调函数，第一个参数是sqlite3_exec中传入的void *参数，第二个参数是表中的字段个数，第三个参数是字段值，第四个参数是字段名，后两个参数都是字符串数组
int myCallBack(void *para, int column_count, char **column_value, char **column_name) {
    
    for (int i = 0; i < column_count; i++) {
        
        NSLog(@"\n\t🚩\n column_name[i] = %s, column_value[i]= %s \n\t📌", column_name[i], column_value[i]);
    }
    
    return 0;
}


//【格式】typedef 返回值类型 (^newBlockTypeName)(参数列表);
//定义一个有参有返回值的block的别名
typedef int (^myBlock)(int, int);
//此时myBlock是一个类型，不再是一个单纯的变量了
myBlock b1 = ^(int a, int b){
    return a + b;
};



@interface SQLiteCtrl ()
{
    //sqlite3句柄
    sqlite3 *database;
    
    //创建错误信息
    char * err;
}
@end




@implementation SQLiteCtrl

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self showSQL];
    
}


#pragma mark -- 打开或是新建SQL
- (void)showSQL {
    
    //获取沙盒路径
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //获取名字为student的数据库路径
    NSString * dbFile = [path stringByAppendingPathComponent:@"student.sqlite"];
    NSLog(@"\n\t🚩\n dbFile = %@ \n\t📌", dbFile);
    
    //打开数据库，若沙盒中没有此数据库则系统会新建一个
    if (sqlite3_open([dbFile UTF8String], &database) == SQLITE_OK) {
        
        //打开数据库成功
        NSLog(@"open success");
        
        //创建一条sql语句，创建一张名为student的数据表，表中有4个字段，id(整型，主键，自增)，name(字符串类型)，sex(字符串类型)，class(字符串类型)，sql语句编译器不会纠错，一定要仔细填写，sql语句不区分大小写
        const char * createSql = "create table if not exists student (id integer primary key autoincrement, name text, sex text, class text);";
        
//        //创建错误信息
//        char * err;
        
        //执行上面的sql语句
        if (sqlite3_exec(database, createSql, NULL, NULL, &err) != SQLITE_OK) {
            
            //返回值不为0，sql语句执行失败
            NSLog(@"create table failed!");
        }
    }
    else {
        
        //创建或打开数据库失败
        NSLog(@"create/open database failed!");
    }
    
    [self addData];
    [self updata];
    [self select];
    [self biteData];
    
    //如果用 sqlite3_open 开启了一个数据库，结尾时不要忘了用这个函数关闭数据库。
    sqlite3_close(database);
    
    
}

#pragma mark -- 添加数据
/*
 由于sqlite3是由C语言底层实现的，所以sqlite的函数参数必须是C语言数据类型，如果我们使用NSString创建sql语句，我们需要将string类型转换为char *类型之后再作为参数传入sqlite调用的函数中去，这里我们向student表中插入两条记录
 */
- (void)addData {
    
    //创建一条数据库插入语句，向student表中添加一条记录，name为jack，sex为male，class为ios
    const char *insertSql1 = "insert into student(id, name, sex, class) values (1, 'jack', 'male', 'ios')";
    const char *insertSql2 = "insert into student(id, name, sex, class) values (2, 'james', 'male', 'ios')";
    
//    //创建错误信息
//    char * err;
    
    //调用sqlite3_exec函数，传入我们写好的sql语句，返回值是SQLITE_OK时表示操作执行成功，否则失败
    if (sqlite3_exec(database, insertSql1, NULL, NULL, &err) != SQLITE_OK) {
        
        NSLog(@"\n\t🚩\n insert record failed! \n\t📌");
    }
    if (sqlite3_exec(database, insertSql2, NULL, NULL, &err) != SQLITE_OK) {
        
        NSLog(@"\n\t🚩\n insert record failed! \n\t📌");
    }
    
    
}


#pragma mark -- 更新数据
- (void)updata {
    
    //创建数据库更新语句，将student表中id=1的记录的name字段值改为kobe
    const char *updateSql = "update student set name = 'kobe' where id = 1";
    
//    //创建错误信息
//    char * err;
    
    //执行更新操作
    if (sqlite3_exec(database, updateSql, NULL, NULL, &err) != SQLITE_OK) {
        NSLog(@"update record failed!");
    }
    
}


#pragma mark -- 删除数据
- (void)delete {
    
    //创建一条数据库删除语句，删除student表中所有id=1的记录
    const char * deleteSql = "delete from student where id = 1";
    
    //执行删除操作
    if (sqlite3_exec(database, deleteSql, NULL, NULL, &err) != SQLITE_OK) {
        
        NSLog(@"delete row failed!");
    }
    
}


#pragma mark -- 查询数据
- (void)select {
    
    //创建一条数据库查询语句，查询student表中所有数据
    //（查询特定记录时使用select from 表名 where 字段名 = 你想要查询的值）
    const char * selectSql = "select * from student";
    //执行查询操作，将定义好的回调函数myCallBack作为参数传入
    if (sqlite3_exec(database, selectSql, myCallBack, NULL, &err) != SQLITE_OK) {
        
        NSLog(@"select data failed!");
    }
    
}


#pragma mark -- 如果是图片音频那种二进制流的话
- (void)biteData {
    
    //声明 sqlite3_stmt * 类型变量
    sqlite3_stmt *statement;
    
    //（查询特定记录时使用select from 表名 where 字段名 = 你想要查询的值）
    const char * selectSql = "select * from student";
    
    //把一个sql语句解析到statement结构里去，当prepare成功之后(返回值是SQLITE_OK)，开始查询数据
    if (sqlite3_prepare_v2(database, selectSql, -1, &statement, NULL) == SQLITE_OK) {
        
        //sqlite3_step的返回值是SQLITE_ROW 时表示成功（不是SQLITE_OK ）。
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            //使用sqlite3_column函数来返回数据库中查询到记录的各个字段值
            //第一个参数传入sqlite3_stmt *变量，第二个参数表示需要查询第几个字段（从0开始计算）
            NSLog(@"\n\t🚩\n id = %d, name = %s, sex = %s, class = %s \n\t📌", sqlite3_column_int(statement, 0), sqlite3_column_text(statement, 1), sqlite3_column_text(statement, 2), sqlite3_column_text(statement, 3));
        }
    }
    else {
        
        NSLog(@"search data failed!");
    }
    
    //析构上面sqlite3_prepare_v2创建的准备语句
    sqlite3_finalize(statement);
    
}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end


/*
 
 block的定义
 
 
// 声明和实现写在一起，就像变量的声明实现 int a = 10;
    int (^aBlock)(int, int) = ^(int num1, int num2) {

　　    return num1 * num2;

   };
// 声明和实现分开，就像变量先声明后实现 int a;a = 10;
      int (^cBlock)(int,int);
      cBlock = ^(int num1,int num2)
      {
          return num1 * num2;
      };
 
 
 Block的类型与内存管理
 
 根据Block在内存中的位置分为三种类型NSGlobalBlock，NSStackBlock, NSMallocBlock。
 
 http://blog.sina.com.cn/s/blog_8c87ba3b0101m599.html
 
 */




