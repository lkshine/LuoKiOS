//
//  TextViewController.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/19.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "TextViewController.h"


@interface TextViewController () <UITextViewDelegate>

@property (strong, nonatomic) UITextView *textView;

@end



@implementation TextViewController


- (UITextView *)textView {
    
    if (!_textView) {
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(50, 50, 100, 50) textContainer:nil];
        _textView.backgroundColor = [UIColor lightGrayColor];
        
        [self.view addSubview:_textView];
        
        //    _textView.autoresizingMask = YES; // 自适应高度
    }
    
    return _textView;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self textView];

}


#pragma mark -- UITextViewDelegate
// UITextView的代理方法
// 下面四个代理方法参考UITextField的教程。
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {

    NSLog(@"%s",__func__);
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {

    NSLog(@"%s",__func__);
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {

    NSLog(@"%s",__func__);
}

- (void)textViewDidEndEditing:(UITextView *)textView {

    NSLog(@"%s",__func__);
}


// 告诉代理，某个textView的文本将要被修改。返回YES允许修改，NO不允许。
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSLog(@"%s",__func__);
    return YES;
}


// 告诉代理，textView的文本或文本属性已经被用户修改了。
- (void)textViewDidChange:(UITextView *)textView {
    
    NSLog(@"%s",__func__);
}

// 告诉代理，指定文本段已被修改。并且可以通过textView的selectedRange属性获取到修改范围。
- (void)textViewDidChangeSelection:(UITextView *)textView {
    
    NSLog(@"%s",__func__);
}


// 询问代理，是否允许用户可以对文本内的URL做出请求交互。返回YES允许，NO不允许。
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    NSLog(@"%s",__func__);
    return YES;
}


// 询问代理，是否允许用户对范围内文本的附属内容做出相应交互。YES允许，NO不允许
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    
    NSLog(@"%s",__func__);
    return YES;
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end
