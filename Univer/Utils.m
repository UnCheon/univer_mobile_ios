//
//  Utils.m
//  Univer
//
//  Created by Baek UnCheon on 13. 9. 16..
//  Copyright (c) 2013년 백 운천. All rights reserved.
//

#import "Utils.h"

@implementation Utils
@synthesize categoryArray, regionArray, universityArray, collegeArray;
@synthesize delegate;

static Utils* _sharedUtils = nil;

+ (Utils*)sharedUtils
{
	@synchronized([Utils class])
	{
		if (!_sharedUtils)
			_sharedUtils = [[self alloc] init];
        
		return _sharedUtils;
	}
    
	return nil;
}

+ (id)alloc
{
	@synchronized([Utils class])
	{
		//NSAssert(_sharedUtils == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedUtils = [super alloc];
		return _sharedUtils;
	}
    
	return nil;
}



#pragma mark - Region, University, College

- (void)getCategoryList:(NSString *)category id:(NSString *)id
{
    NSString *urlString;
    if([category isEqualToString:@"region"])
        urlString = [NSString stringWithFormat:@"%s/region/", BASE_URL];
    else if ([category isEqualToString:@"university"])
        urlString = [NSString stringWithFormat:@"%s/university/region_id=%@/", BASE_URL, id];
    else if ([category isEqualToString:@"college"])
        urlString = [NSString stringWithFormat:@"%s/college/university_id=%@/", BASE_URL, id];

    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(getCategoryListDone:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request startAsynchronous];
}

- (void)getCategoryListDone:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    categoryArray = [jsonDic objectForKey:@"response"];
    
    
//    NSMutableDictionary *deserializedData = [responseString objectFromJSONString];
//    categoryArray = [[deserializedData objectForKey:@"response"] objectFromJSONData];
    
    
    
    if( delegate != nil ){
        
        [delegate didFinishLoadingCategoryDaya:categoryArray];
        
        
    }

}



- (void)getRegionList{
    NSString * urlString = [NSString stringWithFormat:@"%s/region/", BASE_URL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(getRegionListDone:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request startAsynchronous];
}

- (void)getRegionListDone:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    regionArray = [responseString objectFromJSONString];
}


- (void)getUniversityList{
    NSString * urlString = [NSString stringWithFormat:@"%s/university/", BASE_URL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(getUniversityListDone:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request startAsynchronous];
}

- (void)getUniversityListDone:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    universityArray = [responseString objectFromJSONString];
}

- (void)getCollegeList{
    NSString * urlString = [NSString stringWithFormat:@"%s/college/", BASE_URL];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(getCollegeListDone:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request startAsynchronous];
}

- (void)getCollegeListDone:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    collegeArray = [responseString objectFromJSONString];
}





@end
