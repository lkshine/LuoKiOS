//
//  TextFieldController.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/19.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "TextFieldController.h"



@interface TextFieldController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UILabel     * label;


@end



@implementation TextFieldController

- (UITextField * )textField {
    
    if (!_textField) {
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 100, 100, 30)];
        _textField.backgroundColor = [UIColor redColor];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.placeholder = @"史上最帅的程序员";
        _textField.textAlignment = NSTextAlignmentCenter;
        
        //首字母是否大写
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //return键变成什么键
        _textField.returnKeyType =UIReturnKeyDone;
        
        _textField.delegate = self;  // 设置代理对象
        [self.view addSubview:_textField];
        
    }
    
    return _textField;
}

- (UILabel *)label {
    
    if (!_label) {
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(50, 200, 100, 30)];
        [self.view addSubview:_label];
    }
    
    return _label;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self textField];
    
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
//    [textField resignFirstResponder];  // 取消第一响应者键盘收起来了
    //或者如下
    [textField endEditing:YES];  // 这个就直白多了，结束编辑
    return YES;
}

// 限制字数 ,在对输入框进行任意的增删改操作时，这个代理方法都会记录下修改位置，以及修改的字符。
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSLog(@"%@ %@", NSStringFromRange(range), string);
    if(range.location - range.length >=10)
    {
        self.label.text = @"字数超出限制";
        self.label.textColor = [UIColor redColor];
    }else
    {
        self.label.text = @"未超出限制";
        self.label.textColor = [UIColor greenColor];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}



@end




