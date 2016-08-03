//
//  KeyFrameView.m  -- 关键帧动画
//  LuoKiOS
//
//  Created by lkshine on 16/6/5.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "KeyFrameView.h"


@interface KeyFrameView ()

@property (weak, nonatomic) IBOutlet UIImageView * searchIV;
@property (weak, nonatomic) IBOutlet UIImageView * contactsIV;
@property (weak, nonatomic) IBOutlet UIImageView * twitterIV;
@property (weak, nonatomic) IBOutlet UIImageView * snowIV;


@end


@implementation KeyFrameView

+ (instancetype)keyFrameAnimationView {
    
    KeyFrameView * view = [[[NSBundle mainBundle] loadNibNamed:@"KeyFrameView" owner:self options:nil] lastObject];
    
    return view;
}


- (void)moveBirdView {
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
    animation.keyPath               = @"position";
    //获取初始position
    CGPoint originalPosition        = self.twitterIV.layer.position;
    CGFloat originalX               = originalPosition.x;
    CGFloat originalY               = originalPosition.y;
    CGFloat moveMargin              = 20;
    //设置values属性
    NSValue *value1                 = [NSValue valueWithCGPoint:CGPointMake(originalX + moveMargin, originalY + moveMargin)];
    NSValue *value2                 = [NSValue valueWithCGPoint:CGPointMake(originalX + 2 * moveMargin, originalY)];
    NSValue *value3                 = [NSValue valueWithCGPoint:CGPointMake(originalX + moveMargin, originalY - moveMargin)];
    NSValue *value4                 = [NSValue valueWithCGPoint:originalPosition];
    //思考：开头不添加value4的动画效果
    animation.values                = @[value4, value1, value2, value3, value4];
    animation.duration              = 2.0;
    animation.repeatCount           = MAXFLOAT;
    
    [self.twitterIV.layer addAnimation:animation forKey:nil];
}


- (void)moveSearchView {
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
    animation.keyPath               = @"position";
    //获取初始position
    CGPoint originalPosition        = self.searchIV.layer.position;
    CGFloat originalX               = originalPosition.x;
    CGFloat originalY               = originalPosition.y;
    //初始化一个贝塞尔路径
    UIBezierPath *path              = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(originalX, originalY, 50, 20)];
    animation.path                  = path.CGPath;
    animation.duration              = 1.0;
    animation.repeatCount           = MAXFLOAT;
    animation.removedOnCompletion   = NO;
    animation.fillMode              = kCAFillModeForwards;
    
    [self.searchIV.layer addAnimation:animation forKey:nil];
}


- (void)shakeContactsView {
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
    animation.keyPath               = @"transform.rotation";
    CGFloat rotationValue1          = (6/180.0) * M_PI;
    CGFloat rotationValue2          = (-6/180.0) * M_PI;
    //注意数组存储基本数据类型的语法格式
    animation.values                = @[@(rotationValue2), @(rotationValue1), @(rotationValue2)];
    animation.duration              = 0.25;
    animation.repeatCount           = MAXFLOAT;
    
    [self.contactsIV.layer addAnimation:animation forKey:nil];
}


#pragma mark -- 本来我们是希望能展现一个按着一个圆圈旋转的雪花效果，但是没有效果，需要动画组来实现了
- (void)downSnowStorm {
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
    animation.keyPath               = @"transform.rotation.scale.move";
    CGFloat rotationValue1          = (60/180.0) * M_PI;
    CGFloat rotationValue2          = (-60/180.0) * M_PI;
    //注意数组存储基本数据类型的语法格式
    animation.values                = @[@(rotationValue2), @(rotationValue1), @(rotationValue2)];
    animation.duration              = 3;
    animation.repeatCount           = MAXFLOAT;
    
    
    //获取初始position
    CGPoint originalPosition        = self.snowIV.layer.position;
    CGFloat originalX               = originalPosition.x;
    CGFloat originalY               = originalPosition.y;
    //初始化一个贝塞尔路径
    UIBezierPath *path              = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(originalX, originalY, 50, 20)];
    animation.path                  = path.CGPath;


    CGFloat moveMargin              = 20;
    //设置values属性
    NSValue *value1                 = [NSValue valueWithCGPoint:CGPointMake(originalX + moveMargin, originalY + moveMargin)];
    NSValue *value2                 = [NSValue valueWithCGPoint:CGPointMake(originalX + 2 * moveMargin, originalY)];
    NSValue *value3                 = [NSValue valueWithCGPoint:CGPointMake(originalX + moveMargin, originalY - moveMargin)];
    NSValue *value4                 = [NSValue valueWithCGPoint:originalPosition];
    
   
    animation.values                = @[value4, @(rotationValue2), value2, @(rotationValue2), value1, @(rotationValue1), value3, value4];
    
    
    [self.snowIV.layer addAnimation:animation forKey:nil];
    
}


/*
 
 简单动画配合关键帧应用弄混淆的代码如下：
 
 [UIView animateKeyframesWithDuration:2 delay:0 options:UIViewAnimationOptionRepeat animations:^{
 //这里的0.5是表示最外层动画的时间占比
 
 [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
 _image.transform = CGAffineTransformMakeScale(1.5, 1.5);
 }];
 [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
 _image.transform = CGAffineTransformMakeScale(0.5, 0.5);
 }];
 
 } completion:^(BOOL finished) {
 
 }];
 
 而不是
 
 [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionRepeat  animations:^{
            ...

 
 */


//苹果Entitlements http://www.ithao123.cn/content-6309846.html

- (IBAction)clickPlay:(id)sender {
    
    [self moveBirdView];
    [self moveSearchView];
    [self shakeContactsView];
    [self downSnowStorm];
}

#pragma mark -- 获取今天的0点时间和下一天的0店时间
- (void)getToday0amAndTomorrow0am {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    NSLog(@"endData = %@", endDate);
}

#pragma mark -- 获取今天的0点时间和下一天的0点时间
- (void)gotToday0amAndTomorrow0am {
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    [calendar setTimeZone:gmt];
    NSDate *date = [NSDate date];
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:date];
    components.day -= 1;
    [components setHour:0];
    [components setMinute:0];
    [components setSecond: 0];
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    NSLog(@"%@", endDate);
    
}

#pragma mark -- 获取指定时间
-(NSDate *)getStartTime:(NSDate *)date{
    static NSDateFormatter *dateFormat = nil;
    if (dateFormat == nil) {
        dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [dateFormat setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];//设定时间格式,这里可以设置成自己需要的格式
        [dateFormat setTimeZone:[NSTimeZone defaultTimeZone]];
    }
    
    NSString *locationString=[dateFormat stringFromDate: date];
    NSArray  *timeArray=[locationString componentsSeparatedByString:@"-"];
    SInt32 value_Y  =  (SInt32)[[timeArray objectAtIndex:0]intValue];
    SInt8 value_M  =  (SInt8)[[timeArray objectAtIndex:1]intValue];
    SInt8 value_D  =  (SInt8)[[timeArray objectAtIndex:2]intValue];
    NSString *stringDateStart = [NSString stringWithFormat:@"%d-%d-%d-%d-%d-%d",(int)value_Y,value_M,value_D,0,0,0];
    NSDate *dateStart_ = [dateFormat dateFromString:stringDateStart];
    
    return dateStart_;
}

@end
