//
//  Utils.h
//  Univer
//
//  Created by Baek UnCheon on 13. 9. 16..
//  Copyright (c) 2013년 백 운천. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"

#define BASE_URL "http://www.rhinodream.com"

@protocol UtilsDelegate <NSObject>

// category
- (void)didFinishLoadingCategoryData:(NSMutableArray *)feedArray;

// book
- (void)didFinishLoadingBookData:(NSMutableArray *)feedArray;


@end



@interface Utils : NSObject{
    id delegate;
    
    NSMutableArray *categoryArray;
    
    NSMutableArray *bookArray;
}

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) NSMutableArray *categoryArray;

@property (nonatomic, retain) NSMutableArray *bookArray;

+ (Utils *)sharedUtils;
+ (id)alloc;
+ (id)init;

// category
- (void)getRegionList;
- (void)getUniversityList:(int)regionId;
- (void)getCollegeList:(int)universityId;
- (void)getCategoryList:(NSString *)category id:(NSString *)categoryId;
// book 
- (void)getBookList:(NSString *)sale category:(NSString *)category id:(NSString *)categoryId page:(NSString *)page;





@end
