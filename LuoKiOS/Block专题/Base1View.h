//
//  Base1View.h
//  LuoKiOS
//
//  Created by lkshine on 16/7/29.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TapActionDelegate <NSObject> //注意协议名称规范化，首写字母大写

- (void)pushToNext;

@end



@interface Base1View : UIView

@property (nonatomic, strong) UILabel * lab;

//先说代理的行为流程
@property (nonatomic, assign) id<TapActionDelegate> delegate;

//再来介绍我们的block
@property (nonatomic, copy) void (^tapActionBlock)();

@end




/*
 block有如下几种使用情况，
 
 1、作为一个本地变量（local variable）
 
 returnType (^blockName)(parameterTypes) = ^returnType(parameters) {...};
 
 2、作为@property
 
 @property (nonatomic, copy) returnType (^blockName)(parameterTypes);
 
 3、作为方法的参数（method parameter）
 
 - (void)someMethodThatTakesABlock:(returnType (^)(parameterTypes))blockName;
 
 4、作为方法参数的时候被调用
 
 [someObject someMethodThatTakesABlock: ^returnType (parameters) {...}];
 
 5、使用typedef来定义block，可以事半功倍
 
 typedef returnType (^TypeName)(parameterTypes);
 TypeName blockName = ^returnType(parameters) {...};
 
 
 
 */