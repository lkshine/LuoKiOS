//
//  MyCell.h
//  iOS知识点总结项目 ----- 自定义Cell
//
//  Created by lkshine on 16/5/15.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Number.h" //这里很奇怪，明明在全局头文件pch里写了，但是无效识别不了，所以还是得写一次


@interface MyCell : UITableViewCell

@property (nonatomic, copy) Number * cellData;
+ (instancetype)myCellWithTableView:(UITableView *)tableView;

@end
