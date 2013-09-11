//
//  WriteEntryViewController.h
//  Univer
//
//  Created by 백 운천 on 12. 11. 2..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteEntryViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSUserDefaults *userDefaults;
    
    UINavigationBar *navigationBar;
    
    UIImageView *imageView;
    UIImage *image;
    
    UITextView *textView;
    
    UIButton *regionBtn;
    UIButton *universityBtn;
    
    
    NSDictionary *regionDic;
    NSDictionary *universityDic;
    
    UIActivityIndicatorView *spiner;
    UIAlertView *alert;
    
    UILabel *regionLabel;
    UILabel *universityLabel;
    

}


- (void)cancelBtn:(id)sender;
- (void)registerBtn:(id)sender;

- (IBAction)regionBtn:(id)sender;
- (IBAction)universityBtn:(id)sender;

- (IBAction)photoBtn:(id)sender;


@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UIButton *regionBtn;
@property (nonatomic, strong) IBOutlet UIButton *universityBtn;


@end
