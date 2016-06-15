//
//  LKXibCustomView.h
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/11.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKXibCustomView : UIView
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;

+(LKXibCustomView *)initFromNib;

@end
