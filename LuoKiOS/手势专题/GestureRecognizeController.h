//
//  GestureRecognizeController.h
//  iOS知识点总结项目 ———— 手势
//
//  Created by lkshine on 16/5/10.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomGestureRecognizer.h"  //自定义手势


@interface GestureRecognizeController : UIViewController

@property (nonatomic,strong) UITapGestureRecognizer         * tapGesture;
@property (nonatomic,strong) UIPinchGestureRecognizer       * pinchGesture;
@property (nonatomic,strong) UIRotationGestureRecognizer    * rotationGesture;
@property (nonatomic,strong) UISwipeGestureRecognizer       * swipeGesture;
@property (nonatomic,strong) UIPanGestureRecognizer         * panGesture;
@property (nonatomic,strong) UILongPressGestureRecognizer   * longPressGesture;
@property (nonatomic,strong) CustomGestureRecognizer        * customGesture;
@property (weak, nonatomic) IBOutlet UIImageView            * showImageView;   //记得打开imageview的交互否则没法响应
@property (weak, nonatomic) IBOutlet UILabel                * showLabel;       //同Imageview一样，默认交互是关闭的要打开

@end



/*
 
 手势需要添加到 UIView类 以及其子类之上，同时每个UIView可以添加多个手势。
 
 UITapGestureRecognizer：点击
 UIPinchGestureRecognizer：捏合
 UIRotationGestureRecognizer：旋转
 UISwipeGestureRecognizer：滑动
 UIPanGestureRecognizer：拖动，其又包含另外一个子类：UIScreenEdgePanGestureRecognizer
 UILongPressGestureRecognizer：长按
 
 */
