//
//  GestureRecognizeController.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/10.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "GestureRecognizeController.h"


/* 参考文档：http://blog.csdn.net/totogo2010/article/details/8615940/ */

@interface GestureRecognizeController ()<UIGestureRecognizerDelegate>

/* 本来是想懒加载UIGestureRecognize类的，可是不行，不知道原因在哪 */
@property (nonatomic,strong) NSMutableArray * imageList;
@property (nonatomic,assign) NSInteger        imageIndex; //记录当前展示第几张图片

@end


@implementation GestureRecognizeController


#pragma mark -- LazyLoad

-(NSMutableArray *)imageList {
    
    if (_imageList == nil) {
        
        _imageList = [NSMutableArray array];
        
        for (int i = 0; i < 4; i++) {
            
            NSString *imageName = [NSString stringWithFormat:@"%d", i];
            UIImage *image = [UIImage imageNamed:imageName];
            [_imageList addObject:image];
            
        }
        NSLog(@"_imageList = %@", _imageList);
    }
    
    return _imageList;
    
}


- (void)customTGesture {
    
    _customGesture = [[CustomGestureRecognizer alloc]initWithTarget:self action:@selector(customAction)];
    [self.showImageView addGestureRecognizer:_customGesture];
    
}


- (void)tapGreture /* 点击手势 */ {
    
    _tapGesture = [UITapGestureRecognizer new];
    [_tapGesture addTarget:self action:@selector(tapAction)];
    
    //等价于
    //  _tapGesture = [UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction);
    
    self.view.backgroundColor = [UIColor orangeColor];
    [self.showImageView addGestureRecognizer:_tapGesture];
    
    //单击
    _tapGesture.numberOfTapsRequired = 1;
    //单手指
    _tapGesture.numberOfTouchesRequired = 1;
    
}

- (void)pinchGreture /* 捏合手势 */ {
    
    _pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchAction:)];
    [self.view addGestureRecognizer:_pinchGesture];
    
}

- (void)rotationGreture /* 旋转手势 */ {
    
    _rotationGesture = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotationAction)];
    [self.showImageView addGestureRecognizer:_rotationGesture];
    
}


- (void)swipeGreture /* 滑动手势 */ {
    
    _swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction)];
    [self.showImageView addGestureRecognizer:_swipeGesture];
    
}


- (void)panGreture /* 拖动手势 */ {
    
    _panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self.showImageView addGestureRecognizer:_panGesture];
    
}

- (void)longPressGreture /* 长按手势 */ {
    
    _longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [self.showImageView addGestureRecognizer:_longPressGesture];
    
}


#pragma mark -- GestureAction

- (void)customAction {
    
    NSLog(@"%s",__func__);
    
}


- (void)tapAction {
    
    NSLog(@"%s",__func__);
    
    //获取手势点击的位置
    NSLog(@"tapPoint = %@",NSStringFromCGPoint([_tapGesture locationOfTouch:0 inView:self.view]));
    
    //iOS8以后alert建议的形式
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"单击+单手指" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

- (void)pinchAction:(UIPinchGestureRecognizer *)gesture {
    
    NSLog(@"%s",__func__);
    
    //获取手势点击的状态和视图
    switch (_pinchGesture.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"Began");
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"Ended");
            break;
        case UIGestureRecognizerStateChanged:
            NSLog(@"Changed");
            break;
        case UIGestureRecognizerStateFailed:
            NSLog(@"Failed");
            break;
        default:
            break;
    }
    
    NSLog(@"%s, scale: %f, velocity:%f",__func__,gesture.scale,gesture.velocity);
    
    CGFloat scale = gesture.scale;
    self.showImageView.transform = CGAffineTransformScale(gesture.view.transform, scale, scale);
    
    //一定要把scale的值重置为1，否则会影响缩放效果，即缩放比例会在上一次基础上进行缩小/放大
    gesture.scale = 1;
    
}

// 比较pinch和rotate的Action方法可知，带上参数的话，可以不用写全局变量的方便
- (void)rotationAction {
    
    NSLog(@"%s",__func__);
    
    //手势事件对应的视图对象
    NSLog(@"view = %@", _rotationGesture.view);
    
    NSLog(@"%s, rotation:%f, velocity:%f",__func__,_rotationGesture.rotation,_rotationGesture.velocity);
    CGFloat rotation = _rotationGesture.rotation;
    self.showImageView.transform = CGAffineTransformRotate(_rotationGesture.view.transform, rotation);
    
    //一定要把rotation的值重置为0，否则会影响旋转效果
    _rotationGesture.rotation = 0;
    
}

- (void)swipeAction {
    
    NSLog(@"%s",__func__);
    
}

- (void)panAction:(UIPanGestureRecognizer *)gesture {
    
    NSLog(@"%s",__func__);
    //获取位置变化量translation
    CGPoint translation = [gesture translationInView:self.view];
    gesture.view.center = CGPointMake(gesture.view.center.x + translation.x, gesture.view.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:self.view];
    
}

//实现长按状态显示功能
- (void)longPressAction:(UILongPressGestureRecognizer *)gesture {
    
    NSLog(@"%s",__func__);
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"长按开始");
        self.showLabel.text = @"长按开始";
    }else if (gesture.state == UIGestureRecognizerStateEnded){
        NSLog(@"长按结束");
        self.showLabel.text = @"长按结束";
    }
    else {
        NSLog(@"长按中");
        self.showLabel.text = @"长按中";
    }
    
}




#pragma mark -- 多手势之间是互斥的，想要同时触发多个手势，就需要遵循 UIGestureRecognizerDelegate 代理协议了,设置代理了
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    [self customTGesture];
//    [self tapGreture];
//    [self panGreture];
//    [self pinchGreture];
//    [self rotationGreture];
//    [self swipeGreture];
    [self longPressGreture];
    
    //移除某个手势
    [self.view removeGestureRecognizer:_panGesture];
    
    _tapGesture.delegate = self;
    _pinchGesture.delegate = self;
    _rotationGesture.delegate = self;
    
    //手势的依赖性
    [_tapGesture requireGestureRecognizerToFail:_panGesture]; //意思就是，当如果pan手势失败，就是没发生拖动，才会出发tap手势。这样如果你有轻微的拖动，那就是pan手势发生了。
    
//    [self viewPicture];
    
}

#pragma mark -- 通过Swipes属性里的四个方向制止模拟图片浏览器效果
- (void)viewPicture {
    
    //通过手势切换图片（伪图片游览器）
    
    self.imageIndex = 0;
    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    UISwipeGestureRecognizer *swipLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.showImageView addGestureRecognizer:swipeRightGesture];
    [self.showImageView addGestureRecognizer:swipLeftGesture];
    
}

//实现图片滑动功能
- (void)swipe:(UISwipeGestureRecognizer *)gesture {
    
    NSLog(@"%s",__func__);
    
    int totalCount = (int)self.imageList.count;
    
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft
        || gesture.direction == UISwipeGestureRecognizerDirectionUp) {
        
        if (self.imageIndex >= totalCount -1) return;
        self.showImageView.image = self.imageList[++self.imageIndex];
        
    }
    else if (gesture.direction == UISwipeGestureRecognizerDirectionRight
             || gesture.direction == UISwipeGestureRecognizerDirectionDown) {
        
        if (self.imageIndex <= 0) return;
        self.showImageView.image = self.imageList[--self.imageIndex];
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
