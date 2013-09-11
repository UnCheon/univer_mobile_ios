//
//  SettingsViewController.h
//  Univer
//
//  Created by 백 운천 on 12. 10. 3..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

@interface SettingsViewController : UIViewController
{
    UITableView *uniTableView;
    NSUserDefaults *userDefaluts;
    
    UIAlertView *alert;
    UIActivityIndicatorView *spiner;
    
    
}

- (AppDelegate *)appDelegate;

@property (strong, nonatomic) UIAlertView *alert;
@property (strong, nonatomic) UIActivityIndicatorView *spiner;
@property (strong, nonatomic) IBOutlet UITableView *uniTableView;

@end
