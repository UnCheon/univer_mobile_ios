//
//  BooksViewController.h
//  Univer
//
//  Created by 백 운천 on 12. 10. 3..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODRefreshControl.h"
#import "TouchXML.h"
#import "MHLazyTableImages.h"

@class MHLazyTableImages;




@interface BooksViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIActionSheetDelegate, UIScrollViewDelegate, MHLazyTableImagesDelegate>
{
    MHLazyTableImages *lazyImages;

    
    NSUserDefaults *userDefaults;
    
    UIView *headerView;
    ODRefreshControl *refreshControl;
    UITableView *uniTableView;
    NSMutableArray *uniArray;
    NSMutableArray *updateArray;
        
    UISegmentedControl *seg;
    NSString *sell_url;
    NSString *category_url;
    
    UIButton *segBtn1;
    UIButton *segBtn2;
    UIButton *segBtn3;

    UISearchBar *uniSearchBar;
    
    int page;
    int searchPage;
    
    BOOL is_search;
    BOOL is_segment;
    
    UIButton *regionBtn;
    UIButton *universityBtn;
    UIButton *collegeBtn;
    UIButton *majorBtn;
    
    UILabel *regionLabel;
    UILabel *universityLabel;
    UILabel *collegeLabel;
    
    
    NSDictionary *region_dic;
    NSDictionary *uni_dic;
    NSDictionary *coll_dic;
    
    UIButton *searchBackButton;
        
    
    UIActivityIndicatorView *footerSpiner;
    
    

}

- (void)uniRSSFeed:(NSString *)feedAddress;
- (void)registerBookBtn:(id)sender;

- (IBAction)regionBtn:(id)sender;
- (IBAction)universityBtn:(id)sender;
- (IBAction)collegeBtn:(id)sender;


- (void)segBtn:(UIButton *)btn;




@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) IBOutlet UITableView *uniTableView;

@property (nonatomic, retain) IBOutlet UISearchBar *uniSearchBar;

@property (nonatomic, retain) IBOutlet UIButton *regionBtn;
@property (nonatomic, retain) IBOutlet UIButton *universityBtn;
@property (nonatomic, retain) IBOutlet UIButton *collegeBtn;

@property (nonatomic, retain) UIButton *segBtn1;
@property (nonatomic, retain) UIButton *segBtn2;
@property (nonatomic, retain) UIButton *segBtn3;

@property (nonatomic, retain) IBOutlet UILabel *regionLabel;
@property (nonatomic, retain) IBOutlet UILabel *universityLabel;
@property (nonatomic, retain) IBOutlet UILabel *collegeLabel;


@property (nonatomic, strong) IBOutlet UIButton *searchBackButton;


@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *footerSpiner;



@end
