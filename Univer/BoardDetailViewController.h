//
//  BoardDetailViewController.h
//  Univer
//
//  Created by 백 운천 on 12. 11. 2..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "TouchXML.h"
#import "ODRefreshControl.h"

@interface BoardDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, HPGrowingTextViewDelegate>
{
    NSUserDefaults *userDefaults;
    
    
    NSMutableArray *uniArray;
    NSMutableArray *updateArray;
    
    int page;
    int kinds;
    
    UITableView *uniTableView;
    
    ODRefreshControl *refreshControl;
    
    UIActivityIndicatorView *footerSpiner;
    
    HPGrowingTextView *textView;
    UIView *containerView;
    
    UIButton *regionBtn;
    UIButton *universityBtn;
    
    NSDictionary *region_dic;
    NSDictionary *uni_dic;
    
    NSString *content;
    
    UIAlertView *alert;
    UIActivityIndicatorView *spiner;
    
    NSString *year;

    UIImageView *imageDataView;
    
}

- (void)launch:(NSNotification *)notification;
- (void)uniRSSFeed:(NSString *)feedAddress;
- (void)threadStart;



@property (nonatomic, strong) UITableView *uniTableView;
@property (nonatomic, strong) UIAlertView *alert;
@property (nonatomic, strong) UIActivityIndicatorView *spiner;

@property (strong) UIImage *image;
@property (strong) NSDictionary *dic;

@property int kinds;

@end
