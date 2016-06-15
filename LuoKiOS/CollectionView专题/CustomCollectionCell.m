//
//  CustomCollectionCell.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/19.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "CustomCollectionCell.h"

@implementation CustomCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end


/*
 
 设置自动布局约束：由于需要适配多种尺寸的屏幕，所以在添加约束时，尽量不要设置子控件的绝对高度和宽度，否则当屏幕尺寸不同时，会影响显示效果。尽量设置边距约束。
 
 */