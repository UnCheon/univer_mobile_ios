//
//  BookDetailViewController.h
//  Univer
//
//  Created by 백 운천 on 12. 10. 4..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchXML.h"
#import "MHLazyTableImages.h"
#import "Utils.h"

@class MHLazyTableImages;

@interface BookDetailViewController : UIViewController<MHLazyTableImagesDelegate>
{
    
    MHLazyTableImages *lazyImages;

    UITableView *bookTableView;
    NSString *seller_id;
    NSString *seller_nick;
    NSString *entriesAddress;
    UIImage *image;
    NSDictionary *dic;
    
    int page;
    
    BOOL isParse;
    
    NSMutableArray *entriesArray;
    
    NSUserDefaults *userDefaults;
    
    UIToolbar *toolbar;
    
    UIActivityIndicatorView *spiner;
    UIAlertView *alert;

    int sale;

    UISegmentedControl *segment;
    
    UIImageView *saleImage;

}

- (void)entriesRSSFeed:(NSString *)entriesAddress;


- (void)photo_btn:(id)sender;
- (void)chat_btn:(id)sender;

- (IBAction)segment_btn:(id)sender;
- (IBAction)delete_btn:(id)sender;


@property (nonatomic, retain) UIAlertView *alert;
@property (nonatomic, retain) UIActivityIndicatorView *spiner;

@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) IBOutlet UITableView *bookTableView;
@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;

@property (nonatomic, strong) IBOutlet UISegmentedControl *segment;
@end
