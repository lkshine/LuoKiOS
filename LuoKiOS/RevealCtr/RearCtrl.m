//
//  RearCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/6/2.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "RearCtrl.h"



@interface RearCtrl () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tabelView;
@property (nonatomic, strong) NSArray     * dataArr;

@end




@implementation RearCtrl


- (UITableView *)tabelView {
    
    if (!_tabelView) {
        
        _tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, wSrceem, hSrceem-20) style:UITableViewStylePlain];
        _tabelView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _tabelView.delegate        = self;
        _tabelView.dataSource      = self;
        [self.view addSubview:_tabelView];
    }
    
    return _tabelView;
}

- (NSArray *)dataArr {
    
    if (!_dataArr) {
        
        _dataArr = @[@"GestureRecognize", @"LKViewController",
                     @"AVAudioController", @"ImageViewController",
                     @"AlertViewController", @"ScrollViewController",
                     @"TableViewController" ,@"CoreGraphicCtrl",
                     @"DrawImageCtrl", @"DeviceCtrl",
                     @"CALayerCtrl", @"CoreAnimationCtrl",
                     @"BundleOrUrlCtrl", @"SysSchemesCtrl",
                     @"QRcodeCtrl", @"PushWithNotifyCtrl",
                     @"SMSVerificationCtrl", @"CollectionViewController",
                     @"APICtrl", @"CoreAnimationCtrl",
                     @"DynamicAnimatorCtrl", @"MotionEffectCtrl",
                     @"CoreMotionCtrl"];
    }
    return  _dataArr;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self tabelView];

}


#pragma mark - UITabelViewDataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * rearCell = @"RearCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:rearCell];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:rearCell];
    }
    
    cell.textLabel.text = _dataArr[indexPath.row];
    cell.textLabel.tintColor = [UIColor redColor];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SWRevealViewController * revealViewController = self.revealViewController;
    UIViewController * viewController;
    
    switch (indexPath.row) {
            
        case 0:
            viewController = [[GestureRecognizeController alloc] init];
            break;
        case 1:
            viewController = [[LKViewController alloc] init];
            break;
        case 2:
            viewController = [[AVAudioController alloc] init];
            break;
        case 3:
            viewController = [[ImageViewController alloc] init];
            break;
        case 4:
            viewController = [[AlertViewController alloc] init];
            break;
        case 5:
            viewController = [[ScrollViewController alloc] init];
            break;
        case 6:
            viewController = [[TableViewController alloc] init];
            break;
        case 7:
            viewController = [[CoreGraphicCtrl alloc] init];
            break;
        case 8:
            viewController = [[DrawImageCtrl alloc] init];
            break;
        case 9:
            viewController = [[DeviceCtrl alloc] init];
            break;
        case 10:
            viewController = [[CALayerCtrl alloc] init];
            break;
        case 11:
            viewController = [[CoreAnimationCtrl alloc] init];
            break;
        case 12:
            viewController = [[BundleOrUrlCtrl alloc] init];
            break;
        case 13:
            viewController = [[SysSchemesCtrl alloc] init];
            break;
        case 14:
            viewController = [[QRcodeCtrl alloc] init];
            break;
        case 15:
            viewController = [[PushWithNotifyCtrl alloc] init];
            break;
        case 16:
            viewController = [[SMSVerificationCtrl alloc] init];
            break;
        case 17:
            viewController = [[CollectionViewController alloc] init];
            break;
        case 18:
            viewController = [[APICtrl alloc] init];
            break;
        case 19:
            viewController = [[CoreAnimationCtrl alloc] init];
            break;
        case 20:
            viewController = [[DynamicAnimatorCtrl alloc] init];
            break;
        case 21:
            viewController = [[MotionEffectCtrl alloc] init];
            break;
        case 22:
            viewController = [[CoreMotionCtrl alloc] init];
            break;
            
        default:
            break;
    }
    
    //调用pushFrontViewController进行页面切换
    [revealViewController pushFrontViewController:viewController animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
