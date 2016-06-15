//
//  SaxDataParsingCtrl.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/25.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "SaxDataParsingCtrl.h"


@interface SaxDataParsingCtrl ()<NSXMLParserDelegate>

@end

/*
    注意：sax解析是系统提供的一套解析方案，
         sax解析的优点：逐行解析，不会一次性读入整个文件，减小内存消耗。
                        因为是逐行解析，xml文件损坏对解析没影响；
         sax解析的缺点：因为是逐行解析，所以没办法获取文件的层级关系，
                        对于程序员获取数据而言比较麻烦。
 */

@implementation SaxDataParsingCtrl

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self saxParsing];
    
}

#pragma mark -- Sax解析
- (void)saxParsing {
    
    // 读入文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"teacher" ofType:@"xml"];
    
    // NSXMLParser对象
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:path]];
    
    // 设置delegate对象（解析过程放在代理中执行）
    parser.delegate = self;
    
    // 执行解析
    [parser parse];
    
}

#pragma mark -- NSXMLParserDelegate
// 开始标签
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    NSLog(@"%@", elementName);
}

// 结束标签
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    NSLog(@"%@", elementName);
}

// 取值
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    NSLog(@"%@", string);
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end





