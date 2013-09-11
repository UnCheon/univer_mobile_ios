//
//  AppDelegate.h
//  Univer
//
//  Created by 백 운천 on 12. 10. 3..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    UIWindow *window;
    UITabBarController *tabbarController;
    
    NSUserDefaults *userDefaults;
    
    UINavigationController *loginNavi;
}

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet UITabBarController *tabbarController;

- (void)loginSuccess;
- (void)logoutSuccess;


@end
