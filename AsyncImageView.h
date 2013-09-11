//
//  AsyncImageView.h
//  YellowJacket
//
//  Created by Wayne Cochran on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


//
// Code heavily lifted from here:
// http://www.markj.net/iphone-asynchronous-table-image/
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface AsyncImageView : UIView {
    NSURLConnection *connection;
    NSMutableData *data;
    NSString *urlString; // key for image cache dictionary
    
    UIImageView *imageView;
}

-(void)loadImageFromURL:(NSURL*)url;

@property (nonatomic, retain) UIImageView *imageView;
@end
