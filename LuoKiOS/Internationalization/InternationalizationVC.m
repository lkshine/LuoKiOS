//
//  InternationalizationVC.m
//  LuoKiOS
//
//  Created by lkshine on 16/7/19.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "InternationalizationVC.h"

#define AppLanguage @"appLanguage"

#define CustomLocalizedString(key, comment) \
[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:@"" table:nil]
//这里只是为了观看方便，正确的写法是写在PCH文件里，设置全局访问,Localizable.strings文件也应该规范化放到Supporting Files文件夹下

@interface InternationalizationVC ()

@property (weak, nonatomic) IBOutlet UILabel *blueLab;
@property (weak, nonatomic) IBOutlet UILabel *greenLab;
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;

@end

/*
 如何添加Localizbale.strings文件
 参考：http://my.oschina.net/leejan97/blog/284372
 */

@implementation InternationalizationVC


- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (IBAction)switchGlobalLanguageAction:(UIButton *)sender {
    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults]objectForKey:AppLanguage];
    if ([currentLanguage isEqualToString: @"en"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:AppLanguage];
    }else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:AppLanguage];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_switchBtn setTitle:CustomLocalizedString(@"switchBtn", nil) forState:UIControlStateNormal];
    [_blueLab setText:CustomLocalizedString(@"hello", nil)];
}//因为用的是全局AppLanguage，所以其他界面只需要依次CustomLocalizedString设置对应key就可以了

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end


