//
//  Number.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/15.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "Number.h"
#import "NSString+Extent.h"

@implementation Number


+ (instancetype)number {
    
    Number *number = [[Number alloc] init];
    number.titleNumber = [NSString stringWithFormat:@"%d", arc4random_uniform(100000)];
    int radmonNumber = arc4random_uniform(2);
    
    if (1 == radmonNumber) {
        
        number.detailDescription = @"对于需要动态调整高度的控件，在使用自动布局设置约束时，一定不要设置其绝对高度，其高度要根据控件与周边其他控件的位置约束来决定。如下图所示";
        
    }
    else {
        
        number.detailDescription = number.titleNumber;
    }
    
    //设置高度
    //1、获取屏幕的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    //2、设置detailDescriptionLabel的宽度
    CGFloat marginW = 8;
    CGFloat descLabelW = cellW - 2*marginW;
    CGFloat detailLabelHeight = [number.detailDescription heightWithText:number.detailDescription font:[UIFont systemFontOfSize:17.0] width:descLabelW];
    
    //建议再加1，因为算出来的高度可能包含小数，在显示的时候有可能会被省略造成显示不完成
    number.cellLabelHeight = marginW + 21/* titleLabel.height */ + marginW + detailLabelHeight + marginW + 1;
    
    return number;
}

#pragma mark -- 打印Number类时候会调用的工厂方法和类方法
- (NSString *)description {
    /*
     // 错误示范
     return [NSString stringWithFormat:@"%@", self];
     */
    return [NSString stringWithFormat:@"titleNumber: %@, detailDescription: %@, cellLabelHeight: %e",
            self.titleNumber, self.detailDescription, self.cellLabelHeight];
}
//自己实现description方法可以“打印类”（我们想要看到class的内容），更加便于调试，但是在description方法中不要返回或者打印self。

+ (NSString *)description {
    
    return @"Number";
}



@end


