//
//  CDataManager.h
//  Example
//
//  Created by Wooseok Seo on 13. 5. 22..
//  Copyright (c) 2013년 Find-Steve. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDataManager : NSObject
{
    NSMutableDictionary *data;
}


+ (CDataManager *)getDataManager;

@property (strong, nonatomic) NSMutableDictionary *data;


@end


/*
 
타 클레스에서 사용법
 
 CDataManager* manager = [CDataManager getDataManager];
 [manager.data setObject:@"kevin" forKey:@"name"];
 
 NSLog(@"Data : %@", [manager.data objectForKey:@"name"]);

 */