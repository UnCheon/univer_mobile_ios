//
//  AddProfessorViewController.h
//  Univer
//
//  Created by 백 운천 on 12. 10. 9..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKeyboardToolbar.h"
#import <QuartzCore/QuartzCore.h>


@interface AddProfessorViewController : UIKeyboardToolbar <UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    
    UIAlertView *alert;
    UIActivityIndicatorView *spiner;
    
    NSUserDefaults *userDefaults;
    
    UIScrollView *uniScrollView;
    
    UIButton *regionBtn;
    UIButton *universityBtn;
    UIButton *collegeBtn;
    
    UILabel *regionLabel;
    UILabel *universityLabel;
    UILabel *collegeLabel;

    
    UITextField *titleField;
    
    NSMutableDictionary *regionDic;
    NSMutableDictionary *universityDic;
    NSMutableDictionary *collegeDic;
    
    UIImage *image;
    UIImageView *photoImageView;
}

- (IBAction)regionBtn:(id)sender;
- (IBAction)universityBtn:(id)sender;
- (IBAction)collegeBtn:(id)sender;
- (IBAction)photoBtn:(id)sender;
- (IBAction)registerBtn:(id)sender;


@property (nonatomic, retain) IBOutlet UIScrollView *uniScrollView;
@property (nonatomic, retain) IBOutlet UIButton *regionBtn;
@property (nonatomic, retain) IBOutlet UIButton *universityBtn;
@property (nonatomic, retain) IBOutlet UIButton *collegeBtn;

@property (nonatomic, retain) IBOutlet UITextField *titleField;

@property (nonatomic, retain) IBOutlet UIImageView *photoImageView;

@property (nonatomic, retain) IBOutlet UIAlertView *alert;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spiner;


@end
