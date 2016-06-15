//
//  AppDelegate.h
//  LuoKiOS
//
//  Created by lkshine on 16/5/26.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController  * navigationController;
    BMKMapManager           * _mapManager;
}
@property (strong, nonatomic) UIWindow *window;


@end

