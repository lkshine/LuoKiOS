//
//  NotificationVC.m
//  LuoKiOS
//
//  Created by lkshine on 16/7/23.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "NotificationVC.h"
#import "LKObjcet.h"

@interface NotificationVC () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField * textField;

@end



@implementation NotificationVC

- (UITextField *)textField {
    
    if (!_textField) {
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(30, 90, 200, 50)];
        _textField.backgroundColor = [UIColor cyanColor];
        _textField.delegate = self;
        [self.view addSubview:_textField];
        
        //发起注册
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tfBeginEditing) name:@"tfBeginEditing" object:nil];
        
        //发起注册
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tfChangeCharacters) name:@"tfChangeCharacters" object:nil];
        
        
        LKObjcet * obj = [LKObjcet new];
        [[NSNotificationCenter defaultCenter] addObserver:obj selector:@selector(receiveNotification:) name:@"oppo" object:nil];
    }
    
    return _textField;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self textField];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    //注销通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)tfBeginEditing {
    
    NSLog(@"NotificationVC === %s", __func__);
}


- (void)tfChangeCharacters {
    
    NSLog(@"NotificationVC === %s", __func__);
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tfBeginEditing" object:nil userInfo:nil];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"tfChangeCharacters" object:nil userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"oppo" object:nil];
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end


