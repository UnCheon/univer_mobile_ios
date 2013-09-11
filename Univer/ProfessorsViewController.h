//
//  ProfessorsViewController.h
//  Univer
//
//  Created by 백 운천 on 12. 10. 3..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODRefreshControl.h"
#import "TouchXML.h"
#import "DYRateView.h"

#import "MHLazyTableImages.h"

@class MHLazyTableImages;


@interface ProfessorsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIActionSheetDelegate, UIScrollViewDelegate, MHLazyTableImagesDelegate>

{
    MHLazyTableImages *lazyImages;
    
    NSUserDefaults *userDefaults;

    UITableView *uniTableView;
    
    UIView *headerView;
    ODRefreshControl *refreshControl;
    UISearchBar *uniSearchBar;
    
    int page;
    int searchPage;
    BOOL is_search;
    
    UIButton *regionBtn;
    UIButton *universityBtn;
    UIButton *collegeBtn;
    
    UILabel *regionLabel;
    UILabel *universityLabel;
    UILabel *collegeLabel;
        
    NSDictionary *region_dic;
    NSDictionary *uni_dic;
    NSDictionary *coll_dic;

    NSMutableArray *uniArray;
    NSMutableArray *updateArray;
    
    UIActivityIndicatorView *footerSpiner;
    
    UIButton *searchBackButton;


}

- (void)uniRSSFeed:(NSString *)feedAddress;
- (IBAction)regionBtn:(id)sender;
- (IBAction)universityBtn:(id)sender;
- (IBAction)collegeBtn:(id)sender;
- (void)addProfessor:(id)sender;


@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UITableView *uniTableView;

@property (nonatomic, strong) IBOutlet UISearchBar *uniSearchBar;

@property (nonatomic, strong) IBOutlet UIButton *regionBtn;
@property (nonatomic, strong) IBOutlet UIButton *universityBtn;
@property (nonatomic, strong) IBOutlet UIButton *collegeBtn;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *footerSpiner;

@property (nonatomic, strong) IBOutlet UIButton *searchBackButton;
@end
