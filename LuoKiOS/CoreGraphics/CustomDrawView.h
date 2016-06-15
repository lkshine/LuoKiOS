//
//  CustomDrawView.h
//  LuoKiOS
//
//  Created by lkshine on 16/5/31.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDrawView : UIView

@property (nonatomic, assign) CGPoint   firstTouchPoint;
@property (nonatomic, assign) CGPoint   lastTouchPoint;
@property (nonatomic, assign) BOOL      useRandomColor;
@property (nonatomic, strong) UIColor * currentColor;
@end


