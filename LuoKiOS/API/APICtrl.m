//
//  APICtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/26.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "APICtrl.h"
#import "ParamsData.h"
#import "JsonData.h"
#import "XmlData.h"

#define BaiduAPI_Key   @"b3e67c1aa92b533b4596d7a3b7356d8f"

@interface APICtrl () <DataDelegate>

@property (nonatomic, strong) NSArray    * myArray;//用来存放JSON数据的数组
@property (nonatomic, strong) ParamsData * myData;
@property (nonatomic, strong) JsonData   * jsonData;
@property (nonatomic, strong) XmlData    * xmlData;

@end





@implementation APICtrl

#pragma mark -- 在这个模型里，我特地设置了delegate，block，属性三种回传的方式
- (ParamsData *)myData {
    
    if (!_myData) {
        
        _myData = [[ParamsData alloc] init];
        _myData.delegate = self;    //delegate成功
        
        [_myData getdata];
        NSLog(@"property_dic = %@", _myData.dic);   //属性失败
        _myData.dataBlock = ^(NSMutableDictionary *dic){    //block回传成功
        
            NSLog(@"\n\t🚩\n block_dic = %@ \n\t📌", dic);
        };
    }
    
    return _myData;
}

- (JsonData *)jsonData {
    
    if (!_jsonData) {
        
        _jsonData = [[JsonData alloc] init];
        _jsonData.delegate = self;
        [_jsonData getData];
    }
    
    return _jsonData;
}

- (XmlData *)xmlData {
    
    if (!_xmlData) {
        
        _xmlData = [[XmlData alloc] init];
//        _xmlData.delegate = self;
        [_xmlData getData];
    }
    
    return _xmlData;
}



- (NSArray *)myArray {
    
    if (!_myArray) {
        
        _myArray = [[NSArray alloc ] init];
    }
    
    return _myArray;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self myArray];
    [self myData];
//    [self jsonData];
//    [self xmlData];

}


#pragma mark -- DataDelegate
- (void)data:(NSMutableDictionary *)dic {
    
    
    NSLog(@"delegate_dic = %@", dic);
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

@end
