//
//  Base1View.m
//  LuoKiOS
//
//  Created by lkshine on 16/7/29.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "Base1View.h"

@implementation Base1View

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    _lab = [UILabel new];
//    _lab.frame = self.bounds;//这个时候self还没frame又怎么能给label一个显示范围呢？，这里其实我们应该在 initwithframe 方法里去掉该方法才是对的
    _lab.frame = CGRectMake(10, 20, 120, 20);
    _lab.textAlignment = NSTextAlignmentCenter;
    _lab.font = [UIFont systemFontOfSize:15];
    _lab.text = @"虽然我只是label点我";
    _lab.textColor = [UIColor redColor];
    [self addSubview:_lab];
    
    UITapGestureRecognizer * labTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTapAction:)];
    [self addGestureRecognizer:labTap];
    
}

- (void)labelTapAction:(UITapGestureRecognizer *)gesture {
    
    NSLog(@"点了");
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToNext)]) {
        
        [self.delegate pushToNext];
        //上面代码中的判断条件最好是写上，因为这是判断self.delegate是否为空，以及实现TapActionDelegate协议的Controller是否也实现了其中的pushToNewPage方法。
    }
    
    if (self.tapActionBlock) {
        self.tapActionBlock();
    } //直接写 _TapActionBlock也可以的
    
    
    //不管block还是代理，加if的条件判断是为了更好的让我们不要遗落每个步骤流程
}



@end



