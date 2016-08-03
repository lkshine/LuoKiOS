//
//  CustomTouchView.m
//  iOS知识点总结项目---自定义view
//
//  Created by lkshine on 16/5/11.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "CustomTouchView.h"


/*
 
    代码自定义UIView类的时候，注意两个，一个是创建方法，一个就是交互事件，
    比如这里是代码创建的，当然需要调用父类的self = [super initWithFrame:frame];
    然后为了让该类具有交互功能，重写touch事件就可以了
    如果视图需要响应用户交互，如点击等，可以为视图添加手势或者实现UIResponder类的touches系列方法；
 
 */




@implementation CustomTouchView
//对于构造方法，这里讲解的还不错：http://www.tuicool.com/articles/2aEnEzV （讲的很详细）和这个实用版：http://blog.sina.com.cn/s/blog_6f72ff900102v0ms.html （这个就是工厂方法/类方法，用来快捷给属性赋值，快速初始化一个实例对象）再就是这个 http://www.bkjia.com/IOSjc/1009069.html（把第一个链接和第二个链接的名词区分开来了），带init的就是构造方法
// 使用NSProxy和NSObject设计代理类的差异 http://www.tuicool.com/articles/ya2eqaM
// 算法（$1）实现的手势图形识别http://www.tuicool.com/articles/RNju2a3
#pragma mark -- 构造方法
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        //下面的部分就是自定义的构造方法内容了
        
        self.backgroundColor = [UIColor orangeColor];
        NSLog(@"%s",__func__);
        
        //定制View
        self.backgroundColor = [UIColor blueColor];
        self.alpha = 0.5;
        
        self.userInteractionEnabled = YES; //设置为NO后，不再响应touch方法
        self.multipleTouchEnabled = YES;
        
        //控制子视图不能超出父视图的范围
        self.clipsToBounds = YES;
        
        //添加子视图
        [self subView];
        
        //添加手势
        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressAction)];
        [self.subView addGestureRecognizer:longpress];
        
    }
    
    return self;
}


- (void)longpressAction {
    
    NSLog(@"%s",__func__);
    
}

//子视图懒加载
-(UIView *)subView {
    
    if (!_subView) {
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, 50, 50);//超出父视图的范围，无法响应点击事件
        view.backgroundColor = [UIColor redColor];
        [self addSubview:view];
        _subView = view;
        
    }
    
    return _subView;
    
}



/*配置View点击，作用域在于对象的frame范围内*/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"%s 接收到触摸事件",__func__);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"%s, event: %@",__func__,event);
        
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"点击了视图" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"%s",__func__);
    
}


/*
 当需要对子视图进行重新布局的时候，实现layoutSubViews方法；
 那么问题来了，什么时候需要触发呢？比如有三个按钮有时候显示1个，
 有时候要显示2个，有时候显示3个的情况，就需要重新布局显示位置了
 
 */
- (void)layoutSubviews {
    
    self.subView.frame = CGRectMake(30, 30, 60, 60);
}


/* 当需要做自定义绘图的时候，实现drawRect:方法；下面的代码实现了为视图四周添加一个边框；*/
- (void)drawRect:(CGRect)rect {
    NSLog(@"%s",__func__);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect    myFrame = self.bounds;
    
    //添加边框
    CGContextSetLineWidth(context, 10);
    CGRectInset(myFrame, 5, 5);
    
    [[UIColor greenColor] set];
    UIRectFrame(myFrame);
    
}

@end
