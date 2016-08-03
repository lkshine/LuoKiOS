//
//  UIView+MotionEffect.h
//  LuoKiOS
//
//  Created by lkshine on 16/6/19.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MotionEffect)

@property (nonatomic, strong) UIMotionEffectGroup  * effectGroup;

- (void)addXAxisWithValue:(CGFloat)xValue YAxisWithValue:(CGFloat)yValue;
- (void)removeSelfMotionEffect;

@end


#pragma mark -- category和extension的区别：http://blog.csdn.net/yasi_xi/article/details/41119939
/*
 
 Category
 用于给class及其subclass添加新的方法
 有自己单独的 .h 和 .m 文件
 用于添加新方法，而不能添加新属性（property）
 
 Extension
 Extension常被称为是匿名的Category
 用于给类添加新方法，但只作用于原始类，不作用于subclass
 只能对有implementation源代码的类写Extension，对于没有implementation源代码的类，比如framework class，是不可以的
 Extension可以给原始类添加新方法，以及新属性
 
 
 PS:但是本例将讲述一个事实，通过运行时，依然可以实现category的属性被子类也使用哟，参考：http://www.jianshu.com/p/3cbab68fb856
 */