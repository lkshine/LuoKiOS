//
//  CustomTouchView.h
//  iOS知识点总结项目--自定义交互UIView类
//
//  Created by lkshine on 16/5/11.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTouchView : UIView

@property (nonatomic,strong) UIView * subView;


//- (void)touchesBegan:(NSSet *)touches withEvent:(nullable UIEvent *)event; //点击了视图
//- (void)touchesMoved:(NSSet *)touches withEvent:(nullable UIEvent *)event;//在视图区域中移动
//- (void)touchesEnded:(NSSet *)touches withEvent:(nullable UIEvent *)event;//点击完成

@end
