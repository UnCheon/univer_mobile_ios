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


- (void)didFinishLoadingCategoryDaya:(NSMutableArray *)feedArray;
- (void)didFinishLoadingRegionData:(NSMutableArray *)feedArray;
- (void)didFinishLoadingUniversityData:(NSMutableArray *)feedArray;
- (void)didFinishLoadingCollegeData:(NSMutableArray *)feedArray;

@end



@interface Utils : NSObject{
    id delegate;
    
    NSArray *regionArray;
    NSArray *universityArray;
    NSArray *collegeArray;
    NSMutableArray *categoryArray;
}

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) NSArray *regionArray;
@property (nonatomic, retain) NSArray *universityArray;
@property (nonatomic, retain) NSArray *collegeArray;
@property (nonatomic, retain) NSArray *categoryArray;

+ (Utils *)sharedUtils;
+ (id)alloc;
+ (id)init;

- (void)getRegionList;
- (void)getUniversityList:(int)regionId;
- (void)getCollegeList:(int)universityId;
- (void)getCategoryList:(NSString *)category id:(NSString *)id;







@end
