//
//  ChangeViewController.h
//  Univer
//
//  Created by 백 운천 on 12. 10. 4..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeViewController : UIViewController
{
    NSDictionary *dic;
    UISegmentedControl *segment;
    int sale;
    UIImageView *saleImage;
    UIActivityIndicatorView *spiner;
    UIAlertView *alert;
    
    NSUserDefaults *userDefaults;

}

- (IBAction)segment_btn:(id)sender;
- (IBAction)delete_btn:(id)sender;

@property (nonatomic, retain) NSDictionary *dic;
@property (nonatomic, retain) UIAlertView *alert;
@property (nonatomic, retain) UIActivityIndicatorView *spiner;
@property (nonatomic, retain) IBOutlet UIImageView *saleImage;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segment;

@end
