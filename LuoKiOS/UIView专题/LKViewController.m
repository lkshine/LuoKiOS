//
//  LKViewController.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/11.
//  Copyright © 2016年 lkshine. All rights reserved.
//  @@@代码九切片还需要研究

#import "LKViewController.h"
#import "CustomTouchView.h"



@interface LKViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *myView;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@property (nonatomic,strong) CustomTouchView * customView;
@property (nonatomic,strong) LKXibCustomView * xibView;

@end

@implementation LKViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self slicingBycode];
    [self createViewByCode];
    [self createViewByXib];
    [self convertView];
    
}

#pragma mark -- 乾坤大挪移
- (void)convertView {
    
    NSLog(@"newFrame:x:%f, y:%f",self.customView.frame.origin.x, self.customView.frame.origin.y);
    CGRect newFrame = [self.customView convertRect:self.xibView.frame toView:self.view];
    NSLog(@"newFrame:x:%f, y:%f",newFrame.origin.x, newFrame.origin.y);
    
    /*
     
     - (CGPoint)convertPoint:(CGPoint)point toView:(nullable UIView *)view;
     - (CGPoint)convertPoint:(CGPoint)point fromView:(nullable UIView *)view;
     - (CGRect)convertRect:(CGRect)rect toView:(nullable UIView *)view;
     - (CGRect)convertRect:(CGRect)rect fromView:(nullable UIView *)view;
     
     
     [aView convertPoint:p toView:anotherView]是指将p相对aView的坐标转换为相对anotherView的坐标
     比如说aView是原点(0,0)， 宽高(1024, 768)的视图
     anotherView是aView的子视图，原点是(100, 0),宽高(200, 200)
     那么一个在anotherView中坐标是(0, 0)的点经过转换后在aView的坐标是(100, 0)
     convertPoint:fromView:跟上面的方法是一个意思，只是转换的方向不一样而已
     
     */
}

//代码九切片
- (void)slicingBycode {
    
    //代码的方式对图片进行九切片
    UIImage *image = [UIImage imageNamed:@"greenChat"];
    UIImage * newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30)];//上下左右各保留10PX的内容
    NSLog(@"image = %@ , newImage = %@", image, newImage);
    _myView.image = image;
    //    _showImageView.image = _myView.image;
    /*
     resizableImageWithCapInsets 详细参见：http://www.jianshu.com/p/a577023677c1
     */
    
}

#pragma mark -- 自定义View
//代码创建自定义view
- (void)createViewByCode {
    
    //理念就是先代码自定义UIView类中重写父类方法，然后丰富内部组件，再在调用的地方行驶初始化方法
    _customView = [[CustomTouchView alloc]initWithFrame:CGRectMake(90, 140, 120, 60)];
    [self.view addSubview:_customView];
    
}


//xib创建自定义view
- (void)createViewByXib {
    
    //理念就是xib构建好的视图内，丰富组件后约束拉设置好，再弄个静态方法（类方法），调用那个数组里最后个对象即为该视图，再在调用的地方直接调用自己写的静态方法去初始化，然后设置frame就行了
    _xibView = [LKXibCustomView initFromNib];
    _xibView.frame = CGRectMake(90, 60, _xibView.frame.size.width, _xibView.frame.size.height);
    [self.view addSubview:_xibView];
    NSLog(@"_xibveiw.rect = %@", NSStringFromCGRect(_xibView.bounds));
    
}


#pragma mark -- 触摸
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"%s controlBegan",__func__);
    
}


#pragma mark -- 变形
- (IBAction)moveAction:(UIButton *)sender {
    
    CGPoint point = self.myView.center;
    point.x -=10;
    self.myView.center = point;
    NSLog(@"myview frame :%@",NSStringFromCGRect(self.myView.frame));
   
}


- (IBAction)scaleAction:(UIButton *)sender {
    
    int i = arc4random() % 2;
    if (i) {
    
        self.myView.transform = CGAffineTransformScale(self.myView.transform, 1.1, 1.1);
        NSLog(@"myview frame :%@",NSStringFromCGRect(self.myView.frame));
        
    }
    else {
        
        CGRect frame = self.myView.bounds;
        frame.size.width += 0.1;
        frame.size.height += .1;
        self.myView.bounds = frame;
        NSLog(@"myview frame :%@",NSStringFromCGRect(self.myView.frame));
        
    }
}


- (IBAction)rotateAction:(UIButton *)sender {
    
    self.myView.transform = CGAffineTransformRotate(self.myView.transform,M_PI_4);
    NSLog(@"myview frame :%@",NSStringFromCGRect(self.myView.frame));
    
}


//当需要重置transform属性时，可以进行如下设置。但要注意的是：假如需要完全重置一个视图的样式，除了重置transform属性之外，还需要重置frame, center, bounds。
- (IBAction)resetAction:(UIButton *)sender {
    
    self.myView.transform = CGAffineTransformIdentity;
    
}


#pragma mark -- UIView类的动画
- (IBAction)playAction:(UIButton *)sender {
    
    [UIView animateWithDuration:1.0 animations:^{
        
        self.myView.backgroundColor = [UIColor redColor];
        self.myView.transform = CGAffineTransformScale(self.myView.transform, 1.2,1.2);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1.0 animations:^{
            self.myView.backgroundColor = [UIColor greenColor];
            self.myView.transform = CGAffineTransformIdentity;
        }];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end
