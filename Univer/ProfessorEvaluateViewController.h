//
//  ProfessorEvaluateViewController.h
//  Univer
//
//  Created by 백 운천 on 12. 10. 5..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYRateView.h"
#import "UIKeyboardToolbar.h"

@interface ProfessorEvaluateViewController : UIKeyboardToolbar <DYRateViewDelegate, UITextViewDelegate, UIScrollViewDelegate>
{
    UIScrollView *uniScrollView;
    UITextView *textView;
    
    NSUserDefaults *userDefaults;
    
    NSString *quality_string;
    NSString *personality_string;
    NSString *report_string;
    NSString *grade_string;
    NSString *attendance_string;
    
    UIButton *likeBtn;
    UIButton *disLikeBtn;
    
    NSString *like;
    
    NSDictionary *professorDic;
    
    UIAlertView *alert;
    UIActivityIndicatorView *spiner;
}

@property (nonatomic, retain) IBOutlet UIScrollView *uniScrollView;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (retain) NSDictionary *professorDic;
@property (nonatomic, strong) UIAlertView *alert;
@property (nonatomic, strong) UIActivityIndicatorView *spiner;

- (IBAction)evaluate:(id)sender;
- (void)segmentBtn:(UIButton *)btn;


@end
