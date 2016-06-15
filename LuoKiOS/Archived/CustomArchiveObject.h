//
//  CustomArchiveObject.h
//  LuoKiOS
//
//  Created by lkshine on 16/5/28.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 自定义的对象归档需要实现NSCoding协议，并且实现协议中的方法，继承时必须先调用父类的归档解档方法，使用时可以直接调用普通Foundation框架中对象归档解档方法
 在项目中新建一个Person类，设置三个属性，遵守NSCoding协议并实现协议中的方法：
 */
@interface CustomArchiveObject : NSObject <NSCoding>

@property (copy,   nonatomic) NSString * name;
@property (copy,   nonatomic) NSString * gender;
@property (assign, nonatomic) int        age;

@end


/*
 
 
 //http://blog.sina.com.cn/s/blog_6dce99b10101jv12.html

 
 到目前为止，看到oc实现的序列化方式有两种：NSKeyedArchiver，NSPropertyListSerialization。
 
 在这两种序列化方式中，NSData都是序列化的目标。两种方式的不同点在于NSPropertyListSerialization只是针对字典类型的，而NSKeyedArchiver是针对对象的。（补充一下，在Mac OS环境下，还可以使用NSArchiver获得更加精简的二进制序列化内容，但是NSArchiver在iOS环境下不支持）。
 
 */