//
//  DynamicAnimatorCtrl.m ---- 动态力学行为动画
//  LuoKiOS
//
//  Created by lkshine on 16/6/19.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "DynamicAnimatorCtrl.h"

@interface DynamicAnimatorCtrl ()

@property (weak, nonatomic ) IBOutlet UIImageView       * imageview;
@property (weak, nonatomic ) IBOutlet UIButton          * snapBUtton;

//Dynamic animation
@property (strong,nonatomic) UIDynamicAnimator          * animator;

@end





@implementation DynamicAnimatorCtrl

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}


/*
 使用步骤：
 要想使用UIDynamic来实现物理仿真效果，大致的步骤如下
 
 （1）创建一个物理仿真器（顺便设置仿真范围）
 
 （2）创建相应的物理仿真行为（顺便添加物理仿真元素）
 
 （3）将物理仿真行为添加到物理仿真器中 开始仿真
 
 
 三个概念
 
（1）谁要进行物理仿真？
 
 　　物理仿真元素（Dynamic Item）
（2）执行怎样的物理仿真效果？怎样的动画效果？
 
 　　物理仿真行为（Dynamic Behavior）
（3）让物理仿真元素执行具体的物理仿真行为
 
 　　物理仿真器（Dynamic Animator）
 
 
 物理仿真元素
 
 注意：
 
 不是任何对象都能做物理仿真元素
 不是任何对象都能进行物理仿真
 
 物理仿真元素要素：
 
 任何遵守了UIDynamicItem协议的对象
 UIView默认已经遵守了UIDynamicItem协议，因此任何UI控件都能做物理仿真
 UICollectionViewLayoutAttributes类默认也遵守UIDynamicItem协议
 
 
 物理仿真行为
 
 UIDynamic提供了以下几种物理仿真行为
 
 UIGravityBehavior      ：重力行为
 UICollisionBehavior    ：碰撞行为
 UISnapBehavior         ：捕捉行为
 UIPushBehavior         ：推动行为
 UIAttachmentBehavior   ：附着行为
 UIDynamicItemBehavior  ：动力元素行为
 
 
 
 物理仿真行为须知
 
 上述所有物理仿真行为都继承自UIDynamicBehavior
 所有的UIDynamicBehavior都可以独立进行
 组合使用多种行为时，可以实现一些比较复杂的效果
 
 
 参考：http://www.cnblogs.com/wendingding/p/3893740.html 和 http://liuyanwei.jumppo.com/2015/10/30/iOS-UIKit-Dynamics.html
 */
- (UIDynamicAnimator *)animator {
    
    if (!_animator) {
        
        if (!_animator) {
            
            _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        }
    }
    
    return _animator;
}

- (void)reset {
    
    [self.animator removeAllBehaviors];
    self.imageview.center = CGPointMake(75, 114);
}


- (IBAction)snapAction:(UIButton *)sender {
    
    [self reset];
    UISnapBehavior * snapbehavior = [[UISnapBehavior alloc] initWithItem:self.imageview snapToPoint:self.view.center];
    snapbehavior.damping = 0.65;
    [self.animator addBehavior:snapbehavior];
}


- (IBAction)collisionAction:(UIButton *)sender {
    
    [self reset];
    UIGravityBehavior * gravityBehavior = [[UIGravityBehavior alloc] init];
    [gravityBehavior addItem:self.imageview];
    UIDynamicItemBehavior * itemBehavior = [[UIDynamicItemBehavior alloc] init];
    itemBehavior.resistance = 0.2;
    UICollisionBehavior * collisitionBehavior = [[UICollisionBehavior alloc] init];
    [collisitionBehavior addItem:self.imageview];
    collisitionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [collisitionBehavior addBoundaryWithIdentifier:@"Button" forPath:[UIBezierPath bezierPathWithRect:self.snapBUtton.frame]];
    [self.animator addBehavior:collisitionBehavior];
    [self.animator addBehavior:itemBehavior];
    [self.animator addBehavior:gravityBehavior];

}


- (IBAction)gravityAction:(UIButton *)sender {
    
    [self reset];
    UIGravityBehavior * gravityBehavior = [[UIGravityBehavior alloc] init];
    //    gravityBehavior.angle = M_PI/2;
    gravityBehavior.gravityDirection = CGVectorMake(0,1);
    gravityBehavior.magnitude = 0.5;
    [gravityBehavior addItem:self.imageview];
    [self.animator addBehavior:gravityBehavior];
}


- (IBAction)attachAction:(UIButton *)sender {
    
    [self reset];
    UIAttachmentBehavior * attachBeahavior =  [[UIAttachmentBehavior alloc] initWithItem:self.imageview attachedToAnchor:CGPointMake(CGRectGetMidX(self.view.frame), 114)];
    UIGravityBehavior * gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.imageview]];
    [self.animator addBehavior:attachBeahavior];
    [self.animator addBehavior:gravityBehavior];
}


- (IBAction)pushAction:(UIButton *)sender {
    
    [self reset];
    UIPushBehavior * push = [[UIPushBehavior alloc] initWithItems:@[self.imageview] mode:UIPushBehaviorModeInstantaneous];
    push.pushDirection = CGVectorMake(45, 0);
    push.magnitude = 1.0;
    UIDynamicItemBehavior * itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.imageview]];
    itemBehavior.resistance = 0.8;
    [self.animator addBehavior:itemBehavior];
    [self.animator addBehavior:push];

}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end
