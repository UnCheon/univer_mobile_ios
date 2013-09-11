//
//  ChangeViewController.m
//  Univer
//
//  Created by 백 운천 on 12. 10. 4..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import "ChangeViewController.h"

#import "PhotoDetailViewController.h"
#import "ChatViewController.h"
#import "AsyncImageView.h"
#import "ASIFormDataRequest.h"
#import "CustomTabbarController.h"

#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f


#define BOOK_URL                               @"http://54.249.52.26/books/"
#define EDIT_BOOK_URL                               @"http://54.249.52.26/edit_books/"
#define DELETE_BOOK_URL                               @"http://54.249.52.26/delete_books/"
#define THUMBNAIL_URL                               @"http://54.249.52.26"

@implementation ChangeViewController
@synthesize dic, segment, spiner, saleImage, alert;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 31, 44)];
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame =CGRectMake(0, 7, 31, 31);
        [btn1 setBackgroundImage:[UIImage imageNamed:@"cm_back_selected.png"] forState:UIControlStateHighlighted];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"cm_back_unselected.png"] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
        [leftView addSubview:btn1];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
        self.navigationItem.leftBarButtonItem = leftItem;
        
        // Custom initialization
    }
    return self;
}

- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"cm_navigation_background_2.jpg"] forBarMetrics:UIBarMetricsDefault];

    [(CustomTabbarController *)self.tabBarController hideNewTabbar];

    
    
    userDefaults = [NSUserDefaults standardUserDefaults];


    [super viewDidLoad];
    sale = [[dic objectForKey:@"sale"] intValue];
    if(sale == 2){
        saleImage.hidden = NO;
        saleImage.image = [UIImage imageNamed:@"reserved.png"];
        [segment setSelectedSegmentIndex:1];
    }else if(sale == 3){
        saleImage.hidden = NO;
        saleImage.image = [UIImage imageNamed:@"soldout.png"];
        [segment setSelectedSegmentIndex:2];
    }else
    {
        saleImage.hidden = YES;
        [segment setSelectedSegmentIndex:0];
    }
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [(CustomTabbarController *)self.tabBarController showNewTabbar];
    [super viewWillDisappear:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.spiner = nil;
    self.segment = nil;
    self.saleImage = nil;
    self.dic = nil;
    self.alert = nil;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma - TableView cycle


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"상세보기";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    UITableViewCell *cell1 = nil;
    UITableViewCell *cell2 = nil;
    UITableViewCell *cell3 = nil;
    
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier1 = @"Cell1";
    static NSString *CellIdentifier2 = @"Cell2";
    static NSString *CellIdentifier3 = @"Cell3";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    cell3 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"Cell1" owner:self options:nil];
    if (cell == nil) {
        cell = (UITableViewCell *)[topLevelObjects objectAtIndex:0];
    }
    if (cell1 == nil) {
        cell1 = (UITableViewCell *)[topLevelObjects objectAtIndex:1];
    }
    if (cell2 == nil) {
        cell2 = (UITableViewCell *)[topLevelObjects objectAtIndex:2];
    }
    if (cell3 == nil) {
        cell3 = (UITableViewCell *)[topLevelObjects objectAtIndex:3];
    }
    
    
    if (indexPath.section == 0) {
        UILabel *label;
        if (indexPath.row == 0) {
            
            
            CGRect frame = CGRectMake(15, 5, 85, 85);
            
            if ([[dic objectForKey:@"thumbnail"] isEqualToString:@""]) {
                UIImageView *noImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noimage.png"]];
                noImageView.frame = frame;
                [cell addSubview:noImageView];
            }else{
                AsyncImageView* asyncImage = [[AsyncImageView alloc] initWithFrame:frame];
                asyncImage.tag = 999;
                
                NSString *url_string = [THUMBNAIL_URL stringByAppendingString:[dic objectForKey:@"thumbnail"]];
                NSURL *aURL = [NSURL URLWithString:url_string];
                [asyncImage loadImageFromURL:aURL];
                
                [cell addSubview:asyncImage];
            }
            
            label = (UILabel *)[cell viewWithTag:1];
            NSString *original_price = [dic objectForKey:@"original_price"];
            label.text = [original_price stringByAppendingString:@"원"];
            label = (UILabel *)[cell viewWithTag:2];
            NSString *discount_price = [dic objectForKey:@"discount_price"];
            label.text = [discount_price stringByAppendingString:@"원"];
            
            UIButton *chat_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            chat_btn.frame = CGRectMake(214, 14, 40, 34);
            [chat_btn setImage:[UIImage imageNamed:@"chat.png"] forState:UIControlStateNormal];
            [chat_btn setImage:[UIImage imageNamed:@"chat_click.png"] forState:UIControlStateSelected];
            [cell addSubview:chat_btn];
            return cell;
        }else if (indexPath.row ==1){
            label = (UILabel *)[cell1 viewWithTag:3];
            label.numberOfLines = 0;
            label.lineBreakMode = UILineBreakModeWordWrap;
            label.text = [dic objectForKey:@"title"];
            label = (UILabel *)[cell1 viewWithTag:9];
            if ([[dic objectForKey:@"sell"] isEqualToString:@"1"]) {
                label.text = @"팝니다";
                label.backgroundColor = [UIColor blueColor];
            }else
            {
                label.text = @"삽니다";
                label.backgroundColor = [UIColor yellowColor];
            }
            label = (UILabel *)[cell1 viewWithTag:10];
            if ([[dic objectForKey:@"parcel"] isEqualToString:@"0"])
                label.hidden = YES;
            else
                label.hidden = NO;
            
            label = (UILabel *)[cell1 viewWithTag:11];
            if ([[dic objectForKey:@"meet"] isEqualToString:@"0"])
                label.hidden = YES;
            else
                label.hidden = NO;
            
            return cell1;
        }else if (indexPath.row ==2){
            label = (UILabel *)[cell2 viewWithTag:4];
            label.text = [dic objectForKey:@"publisher"];
            label = (UILabel *)[cell2 viewWithTag:5];
            label.text = [dic objectForKey:@"book_author"];
            label = (UILabel *)[cell2 viewWithTag:6];
            NSString *edition = [dic objectForKey:@"edition"];
            label.text = [edition stringByAppendingString:@"판"];
            label = (UILabel *)[cell2 viewWithTag:7];
            label.text = [dic objectForKey:@"published"];
            return cell2;
        }else if (indexPath.row ==3){
            label = (UILabel *)[cell3 viewWithTag:8];
            label.numberOfLines = 0;
            label.lineBreakMode = UILineBreakModeWordWrap;
            label.font = [UIFont systemFontOfSize:14.0];
            label.text = [dic objectForKey:@"description"];
            return cell3;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
            return 95;
        else if (indexPath.row == 1) {
            NSString *text = [dic objectForKey:@"title"];
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:20.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            CGFloat height = MAX(size.height, 44.0f);
            return height + (CELL_CONTENT_MARGIN * 2)-20 +30;
        }else if (indexPath.row == 2){
            return 112;
        }else if (indexPath.row == 3){
            NSString *text = [dic objectForKey:@"description"];
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            CGFloat height = MAX(size.height, 44.0f);
            return height + (CELL_CONTENT_MARGIN * 2) + 25;
        }
    }
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - Detail Button

- (void)chat_btn:(id)sender
{
    
}



- (IBAction)segment_btn:(id)sender
{
    sale = [segment selectedSegmentIndex]+1;
    NSString *sale_ = [NSString stringWithFormat:@"%d", sale];
    
    NSURL *url = [[NSURL alloc] initWithString:EDIT_BOOK_URL];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.tag = 1;
    [request setRequestMethod:@"POST"];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request setShouldContinueWhenAppEntersBackground:YES];
    [request setPostValue:sale_ forKey:@"sale"];
    [request setPostValue:[dic objectForKey:@"id"] forKey:@"id"];
    [request setPostValue:[userDefaults objectForKey:@"user_id"] forKey:@"user_id"];
    [request setPostValue:[userDefaults objectForKey:@"value"] forKey:@"value"];
    [request setDelegate:self];
    alert = [[UIAlertView alloc] initWithTitle:@"잠시만 기다려 주세요.." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    
    spiner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spiner.center = CGPointMake(alert.bounds.size.width/2, alert.bounds.size.height/2+10);
    [spiner startAnimating];
    [alert addSubview:spiner];
    
    [request startAsynchronous];
}

- (IBAction)delete_btn:(id)sender
{
    NSURL *url = [[NSURL alloc] initWithString:DELETE_BOOK_URL];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.tag = 2;
    [request setRequestMethod:@"POST"];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request setShouldContinueWhenAppEntersBackground:YES];
    [request setPostValue:[dic objectForKey:@"id"] forKey:@"id"];
    [request setPostValue:[userDefaults objectForKey:@"user_id"] forKey:@"user_id"];
    [request setPostValue:[userDefaults objectForKey:@"value"] forKey:@"value"];    
    [request setDelegate:self];
    alert = [[UIAlertView alloc] initWithTitle:@"잠시만 기다려 주세요.." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    
    spiner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spiner.center = CGPointMake(alert.bounds.size.width/2, alert.bounds.size.height/2+10);
    [spiner startAnimating];
    [alert addSubview:spiner];
    
    [request startAsynchronous];
    
}




- (void)requestFinished:(ASIHTTPRequest *)request
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    int result = [[request responseString] intValue];
    
    if (result == 200) {
        [userDefaults setInteger:1 forKey:@"my"];
        if (request.tag == 1) {
            if (sale == 1) {
                saleImage.hidden = YES;
            }else if(sale == 2){
                saleImage.hidden = NO;
                saleImage.image = [UIImage imageNamed:@"reserved.png"];
            }else if(sale == 3){
                saleImage.hidden = NO;
                saleImage.image = [UIImage imageNamed:@"soldout.png"];
                
            }
            
        }else if(request.tag == 2){
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[request responseString] delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        NSLog(@"%@", [request responseString]);
    }
    
    
    //    NSData *responseData = [request responseData];
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    //    NSError *error = [request error];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"3g, wifi상태를 확인해보시기 바랍니다."  message:nil delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [myAlert show];
}

@end