//
//  RegisterViewController.h
//  Univer
//
//  Created by 백 운천 on 12. 10. 15..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
{
    NSUserDefaults *userDefaults;
    
    IBOutlet UIButton *regionBtn;
    IBOutlet UIButton *universityBtn;
    IBOutlet UIButton *collegeBtn;
    
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *nicknameField;
    
    IBOutlet UITextField *password1Field;
    
    IBOutlet UITextField *password2Field;
    
    NSDictionary *region_dic;
    NSDictionary *uni_dic;
    NSDictionary *coll_dic;
    
    UIAlertView *alert;
    UIActivityIndicatorView *spiner;

}

@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *nicknameField;
@property (strong, nonatomic) IBOutlet UITextField *password1Field;
@property (strong, nonatomic) IBOutlet UITextField *password2Field;

@property (strong, nonatomic) UIAlertView *alert;
@property (strong, nonatomic) UIActivityIndicatorView *spiner;




@property (strong, nonatomic) IBOutlet UIButton *regionBtn;
@property (strong, nonatomic) IBOutlet UIButton *universityBtn;
@property (strong, nonatomic) IBOutlet UIButton *collegeBtn;

- (IBAction)regionBtn:(id)sender;
- (IBAction)universityBtn:(id)sender;
- (IBAction)collegeBtn:(id)sender;


@end
