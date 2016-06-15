//
//  AuthcodeView.h  --- 本地验证码（图形验证）
//  LuoKiOS
//
//  Created by lkshine on 16/6/9.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthcodeView : UIView

@property (strong, nonatomic) NSArray         * dataArray;  //字符素材数组
@property (strong, nonatomic) NSMutableString * authCodeStr;//验证码字符串

@end
