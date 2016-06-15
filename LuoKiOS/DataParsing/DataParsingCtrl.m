//
//  DataParsingCtrl.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/25.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "DataParsingCtrl.h"

@interface DataParsingCtrl ()

@end




@implementation DataParsingCtrl

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

- (IBAction)saxAction:(UIButton *)sender {
    
    NSLog(@"%s",__func__);
    SaxDataParsingCtrl * sax = [SaxDataParsingCtrl new];
    [self.navigationController pushViewController:sax animated:true];
}

- (IBAction)domAction:(UIButton *)sender {
    
    NSLog(@"%s",__func__);
    DomDataParsingCtrl * dom = [DomDataParsingCtrl new];
    [self.navigationController pushViewController:dom animated:YES];
}

- (IBAction)jsonAction:(UIButton *)sender {
    
    NSLog(@"%s",__func__);
    NetworkProgrammingController * json = [NetworkProgrammingController new];
    [self.navigationController pushViewController:json animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end


