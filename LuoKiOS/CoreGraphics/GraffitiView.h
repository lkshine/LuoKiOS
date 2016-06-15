//
//  GraffitiView.h
//  LuoKiOS
//
//  Created by lkshine on 16/6/4.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraffitiView : UIView

//记录当前绘图路径
@property (nonatomic, strong) UIBezierPath * path;

//存放所有已经绘制的路径
@property (nonatomic, copy) NSMutableArray * pathArray;
-(void) clearAllPath;

@end
