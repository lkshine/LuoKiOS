//
//  SMSVerificationCtrl.m
//  LuoKiOS
//
//  Created by lkshine on 16/6/9.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "SMSVerificationCtrl.h"
#import "AuthcodeView.h"    //本地验证码

#import <SMS_SDK/SMSSDK.h>  //短信验证码
#define SMSVer_AppKey           @"13ae563bfb32c"
#define SMSVer_AppSecertKey     @"200f86f30fa05fad15cad7701864c936"


#import "CIA_SDK/CIA_SDK.h" //CIA验证码
#import "SecurityCodeViewController.h"
#define CIA_AppID               @"60614c14ae3c452e8f6c8017f299899c"
#define CIA_AuthKey             @"cf849abc43444dfc8579fac496f5ceb1"



@interface SMSVerificationCtrl ()<UITextFieldDelegate, UIAlertViewDelegate>
{
    AuthcodeView *authCodeView;
    UITextField *_input;
}

@property (weak, nonatomic) IBOutlet UITextField             * phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField             * codeNumber;


@property (weak, nonatomic) IBOutlet UITextField             * phoneText;
@property (weak, nonatomic) IBOutlet UIButton                * registerButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView * indicator;

@end



@implementation SMSVerificationCtrl


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initUI];
    
}


#pragma mark -- 本地验证码 （图形文字）,注意需要导入CoreGraphics.framework用于绘制图形，http://www.jianshu.com/p/6db1baca9e37 和 http://www.codeceo.com/article/ios-local-verfy-code.html
- (void)initUI {
    
    //状态栏的屏幕设配
    CGFloat statusBarHeight   = 0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        
        statusBarHeight = 20;
    }

    _indicator.hidden         = YES;

    self.view.backgroundColor = [UIColor whiteColor];

    //显示验证码界面
    authCodeView              = [[AuthcodeView alloc] initWithFrame:CGRectMake(30, 400, wSrceem-60, 40)];
    [self.view addSubview:authCodeView];

    //提示文字
    UILabel *label            = [[UILabel alloc] initWithFrame:CGRectMake(50, 460, wSrceem-100, 40)];
    label.text                = @"点击图片换验证码";
    label.font                = [UIFont systemFontOfSize:12];
    label.textColor           = [UIColor grayColor];
    [self.view addSubview:label];

    //添加输入框
    _input                    = [[UITextField alloc] initWithFrame:CGRectMake(30, 520, wSrceem-60, 40)];
    _input.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    _input.layer.borderWidth  = 2.0;
    _input.layer.cornerRadius = 5.0;
    _input.font               = [UIFont systemFontOfSize:21];
    _input.placeholder        = @"请输入验证码!";
    _input.clearButtonMode    = UITextFieldViewModeWhileEditing;
    _input.backgroundColor    = [UIColor clearColor];
    _input.textAlignment      = NSTextAlignmentCenter;
    _input.returnKeyType      = UIReturnKeyDone;
    _input.delegate           = self;
    [self.view addSubview:_input];
    
}


#pragma mark 输入框代理，点击return 按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_input resignFirstResponder];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //判断输入的是否为验证图片中显示的验证码
        if ([_input.text isEqualToString:authCodeView.authCodeStr]) {
            
            //正确弹出警告款提示正确
            UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"恭喜您 ^o^" message:@"验证成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alview show];
        }
        else {
            
            
            //验证不匹配，验证码和输入框抖动
            CAKeyframeAnimation * anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
            anim.repeatCount = 1;
            anim.values = @[@-20, @20, @-20];
            //        [authCodeView.layer addAnimation:anim forKey:nil];
            [_input.layer addAnimation:anim forKey:nil];
        }
        
    });
    
    return YES;
}


#pragma mark 警告框中方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //清空输入框内容，收回键盘
    if (buttonIndex==0) {
        
        _input.text = @"";
        [_input resignFirstResponder];
    }
}


#pragma mark -- mob短信验证 http://wiki.mob.com/cocoapods-集成smssdk/
- (IBAction)registerPhoneAction:(UIButton *)sender {
    
    NSString *phoneNumber = self.phoneNumber.text;
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneNumber zone:@"86" customIdentifier:nil result:^(NSError *error) {
        
        NSLog(@"code:%ld,domain:%@,userInfo:%@",(long)error.code,error.domain,error.userInfo);
        
        if (error == nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"验证码发送成功"
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
        else {//有错误
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"验证码发送失败"
                                                                message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"getVerificationCode"]]
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        };
    }];
}


- (IBAction)checkAction:(UIButton *)sender {
    
    NSString *codeNumber = self.codeNumber.text;
    NSString *phoneNumber = self.phoneNumber.text;
    [SMSSDK commitVerificationCode:codeNumber phoneNumber:phoneNumber zone:@"86" result:^(NSError *error) {
        NSLog(@"code:%ld,domain:%@,userInfo:%@",(long)error.code,error.domain,error.userInfo);
        
        
        if (error == nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"验证成功"
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }else {//有错误
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"验证失败"
                                                                message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"commitVerificationCode"]]
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            
        }
        
        
    }];
    
}
// SMSSKD短信开头自定义（自己公司名称）http://bbs.mob.com/thread-16106-1-1.html 和 http://bbs.mob.com/thread-185-1-1.html

//常见error代码说明

/**
 *	@brief	错误代码，如果为调用API出错则应该参考API错误码对照表。错误码对照表如下：
 错误码	错误描述	                         备注
 400	无效请求	                         客户端请求不能被识别。
 408	无效参数                          无效的请求参数
 456	手机号码为空	                     提交的手机号或者区号为空
 457	手机号码格式错误	                 提交的手机号格式不正确(包括手机的区号)
 458	手机号码在黑名单中	                 手机号码在发送很名单中
 459	无appKey的控制数据	                 获取appKey控制发送短信的数据失败
 460	无权限发送短信	                     没有打开客户端发送短信的开关
 461	不支持该地区发送短信                没有开通当前地区发送短信的功能
 462	每分钟发送次数超限	                 每分钟发送短息的次数超出限制
 463	手机号码每天发送次数超限	             手机号码每天发送短信的次数超出限制
 464	每台手机每天发送次数超限	             每台手机每天发送短信的次数超限
 465	号码在App中每天发送短信的次数超限	     手机号码在App中每天发送短信的数量超限
 466	校验的验证码为空	                 提交的校验验证码为空
 467    校验验证码请求频繁                  5分钟内校验错误超过3次，验证码失效
 468    需要校验的验证码错误                用户提交的验证码错误
 470    账号余额不足                       账号短信余额不足
 472    客户端请求发送短信验证过于频繁        客户端请求发送短信验证过于频繁
 475    appKey的应用信息不存在              appKey的应用信息不存在
 500    服务器内部错误                     服务器程序报错
 */


#pragma mark -- CIA闪验 http://www.ciaapp.cn/

//第一步和mob的SMSSDK一样，也需要在AppDelegate里做初始化配置授权码
- (IBAction)registerClick:(UIButton *)sender {
    
    [self showIndicator];
    // 点击注册
    // 调用CIA SDK发起验证请求
    [CIA startVerificationWithPhoneNumber:_phoneText.text callback:^(NSInteger code, NSString *msg, NSError *err) {
        [self hideIndicator];
        
        // 可能返回的code
        /*
         CIA_SECURITY_CODE_MODE                     101     验证码模式, 显示输入验证码页面
         CIA_REQUEST_FAIL                           110     请求失败
         CIA_REQUEST_EXCEPTION                      111     请求异常
         */
        
        
        if (code == CIA_SECURITY_CODE_MODE) {
            
            // 验证码模式，进入验证码页面
            [self.navigationController pushViewController:[[SecurityCodeViewController alloc] init] animated:YES];
            
        } else {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    }];

}

#pragma mark -- 系统风火轮（小菊花）
- (void)showIndicator {
    
    _indicator.hidden = NO;
    [_indicator startAnimating];
    _registerButton.enabled = NO;
    
}

- (void)hideIndicator {
    
    [_indicator stopAnimating];
    _indicator.hidden = YES;
    _registerButton.enabled = YES;
    
}

/* 
    无论是mob， 还是CIA 因为iOS第三方权限安全限制，都需要用户手动录入，无法做到像安卓那样自动读取短信再通过正则截取到验证码然后返回给APP，所以只需要“善意”提醒用户接收到的信息提取（mob短信四位数字，CIA来电最后四位数）即可
 */





#pragma mark -- for in 找类，然后关掉键盘 收起键盘的5中方法：http://blog.csdn.net/w88193363/article/details/24423635
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (id subViwe in self.view.subviews) {
        
        if ([subViwe isKindOfClass:[UITextField class]]) {
            
            if (![subViwe isExclusiveTouch]) {
                
                [subViwe resignFirstResponder];
            }
        }
    }
}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}





@end




