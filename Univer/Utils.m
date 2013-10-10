//
//  Utils.m
//  Univer
//
//  Created by Baek UnCheon on 13. 9. 16..
//  Copyright (c) 2013년 백 운천. All rights reserved.
//

#import "Utils.h"

@implementation Utils
@synthesize categoryArray;
@synthesize bookArray;
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

- (void)getCategoryList:(NSString *)category id:(NSString *)categoryId
{
    NSString *urlString;
    if([category isEqualToString:@"region"])
        urlString = [NSString stringWithFormat:@"%s/region/", BASE_URL];
    else if ([category isEqualToString:@"university"])
        urlString = [NSString stringWithFormat:@"%s/university/region_id=%@/", BASE_URL, categoryId];
    else if ([category isEqualToString:@"college"])
        urlString = [NSString stringWithFormat:@"%s/college/university_id=%@/", BASE_URL, categoryId];

    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(getCategoryListDone:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request startAsynchronous];
}

#pragma mark - Book List

- (void)getBookList:(NSString *)sale category:(NSString *)category id:(NSString *)categoryid page:(NSString *)page{
    
    NSString * urlString = [NSString stringWithFormat:@"%s/book/sale=%@&category=%@&id=%@&page=%@/", BASE_URL, sale,category, categoryid, page];
    NSLog(@"%@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(getBookListDone:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request startAsynchronous];
}


#pragma mark - Delegate
- (void)getCategoryListDone:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    categoryArray = [jsonDic objectForKey:@"response"];
    
    if( delegate != nil ){
        [delegate didFinishLoadingCategoryData:categoryArray];
    }
    
}



- (void)getBookListDone:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    bookArray = [jsonDic objectForKey:@"response"];
    NSLog(@"%@", bookArray);
    if( delegate != nil ){
        [delegate didFinishLoadingBookData:bookArray];
    }
}




@end
