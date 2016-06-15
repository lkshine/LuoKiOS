//
//  SecurityCodeViewController.m
//  CIA_Example
//
//  Created by baoyz-mac on 15/5/26.
//  Copyright (c) 2015年 ciaapp. All rights reserved.
//

#import "SecurityCodeViewController.h"
#import "CIA_SDK/CIA_SDK.h"

@interface SecurityCodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *codeText;

@end

@implementation SecurityCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"请输入验证码";
    
    [CIA getSecurityCode];
}

- (void)viewDidDisappear:(BOOL)animated {
    [CIA cancelVerification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextClick:(id)sender {
    // 校验验证码
    [CIA verifySecurityCode:_codeText.text callback:^(NSInteger code, NSString *msg, NSString *transId, NSError *err) {
        
        // 可能返回的code
        /*
         CIA_VERIFICATION_SUCCESS                   100     验证成功
         CIA_SECURITY_CODE_WRONG                    102     验证码输入错误
         CIA_SECURITY_CODE_EXPIRED                  103     验证码已经过期
         CIA_SECURITY_CODE_EXPIRED_INPUT_OVERRUN    104     验证码输入错误次数超过上限
         */
        
        
        NSLog(@"\n\t🚩\n _codeText.text = %@ \n\t📌", _codeText.text);
        
        
        if (CIA_VERIFICATION_SUCCESS == code) {
            // 验证成功
            [self alert:@"验证成功"];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        [self alert:msg];
    }];
}

- (void)alert:(NSString *)msg {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}


@end


