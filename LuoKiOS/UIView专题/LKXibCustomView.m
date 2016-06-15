//
//  LKXibCustomView.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/11.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "LKXibCustomView.h"

@implementation LKXibCustomView

+ (LKXibCustomView *)initFromNib {
    
    NSLog(@"%s",__func__);
    return [[[NSBundle mainBundle] loadNibNamed:@"LKXibCustomView" owner:self options:nil] lastObject];

}



//xib的打开后其实就是xml写的代码，但是不已经不在走initwithframe方法，而是initwithcode方法，所以，就算这么写，然后在里面添加上静态方法也没用
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [LKXibCustomView initFromNib];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)coder {
    
    NSLog(@"%s",__func__);
    self = [super initWithCoder:coder];
    
    if (self) {
        
//        [self configure];
    }
    return self;
}


//用于定制View的样式，使用Xib建议在awakeFromNib中设置视图属性
-(void)awakeFromNib{
    
    NSLog(@"%s",__func__);
    [self configure];
}


//特别注意： 通过configure方法的不同位置调用时机，我们发现，如果是新增组件 无论是在initWithCoder还是awakeFromNib都可以，但是如果是优化组件的话，只在awakeFromNib方法才有效果哦
- (void)configure {
    
    UIView * subview = [[UIView alloc]initWithFrame:CGRectMake(30, 20, 60, 20)];
    subview.backgroundColor = [UIColor redColor];
    [self addSubview:subview];
    self.alpha = 0.9;
    
    self.showLabel.layer.masksToBounds = YES;
    self.showLabel.layer.borderWidth = 1;
    self.showLabel.layer.cornerRadius = 3;
    self.showLabel.layer.borderColor = [UIColor brownColor].CGColor;
}


- (IBAction)clickAction:(UIButton *)sender {
    
    NSLog(@"%s",__func__);
}

/*
 
 当需要对子视图进行重新布局的时候，实现layoutSubViews方法；
 当需要做自定义绘图的时候，实现drawRect:方法（同代码创建）；
 如果视图需要响应用户交互，如点击等，可以为视图添加手势或者实现UIResponder类的touches系列方法（同代码创建）
 
 */

@end



