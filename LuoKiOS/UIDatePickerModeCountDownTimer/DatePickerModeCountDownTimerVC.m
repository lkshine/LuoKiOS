//
//  DatePickerModeCountDownTimerVC.m
//  LuoKiOS
//
//  Created by lkshine on 16/7/22.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "DatePickerModeCountDownTimerVC.h"

@interface DatePickerModeCountDownTimerVC ()
@property (strong, nonatomic) UIDatePicker * timePicker;
@end

@implementation DatePickerModeCountDownTimerVC



- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self timePicker];
}

-(UIDatePicker *)timePicker {
    
    if (!_timePicker) {
        //输出所有时间时区格式
        NSLog(@"====%@", [NSLocale availableLocaleIdentifiers]);
        
        //时间选择器
        _timePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, 320, 200)];
        
        // 设置区域为中国简体中文
        _timePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        
        //添加触发事件
        [_timePicker addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
        
        //如果模式是倒计时的话，locale的设置是没用的
        _timePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        
        [self.view addSubview:_timePicker];
    }
    
    return _timePicker;
}

- (void)valueChange:(UIDatePicker *)datePicker {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self changeChinese];
    });
}


#pragma mark -- 修改该模式下的英文显示为指定汉字
- (void)changeChinese {
    
    NSInteger totalSubView = [[_timePicker.subviews[0] subviews] count];
    ((UILabel *)[[_timePicker.subviews[0] subviews] objectAtIndex:(totalSubView-2)]).text = @"lk时";
    ((UILabel *)[[_timePicker.subviews[0] subviews] objectAtIndex:(totalSubView-1)]).text = @"lk分";
}
//其实，不用改，该控件会随着手机系统当前语言而改变

-(void)viewDidAppear:(BOOL)animated {
    
    [self changeChinese];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
