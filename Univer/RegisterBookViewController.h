//
//  RegisterBookViewController.h
//  Univer
//
//  Created by 백 운천 on 12. 10. 3..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKeyboardToolbar.h"
#import "ZBarSDK.h"
#import "TouchXML.h"

@interface RegisterBookViewController : UIKeyboardToolbar<UIScrollViewDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, ZBarReaderDelegate, UINavigationBarDelegate>
{
    UIScrollView *scrollView;
    NSUserDefaults *userDefaults;
    
    UIButton *region_btn;
    UIButton *photo_btn;
    UIButton *uni_btn;
    UIButton *coll_btn;
    
    UILabel *regionLabel;
    UILabel *universityLabel;
    UILabel *collegeLabel;
    
    
    UIImage *image;
    
    UITextField *title_field;
    UITextField *publisher_field;
    UITextField *author_field;
    UITextField *created_field;
    UITextField *original_field;
    UITextField *discount_field;
    UITextView *content_view;
    
    UIImageView *parcel_check;
    UIImageView *meet_check;
    BOOL parcel_bool;
    BOOL meet_bool;
    
    UIButton *parcelBtn;
    UIButton *meetBtn;
    
    BOOL picker_bool;
    
    UIButton *purchaseBtn;
    UIButton *saleBtn;
    NSString *sell;
    
    UIActivityIndicatorView *spiner;
    UIAlertView *alert;
    
    NSDictionary *region_dic;
    NSDictionary *uni_dic;
    NSDictionary *coll_dic;
    
    //isbn
    NSString *isbn;
    NSMutableDictionary *isbnDic;
    
}

- (void)animateView:(UITextField *)object;

- (IBAction)photo_btn:(id)sender;

- (IBAction)region_btn:(id)sender;
- (IBAction)university_btn:(id)sender;
- (IBAction)college_btn:(id)sender;

- (IBAction)register_btn:(id)sender;




// isbn
- (IBAction)press_barcode:(id)sender;
- (void)start_rss;
- (void)isbnRSSFeed:(NSString *)feedAddress;
- (void)isbnAutoComplete;

- (IBAction)parcelBtn:(id)sender;
- (IBAction)meetBtn:(id)sender;


@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIButton *photo_btn;

@property (nonatomic, retain) IBOutlet UIButton *region_btn;
@property (nonatomic, retain) IBOutlet UIButton *uni_btn;
@property (nonatomic, retain) IBOutlet UIButton *coll_btn;

@property (nonatomic, retain) IBOutlet UITextField *title_field;
@property (nonatomic, retain) IBOutlet UITextField *publisher_field;
@property (nonatomic, retain) IBOutlet UITextField *author_field;
@property (nonatomic, retain) IBOutlet UITextField *created_field;
@property (nonatomic, retain) IBOutlet UITextField *original_field;
@property (nonatomic, retain) IBOutlet UITextField *discount_field;

@property (nonatomic, retain) IBOutlet UITextView *content_view;

@property (nonatomic, retain) IBOutlet UIButton *parcelBtn;
@property (nonatomic, retain) IBOutlet UIButton *meetBtn;



@property (nonatomic, retain) UIActivityIndicatorView *spiner;
@property (nonatomic, retain) UIAlertView *alert;

@end
