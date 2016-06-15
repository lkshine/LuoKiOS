//
//  BezierPathView.h
//  LuoKiOS
//
//  Created by lkshine on 16/5/31.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, SharpType) {
    
    kLineShape = 0,
    kRectShape ,
    kEllipeShape ,
    kImageShape
};

typedef NS_ENUM(NSInteger, ColorTabIndex) {
    
    kRedColor = 0,
    kBlueColor,
    kRandomColor
};


@interface BezierPathView : UIView

@property (nonatomic,assign) SharpType sharpType;
@property (nonatomic,assign) BOOL useRandomColor;
@property (nonatomic,strong) UIColor *currentColor;

@end
