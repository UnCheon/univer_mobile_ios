//
//  CustomTabbarController.h
//  Uni
//
//  Created by 백 운천 on 12. 9. 26..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKNumberBadgeView.h"



@interface CustomTabbarController : UITabBarController
{
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    UIButton *btn4;
    UIButton *btn5;
    
    MKNumberBadgeView *chatBadge;
}

@property (nonatomic, retain) UIButton *btn1;
@property (nonatomic, retain) UIButton *btn2;
@property (nonatomic, retain) UIButton *btn3;
@property (nonatomic, retain) UIButton *btn4;
@property (nonatomic, retain) UIButton *btn5;
@property (nonatomic, strong) MKNumberBadgeView *chatBadge;

- (void)hideExistingTabBar;
- (void)addCustomElements;
- (void)selectTab:(int)tabID;

- (void)hideNewTabbar;
- (void)showNewTabbar;

- (UIColor *) myRGBfromHex: (NSString *) code;


- (void)tabbarBadge:(int)badgeCount;

@end
