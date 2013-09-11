//
//  PhotoDetailViewController.h
//  Univer
//
//  Created by 백 운천 on 12. 10. 4..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDetailViewController : UIViewController
{
    UIImageView *imageView;
    UIImage *thumbnail;
    NSString *image_url;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) UIImage *thumbnail;
@property (nonatomic, retain) NSString *image_url;

@end