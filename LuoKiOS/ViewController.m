//
//  ViewController.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/26.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,strong) UIButton * gestureBtn;

#pragma mark -- 在源控制器里实现转场代理
/*自定义navi转场动画第一步*/
@property (nonatomic, strong) NavigationTransitionDelegate * naviDelegate;

@end



@implementation ViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self gestureBtn];
    
    /*自定义navi转场动画第三步*/
    [self customTransitionNavigationSetting];

}

/*自定义navi转场动画第二步*/
#pragma mark -- 自定义导航栏PushPop动画代理及手势响应
- (void)customTransitionNavigationSetting {
    
    self.naviDelegate = [[NavigationTransitionDelegate alloc] init];
    self.navigationController.delegate = self.naviDelegate;
    
    UIScreenEdgePanGestureRecognizer *panGR = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(handlePanGR:)];
    panGR.edges = UIRectEdgeLeft;
    [self.navigationController.view addGestureRecognizer:panGR];
}

- (void)handlePanGR:(UIScreenEdgePanGestureRecognizer *)panGR{
    switch (panGR.state) {
        case UIGestureRecognizerStateBegan:
        {
            //拖动开始，进入交互模式
            [self.naviDelegate enterInteractiveMode];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            //根据拖动距离更新交互式动画的进度
            CGPoint pt = [panGR translationInView:panGR.view];
            [self.naviDelegate.percentTransition updateInteractiveTransition:pt.x / panGR.view.frame.size.width];
        }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        {
            //拖动手势取消或者失败，离开交互模式，并通知交互式动画控制器取消动画
            [self.naviDelegate leaveInteractiveMode];
            [self.naviDelegate.percentTransition cancelInteractiveTransition];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            //拖动结束，离开交互模式，并根据移动距离是否要完成动画
            [self.naviDelegate leaveInteractiveMode];
            
            CGPoint pt = [panGR translationInView:panGR.view];
            CGFloat delta = 0.0000001;
            if(pt.x - panGR.view.frame.size.width / 2 <= delta){
                [self.naviDelegate.percentTransition cancelInteractiveTransition];
            }
            else{
                [self.naviDelegate.percentTransition finishInteractiveTransition];
            }
        }
            break;
            
        default:
            break;
    }
}




- (UIButton *)gestureBtn {
    
    if (!_gestureBtn) {
        
        _gestureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _gestureBtn.frame = CGRectMake(90, 90, 120, 40);
        [_gestureBtn setTitle:@"JumpZone" forState:UIControlStateNormal];
        [_gestureBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _gestureBtn.backgroundColor = [UIColor magentaColor];
        [_gestureBtn addTarget:self action:@selector(gestureRecognizeClick) forControlEvents:UIControlEventTouchDown];
        
        [self.view addSubview:_gestureBtn];
        
    }
    
    return _gestureBtn;
    
}

- (void)gestureRecognizeClick {
    
    NSLog(@"%s",__func__);

//    GestureRecognizeController * grView = [GestureRecognizeController new];
//    LKViewController * grView = [LKViewController new];
//    AVAudioController *grView = [AVAudioController new];
//    ImageViewController *grView = [ImageViewController new];
//    AlertViewController *grView = [AlertViewController new];
//    ScrollViewController *grView = [ScrollViewController new];
//    TableViewController *grView = [TableViewController new];
//    WebViewController *grView = [WebViewController new];
//    SegmentedViewController *grView = [SegmentedViewController new];
//    CollectionViewController *grView = [CollectionViewController new];
//    TextFieldController *grView = [TextFieldController new];
//    TextViewController *grView = [TextViewController new];
//    SearchBarController *grView = [SearchBarController new];
//    PageController *grView = [PageController new];
//    PickerViewController *grView = [PickerViewController new];
//    DataPickerController *grView = [DataPickerController new];
//    DataPickerCountDownController *grView = [DataPickerCountDownController new];
//    SliderController *grView = [SliderController new];
//    NavCtrl *grView = [NavCtrl new];
//    TabBarController *grView = [TabBarController new];
//    NSThreadController *grView = [NSThreadController new];
//    NSOperationController *grView = [NSOperationController new];
//    NSInvocationOperationVC *grView = [NSInvocationOperationVC new];
//    NSBlockOperationVC *grView = [NSBlockOperationVC new];
//    GCDViewCtrl *grView = [GCDViewCtrl new];
//    ThreadSyncController *grView = [ThreadSyncController new];
//    NSLockController *grView = [NSLockController new];
//    SynchronizedController *grView = [SynchronizedController new];
//    GCDSemaphoreController *grView = [GCDSemaphoreController new];
//    NSConditionController *grView = [NSConditionController new];
//    NetworkProgrammingController *grView = [NetworkProgrammingController new];
//    DataParsingCtrl *grView = [DataParsingCtrl new];
//    ReachabilityCtrl *grView = [ReachabilityCtrl new];
//    APICtrl *grView = [APICtrl new];
//    SandboxCtrl *grView = [SandboxCtrl new];
//    PlistCtrl *grView = [PlistCtrl new];
//    PreferenceCtrl *grView = [PreferenceCtrl new];
//    ArchivedCtrl *grView = [ArchivedCtrl new];
//    SQLiteCtrl *grView = [SQLiteCtrl new];
//    FMDBctrl *grView = [FMDBctrl new];
//    CoreDataCtrl *grView = [CoreDataCtrl new];
//    CameraCtrl *grView = [CameraCtrl new];
//    MapCtrl *grView = [MapCtrl new];
//    LocationCtrl *grView = [LocationCtrl new];
//    BaiduMapCtrl *grView = [BaiduMapCtrl new];
//    CoreMotionCtrl *grView = [CoreMotionCtrl new];
//    DeviceCtrl *grView = [DeviceCtrl new];
    SysSchemesCtrl *grView = [SysSchemesCtrl new];
//    CoreGraphicCtrl *grView = [CoreGraphicCtrl new];
//    CoreAnimationCtrl *grView = [CoreAnimationCtrl new];
//    BundleOrUrlCtrl *grView = [BundleOrUrlCtrl new];
    
    [self.navigationController pushViewController:grView animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
