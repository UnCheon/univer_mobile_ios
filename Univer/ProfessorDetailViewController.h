//
//  ProfessorDetailViewController.h
//  Univer
//
//  Created by 백 운천 on 12. 10. 5..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "TouchXML.h"
#import "ODRefreshControl.h"
#import "DYRateView.h"


@interface ProfessorDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, HPGrowingTextViewDelegate, UIScrollViewDelegate>
{
    NSUserDefaults *userDefaults;
    
    UITableView *uniTableView;
    NSDictionary *professor_dic;
    UIImage *image;
    
    UIImage *thumbnailImage;
    
    ODRefreshControl *refreshControl;

    
    UIView *containerView;
    HPGrowingTextView *textView;
    
    NSMutableArray *uniArray;
    NSMutableArray *updateArray;
    
    UIAlertView *alert;
    UIActivityIndicatorView *spiner;
    
    int page;
    
    NSString *content;
    
    NSString *year;
    
    
    UIActivityIndicatorView *footerSpiner;
}

- (void)uniRSSFeed:(NSString *)feedAddress;
- (void)threadStart;


@property (nonatomic, strong) IBOutlet UITableView *uniTableView;
@property (strong) NSDictionary *professor_dic;
@property (strong) UIImage *image;

@property (nonatomic, strong) IBOutlet UIAlertView *alert;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *spiner;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *footerSpiner;

@end
