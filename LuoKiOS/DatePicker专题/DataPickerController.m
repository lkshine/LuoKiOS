//
//  DataPickerController.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/20.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "DataPickerController.h"

@interface DataPickerController ()

@property (nonatomic, strong) UIDatePicker * myDatePicker;
@property (nonatomic, strong) UIButton     * btn;

@end



@implementation DataPickerController

- (UIDatePicker *)myDatePicker {
    
    if (!_myDatePicker) {
        
        _myDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 198, 375, 216)];
        _myDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [self.view addSubview:_myDatePicker];
    }
    
    return _myDatePicker;
}


- (UIButton *)btn {
    
    if (!_btn) {
        
        _btn = [[UIButton alloc] initWithFrame:CGRectMake(160, 430, 50, 30)];
        [_btn setTitle:@"确定" forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(pressBtn) forControlEvents:UIControlEventTouchUpInside];
        _btn.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_btn];
    }
    
    return _btn;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self myDatePicker];
    [self btn];
    
}


- (void)pressBtn {
    
    //获取用户通过UIDatePicker设置的日期和时间
    NSDate *selected = [self.myDatePicker date];
    //创建一个日期格式器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm +0800"];
    //使用日期格式器格式化日期和时间
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    NSString *message = [NSString stringWithFormat:@"您选择的日期和时间是: %@",destDateString];
    
    //警告框
    UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"日期和时间" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *myAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [myAlert addAction:myAction];
    [self presentViewController:myAlert animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
