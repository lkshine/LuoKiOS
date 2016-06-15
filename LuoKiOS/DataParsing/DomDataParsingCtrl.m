//
//  DomDataParsingCtrl.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/25.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "DomDataParsingCtrl.h"
#import "GDataXMLNode.h" /* 千万注意只能写在该处，如果写在公共类头文件里的话会，不然会导致2处错误， */


@interface DomDataParsingCtrl ()


@end

/*
    DOM解析需要引入GDataXMLNode类。并为该类配置:
        1. 点开工程-> 选择TARGETS中第一个“A”字图标的（其实是选择对应的项目配置），
            选择 All和Combined -> Build Settings -> 搜索关键词“header search”
            -> 选择Header Search Paths -> 添加文件路径“/usr/include/libxml2”.
        2. 同样 搜索“other link” -> 选择Other Linker Flags -> 添加文件路径“-lxml2”.
        3. 选择 All和Combined -> Build Phases -> Compile Sources -> 为 “GDataXMLNode.m” 类添加 “-fno-objc-arc”
 
    前两个是处理文件链接路径，下面一个是将MRC文件编译到ARC工程中所需的操作。
 

    AFNetWorking使用了ARC ，在不使用ARC项目中使用时，对AFNetWorking的所有.m文件添加“-fobjc-arc”
    在使用ARC项目中，使用“不使用ARC”的类库时，对类库的.m文件添加“-fno-objc-arc”
 */


@implementation DomDataParsingCtrl

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self domParsing];
}


#pragma mark -- DOM解析
- (void)domParsing {
    
    // 读入文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"teacher" ofType:@"xml"];
    
    // 获取文件路径
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSError *error;
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:str options:0 error:&error];
    
    // 第一种方式：获取根节点
    // 不断的找子节点来获取数据
    
    //        GDataXMLElement *rootElement = document.rootElement;
    //        NSLog(@"%@", rootElement);
    //    // 获取子节点
    //        NSArray *array = rootElement.children;
    //        NSLog(@"%@", array[1]);
    //
    //    // 获取子节点的子节点
    //
    //        GDataXMLElement *childElement = array[1];
    //        GDataXMLElement *element = childElement.children[1];
    //        NSLog(@"%@", element);
    //        NSString *sex = element.stringValue;
    //        NSLog(@"%@", sex);
    
    // 第二种方式：使用elementForName：方法，给出一个节点的名字然后获取节点对应的数据
    
    //    GDataXMLElement *rootelement = document.rootElement;
    //    NSArray *arr = [rootelement elementsForName:@"teacher"];
    //    NSLog(@"%@", arr[1]);
    //    GDataXMLElement *element = arr[1];
    //    GDataXMLElement *sex = [element elementsForName:@"sex"][0];
    //    NSLog(@"%@", sex.stringValue);
    
    // 第三种方式，通过绝对路径
    //    NSArray *array = [document nodesForXPath:@"teachers/teacher/sex" error:nil];
    //    NSLog(@"%@", [array[1] stringValue]);
    
    // 第四种方法，通过相对路径
    NSArray *array = [document nodesForXPath:@"//age" error:nil];
    NSLog(@"%@", [array[2] stringValue]);
    
    /* 
        DOM解析的优缺点：优点，一次性读入整个文件，会把文件的树形结构纪录下来，有利于程序员分析数据。
                        XML文件一旦出错，会立即发现错误。缺点，一次性加载整个文件，对内存需求大，
                        同时优点也是缺点，即XML文件出现错误，就无法解析数据。
        原理：遇到开标签入栈，遇到关标签出栈
    */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end



