//
//  ChatRoomsViewController.h
//  Univer
//
//  Created by 백 운천 on 12. 10. 3..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchXML.h"


@interface ChatRoomsViewController : UIViewController 
{
    NSUserDefaults *userDefaults;

    NSMutableArray *uniArray;
    UITableView *uniTableView;
    UIButton *editBtn;
    
    int badgeCount;
    
    BOOL isParsing;
    
    NSString *today;
}

- (void)uniRSSFeed:(NSString *)feedAddress;
@property (nonatomic, retain) IBOutlet UITableView *uniTableView;
@property (strong) NSMutableArray *uniArray;

@end
