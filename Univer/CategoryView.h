//
//  CategoryView.h
//  Univer
//
//  Created by ucb on 12. 4. 10..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchXML.h"
#import "Utils.h"
#import "CDataManager.h"



@interface CategoryView : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate>
{
    NSMutableArray *category_array;
    NSString *address;
    int kinds;
    
    //루트로부터 데이터를 받을 변수
	NSDictionary *subData;
	//각 섹션에 해당하는 데이터
	NSMutableArray *sectionData;
	//인덱스 항목을 가지고 있을 변수
	NSArray *Index;
    NSMutableArray *index_array;
    
    NSMutableArray    *filteredListContent;
    
    UIActivityIndicatorView *spiner;
    UIAlertView *alert;
    
    NSString *category;
    NSString *id;
    
    NSDictionary *dic_;
    
    
}


- (void)reset;
- (void)start_rss;
- (NSString *)subtract:(NSString*)data;

- (void)categoryRSSFeed:(NSString *)categoryAddress;


@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *id;
@property (retain) NSDictionary *dic_;

@property (assign) id delegate;
@property (nonatomic, retain) NSString *address;
@property int kinds;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, retain) UIActivityIndicatorView *spiner;
@property (nonatomic, retain) UIAlertView *alert;

@end

