//
//  SettingsViewController.m
//  Univer
//
//  Created by 백 운천 on 12. 10. 3..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import "SettingsViewController.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"


#define LOGOUT_URL                               @"http://54.249.52.26/logout/"

#define kCustomRowHeight  80.0
#define kCustomRowCount   7
#define kAppIconHeight    70



@implementation SettingsViewController
@synthesize alert, spiner, uniTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Settings";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"cm_navigation_background_2.jpg"] forBarMetrics:UIBarMetricsDefault];

    [super viewDidLoad];

    
    userDefaluts = [NSUserDefaults standardUserDefaults];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma - TableView cycle

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 17;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = @"로그아웃";
    
    return cell;
}

#pragma mark -
#pragma mark MHLazyTableImagesDelegate

- (NSURL*)lazyImageURLForIndexPath:(NSIndexPath*)indexPath
{
	return [NSURL URLWithString:@"http://54.248.233.34/media/documents/2012/11/24/photo.50x50.jpg"];
}

- (UIImage*)postProcessLazyImage:(UIImage*)image forIndexPath:(NSIndexPath*)indexPath
{
    if (image.size.width != kAppIconHeight && image.size.height != kAppIconHeight)
	{
        CGSize itemSize = CGSizeMake(kAppIconHeight, kAppIconHeight);
		UIGraphicsBeginImageContextWithOptions(itemSize, YES, 0);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return newImage;
    }
    else
    {
        return image;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    [userDefaluts removeObjectForKey:@"username"];
    [userDefaluts removeObjectForKey:@"password"];
    [[self appDelegate] logoutSuccess];
     */

//    alert = [[UIAlertView alloc] initWithTitle:@"잠시만 기다려 주세요.." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//    [alert show];
//    
//    spiner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    spiner.center = CGPointMake(alert.bounds.size.width/2, alert.bounds.size.height/2+10);
//    [spiner startAnimating];
//    [alert addSubview:spiner];
//
// 
//    NSURL *url = [NSURL URLWithString:LOGOUT_URL];
//    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
//    
//    [request setRequestMethod:@"POST"];
//    [request setPostFormat:ASIMultipartFormDataPostFormat];
//    [request setShouldContinueWhenAppEntersBackground:YES];
//    [request setDelegate:self];
//    [request startAsynchronous];
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];

    
    NSString *result = [request responseString];
    NSLog(@"%@", result);
    if ([result intValue] == 200) {
        [userDefaluts removeObjectForKey:@"username"];
        [userDefaluts removeObjectForKey:@"password"];
        [[self appDelegate] logoutSuccess];
        

    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"로그아웃" message:result delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    //    NSError *error = [request error];
    [alert dismissWithClickedButtonIndex:0 animated:YES];

    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"로그아웃" message:@"네트워크상태를 확인하세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [myAlert show];
}


- (AppDelegate *)appDelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}





@end
