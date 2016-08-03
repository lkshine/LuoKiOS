//
//  Wife+CoreDataProperties.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/29.
//  Copyright © 2016年 lkshine. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Wife+CoreDataProperties.h"

@implementation Wife (CoreDataProperties)

@dynamic name;
@dynamic husband;

@end


/*
 
 @synthesize和@dynamic区别
 在声明property属性后，有2种实现选择
 
 @synthesize
 
 编译器期间，让编译器自动生成getter/setter方法。
 
 当有自定义的存或取方法时，自定义会屏蔽自动生成该方法
 
 
 
 @dynamic
 
 告诉编译器，不自动生成getter/setter方法，避免编译期间产生警告
 
 然后由自己实现存取方法
 
 或存取方法在运行时动态创建绑定：主要使用在CoreData的实现NSManagedObject子类时使用，由Core Data框架在程序运行的时动态生成子类属性
 
 
 ps:http://blog.csdn.net/haishu_zheng/article/details/12873151
 
 
内存管理 ps :http://blog.csdn.net/haishu_zheng/article/details/12872315
 
 */

/*
 http://my.oschina.net/panyong/blog/298631和http://www.jianshu.com/p/d26a7f05515b（runtime）
 我们前面已经讲过一篇runtime 原理，现在这篇文章主要介绍的是runtime是什么以及怎么用！希望对读者有所帮助！
 
 首先，第一个问题， 1》runtime实现的机制是什么,怎么用，一般用于干嘛？ 这个问题我就不跟大家绕弯子了，直接告诉大家， runtime是一套比较底层的纯C语言API, 属于1个C语言库, 包含了很多底层的C语言API。 在我们平时编写的OC代码中, 程序运行过程时, 其实最终都是转成了runtime的C语言代码, runtime算是OC的幕后工作者 比如说，下面一个创建对象的方法中， 举例: OC : [[MJPerson alloc] init] runtime : objc_msgSend(objc_msgSend("MJPerson" , "alloc"), "init")
 
 第二个问题 runtime 用来干什么呢？？用在那些地方呢？怎么用呢？ runtime是属于OC的底层, 可以进行一些非常底层的操作(用OC是无法现实的, 不好实现)
 
 在程序运行过程中, 动态创建一个类(比如KVO的底层实现)
 在程序运行过程中, 动态地为某个类添加属性\方法, 修改属性值\方法
 遍历一个类的所有成员变量(属性)\所有方法 例如：我们需要对一个类的属性进行归档解档的时候属性特别的多，这时候，我们就会写很多对应的代码，但是如果使用了runtime就可以动态设置！ 例如，PYPerson.h的文件如下所示
 
 <!-- lang: cpp -->
 
 import <Foundation/Foundation.h>
 
 @interface PYPerson : NSObject @property (nonatomic, assign) int age; @property (nonatomic, assign) int height; @property (nonatomic, copy) NSString *name; @property (nonatomic, assign) int age2; @property (nonatomic, assign) int height2; @property (nonatomic, assign) int age3; @property (nonatomic, assign) int height3; @property (nonatomic, assign) int age4; @property (nonatomic, assign) int height4;
 
 @end
 
 而PYPerson.m实现文件的内容如下
 
 <!-- lang: cpp -->
 #import "PYPerson.h"
 import <objc/runtime.h>
 
 @implementation PYPerson
 
 (void)encodeWithCoder:(NSCoder )encoder { unsigned int count = 0; Ivar ivars = class_copyIvarList([PYPerson class], &count);
 
 for (int i = 0; i<count; i++) {
 
 // 取出i位置对应的成员变量
 Ivar ivar = ivars[i];
 
 // 查看成员变量
 const char *name = ivar_getName(ivar);
 
 // 归档
 NSString *key = [NSString stringWithUTF8String:name];
 id value = [self valueForKey:key];
 [encoder encodeObject:value forKey:key];
 }
 
 free(ivars); }
 
 (id)initWithCoder:(NSCoder *)decoder { if (self = [super init]) {
 
 unsigned int count = 0;
 Ivar *ivars = class_copyIvarList([PYPerson class], &count);
 
 for (int i = 0; i<count; i++) {
 // 取出i位置对应的成员变量
 Ivar ivar = ivars[i];
 
 // 查看成员变量
 const char *name = ivar_getName(ivar);
 
 // 归档
 NSString *key = [NSString stringWithUTF8String:name];
 id value = [decoder decodeObjectForKey:key];
 
 // 设置到成员变量身上
 [self setValue:value forKey:key];
 }
 
 free(ivars);
 } return self; }
 
 @end
 
 这样我们可以看到归档和解档的案例其实是runtime写下的
 
 学习，runtime机制首先要了解下面几个问题 1相关的头文件和函数 1> 头文件
 
 <objc/runtime.h>
 
 <objc/message.h> 利用头文件，我们可以查看到runtime中的各个方法！
 2> 相关应用
 
 NSCoding(归档和解档, 利用runtime遍历模型对象的所有属性)
 字典 --> 模型 (利用runtime遍历模型对象的所有属性, 根据属性名从字典中取出对应的值, 设置到模型的属性上)
 KVO(利用runtime动态产生一个类)
 用于封装框架(想怎么改就怎么改) 这就是我们runtime机制的只要运用方向
 3> 相关函数
 
 objc_msgSend : 给对象发送消息
 class_copyMethodList : 遍历某个类所有的方法
 class_copyIvarList : 遍历某个类所有的成员变量
 class_..... 这是我们学习runtime必须知道的函数！
 4.必备常识 1> Ivar : 成员变量 2> Method : 成员方法 从上面例子中我们看到我们定义的成员变量，如果要是动态创建方法，可以使用Method，
 
 
 
 */

