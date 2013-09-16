//
//  CDataManager.m
//  Example
//
//  Created by Wooseok Seo on 13. 5. 22..
//  Copyright (c) 2013년 Find-Steve. All rights reserved.
//

#import "CDataManager.h"

@implementation CDataManager

@synthesize data;

+ (CDataManager *)getDataManager
{
    static CDataManager *dataManager = nil;
    
    if(dataManager == nil)
    {
        @synchronized(self)
        {
            if(dataManager == nil)
            {
                dataManager = [[self alloc] init];
                dataManager.data = [[NSMutableDictionary alloc] init];
            }
        }
    }
    
    return dataManager;
}


@end
