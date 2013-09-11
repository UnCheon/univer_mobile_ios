//
//  BoardsViewController.h
//  Univer
//
//  Created by 백 운천 on 12. 10. 11..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchXML.h"
#import "ODRefreshControl.h"
#import "MHLazyTableImages.h"

@class MHLazyTableImages;



@interface BoardsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MHLazyTableImagesDelegate>
{
    NSUserDefaults *userDefaults;
    
    MHLazyTableImages* lazyImages;

    NSMutableArray *uniArray;
    NSMutableArray *updateArray;
    
    int page;
    
    UITableView *uniTableView;
    
    ODRefreshControl *refreshControl;
    
    UIActivityIndicatorView *footerSpiner;
    
    
    
    UIButton *regionBtn;
    UIButton *universityBtn;
    
    NSDictionary *region_dic;
    NSDictionary *uni_dic;
    
    UILabel *likeLabel;
    UILabel *commentLabel;
    
    UILabel *regionLabel;
    UILabel *universityLabel;
    
    
    NSString *year;

}

- (void)launch:(NSNotification *)notification;
- (void)uniRSSFeed:(NSString *)feedAddress;
- (void)threadStart;

- (IBAction)regionBtn:(id)sender;
- (IBAction)universityBtn:(id)sender;


@property (nonatomic, strong) IBOutlet UITableView *uniTableView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *footerSpiner;
@property (nonatomic, strong) IBOutlet UIButton *regionBtn;
@property (nonatomic, strong) IBOutlet UIButton *universityBtn;


@end
