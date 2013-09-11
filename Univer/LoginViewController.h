//
//  LoginViewController.h
//  Univer
//
//  Created by 백 운천 on 12. 10. 15..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

@interface LoginViewController : UIViewController
{
    UIAlertView *alert;
    UIActivityIndicatorView *spiner;
    
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *passwordField;
}
@property (strong, nonatomic) IBOutlet UITextField *emailField;

@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@property (strong, nonatomic) UIAlertView *alert;
@property (strong, nonatomic) UIActivityIndicatorView *spiner;


- (IBAction)loginBtn:(id)sender;
- (IBAction)registerBtn:(id)sender;

- (AppDelegate *)appDelegate;

@end
