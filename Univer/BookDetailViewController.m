//
//  BookDetailViewController.m
//  Univer
//
//  Created by 백 운천 on 12. 10. 4..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import "BookDetailViewController.h"
#import "ChatViewController.h"
#import "PhotoDetailViewController.h"
#import "CustomCell.h"
#import "CustomTabbarController.h"


#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f


#define FEED_BOOKS                            @"http://54.249.52.26/feeds/books/"
#define IMAGE_BASE                            @"http://54.249.52.26"

#define EDIT_BOOK_URL                               @"http://54.249.52.26/edit_books/"
#define DELETE_BOOK_URL                               @"http://54.249.52.26/delete_books/"
#define THUMBNAIL_URL                               @"http://54.249.52.26"



#define kCustomRowHeight  60.0
#define kCustomRowCount   7
#define kAppIconHeight    60


@implementation BookDetailViewController
@synthesize bookTableView;
@synthesize dic, image;
@synthesize toolbar;
@synthesize alert, spiner;
@synthesize segment;


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

        
        lazyImages = [[MHLazyTableImages alloc] init];
		lazyImages.placeholderImage = [UIImage imageNamed:@"bk_book.png"];
		lazyImages.delegate = self;

        isParse = NO;
    }
    return self;
}

- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"cm_navigation_background_2.jpg"] forBarMetrics:UIBarMetricsDefault];
    
    UIImage *repeatingImage = [UIImage imageNamed:@"cm_background_pattern.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:repeatingImage];


    lazyImages.tableView = self.bookTableView;

    
    [super viewDidLoad];
    self.title = [dic objectForKey:@"title"];
    entriesArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    [NSThread detachNewThreadSelector:@selector(start_rss) toTarget:self withObject:nil];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([[dic objectForKey:@"seller_id"] isEqualToString:[userDefaults objectForKey:@"user_id"]]) {
            [(CustomTabbarController *)self.tabBarController hideNewTabbar];
        [self.view addSubview:toolbar];
        toolbar.frame = CGRectMake(0, self.view.frame.size.height-toolbar.frame.size.height, 320, toolbar.frame.size.height);
        
        NSLog(@"my !!! ");
    }else{
        NSLog(@" you you ");
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadChatRoom" object:self];
    [super viewDidAppear:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [(CustomTabbarController *)self.tabBarController showNewTabbar];
    [super viewWillDisappear:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.bookTableView = nil;
    self.dic = nil;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)back_btn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - TableView cycle


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"";
    else
        return @"판매자의 다른상품 보기";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 3;
    else
        return [entriesArray count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomCell *cell = nil;
    UITableViewCell *cell1 = nil;
    UITableViewCell *cell2 = nil;
    CustomCell *cell4 = nil;
    
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier1 = @"Cell1";
    static NSString *CellIdentifier2 = @"Cell2";
    static NSString *CellIdentifier4 = @"Cell4";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    cell4 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4];
    
    UIImageView *cellBackgroundView;
    UIImageView *backgroundView;
    UILabel *titleLabel;
    UILabel *categoryLabel;
    UILabel *priceLabel;
    UIImageView *parcelImageView;
    UIImageView *meetImageView;
//    UIImageView *noImageView;
//    AsyncImageView *asyncImageView;

    
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
    }
    if (cell1 == nil) {
        cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
    }	
    if (cell2 == nil) {
        cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        cell2.backgroundColor = [UIColor whiteColor];
    }
    if (cell4 == nil) {
        cell4 = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier4];
        cell4.backgroundColor = [UIColor whiteColor];
//        cellBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
//        cellBackgroundView.image = [UIImage imageNamed:@"bk_normal.jpg"];
        
        backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(144, 0, 166, 80)];
        
//        noImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 8, 60, 60)];
//        noImageView.image = [UIImage imageNamed:@"bk_book.png"];
//        
//        asyncImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(16, 8, 60, 60)];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(87, 7, 220, 21)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];
        
        
        categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(87, 27, 240, 21)];
        categoryLabel.backgroundColor = [UIColor clearColor];
        categoryLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:14];
        categoryLabel.textColor = [UIColor grayColor];
        
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(205, 55, 100, 21)];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:14];
        priceLabel.textColor = [UIColor colorWithRed:0.376471 green:0.666667 blue:0.760784 alpha:1];
        
        parcelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(87, 55, 44, 20)];
        meetImageView = [[UIImageView alloc] initWithFrame:CGRectMake(142, 55, 44, 20)];
        
        [cell4 addSubview:cellBackgroundView];
        
        [cell4 addSubview:titleLabel];
        [cell4 addSubview:categoryLabel];
        [cell4 addSubview:priceLabel];
        [cell4 addSubview:parcelImageView];
        [cell4 addSubview:meetImageView];

    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (image) {
                cell.imageView.image = image;
            }
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 10, 250, 40)];
            titleLabel.text = [dic objectForKey:@"title"];
            titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
            titleLabel.numberOfLines = 0;

            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];

            [cell addSubview:titleLabel];
            
            
            UIButton *image_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            image_btn.frame = CGRectMake(10, 10, 60, 60);
            [image_btn addTarget:self action:@selector(photo_btn:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:image_btn];
            
            
            UILabel *originalLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 60, 100, 20)];
            originalLabel.text = [NSString stringWithFormat:@"%@원", [dic objectForKey:@"original_price"]];
            originalLabel.backgroundColor = [UIColor clearColor];
            originalLabel.font = [UIFont fontWithName:@"NanumGothic" size:13];
            originalLabel.textAlignment = UITextAlignmentLeft;
            
            UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redline79.png"]];
            lineImageView.frame = CGRectMake(originalLabel.frame.origin.x, originalLabel.frame.origin.y+10, 45, 2);

            [cell addSubview:originalLabel];
            [cell addSubview:lineImageView];
            
            UILabel *discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(152, 60, 100, 20)];
            discountLabel.text = [NSString stringWithFormat:@"%@원", [dic objectForKey:@"discount_price"]];
            discountLabel.backgroundColor = [UIColor clearColor];
            discountLabel.textAlignment = UITextAlignmentLeft;

            discountLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:16];
            discountLabel.textColor = [UIColor colorWithRed:0.376471 green:0.666667 blue:0.760784 alpha:1];
            
            [cell addSubview:discountLabel];
            
            
            UIButton *chat_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            chat_btn.frame = CGRectMake(240, 55, 60, 60);
            [chat_btn setImage:[UIImage imageNamed:@"bk_dt_talk_unselected.png"] forState:UIControlStateNormal];
            [chat_btn setImage:[UIImage imageNamed:@"bk_dt_talk_selected.png"] forState:UIControlStateHighlighted];
            [chat_btn addTarget:self action:@selector(chat_btn:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:chat_btn];
            
            
            UIImageView *parcelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(92, 95, 44, 20)];
            
            UIImageView *meetImageView = [[UIImageView alloc] initWithFrame:CGRectMake(147, 95, 44, 20)];

            if ([[dic objectForKey:@"parcel"] isEqualToString:@"0"])
                parcelImageView.image = [UIImage imageNamed:@"bk_parcel_false.png"];
            else
                parcelImageView.image = [UIImage imageNamed:@"bk_parcel_true.png"];
            
            if ([[dic objectForKey:@"meet"] isEqualToString:@"0"])
                meetImageView.image = [UIImage imageNamed:@"bk_meet_false.png"];
            else
                meetImageView.image = [UIImage imageNamed:@"bk_meet_true.png"];

            [cell addSubview:parcelImageView];
            [cell addSubview:meetImageView];
            
            return cell;
            
        }else if (indexPath.row ==1){
            UILabel *publisherLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 17, 50, 20)];
            publisherLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];
            publisherLabel.text = @"출판사";
            publisherLabel.backgroundColor = [UIColor clearColor];
            [cell1 addSubview:publisherLabel];
            
            UILabel *publisher = [[UILabel alloc] initWithFrame:CGRectMake(100, 17, 200, 20)];
            publisher.font = [UIFont fontWithName:@"NanumGothic" size:15];
            publisherLabel.textAlignment = UITextAlignmentLeft;
            publisher.text = [dic objectForKey:@"publisher"];
            publisher.backgroundColor = [UIColor clearColor];
            [cell1 addSubview:publisher];
            
            
            
            UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 40, 50, 20)];
            authorLabel.backgroundColor = [UIColor clearColor];
            authorLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];
            authorLabel.text = @"저  자";
            [cell1 addSubview:authorLabel];
            
            UILabel *author = [[UILabel alloc] initWithFrame:CGRectMake(100, 40, 200, 20)];
            author.backgroundColor = [UIColor clearColor];
            author.font = [UIFont fontWithName:@"NanumGothic" size:15];
            author.text =[dic objectForKey:@"book_author"];
            [cell1 addSubview:author];
            
            
            UILabel *publishedLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 63, 50, 20)];
            publishedLabel.backgroundColor = [UIColor clearColor];
            publishedLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];
            publishedLabel.text = @"발행일";
            [cell1 addSubview:publishedLabel];

            UILabel *published = [[UILabel alloc] initWithFrame:CGRectMake(100, 63, 200, 20)];
            published.backgroundColor = [UIColor clearColor];
            published.font = [UIFont fontWithName:@"NanumGothic" size:15];
            published.text = [dic objectForKey:@"published"];
            [cell1 addSubview:published];
            
            return cell1;
            
            

        }else if (indexPath.row ==2){
                
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 17, 260, 30)];
            contentLabel.lineBreakMode = UILineBreakModeTailTruncation;
            contentLabel.numberOfLines = 0;
            contentLabel.backgroundColor = [UIColor clearColor];
            contentLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];
            contentLabel.text = [dic objectForKey:@"description"];
            [cell2 addSubview:contentLabel];

            return cell2;
            }
    }else{
        
        
        NSDictionary *dic_ = [entriesArray objectAtIndex:indexPath.row];
        
        
        titleLabel.text = [dic_ objectForKey:@"title"];
        
        NSString *categoryString = [[dic_ objectForKey:@"region"] stringByAppendingFormat:@" / %@ / %@", [dic_ objectForKey:@"university"], [dic_ objectForKey:@"college"]];
        categoryLabel.text = categoryString;
        
        priceLabel.text = [NSString stringWithFormat:@"%@원", [dic_ objectForKey:@"discount_price"]];
        
        
        if ([[dic_ objectForKey:@"parcel"] isEqualToString:@"0"])
            parcelImageView.image = [UIImage imageNamed:@"bk_parcel_false.png"];
        else
            parcelImageView.image = [UIImage imageNamed:@"bk_parcel_true.png"];
        
        if ([[dic_ objectForKey:@"meet"] isEqualToString:@"0"])
            meetImageView.image = [UIImage imageNamed:@"bk_meet_false.png"];
        else
            meetImageView.image = [UIImage imageNamed:@"bk_meet_true.png"];
        
    	
//        if ([[dic_ objectForKey:@"thumbnail"] isEqualToString:@""]) {
//            [cell4 addSubview:noImageView];
//        }else{
//            NSString *url_string = [IMAGE_BASE stringByAppendingString:[dic_ objectForKey:@"thumbnail"]];
//            NSURL *aURL = [NSURL URLWithString:url_string];
//            [asyncImageView loadImageFromURL:aURL];
//            [cell4 addSubview:asyncImageView];
//        }
        
        
        int sale = [[dic_ objectForKey:@"sale"] intValue];
        
        if(sale == 2){
            backgroundView.image = [UIImage imageNamed:@"bk_reserved.png"];
            [cell4 addSubview:backgroundView];
        }else if(sale == 3){
            backgroundView.image = [UIImage imageNamed:@"bk_soldout.png"];
            [cell4 addSubview:backgroundView];
        }
        
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(170, 1, 60, 20)];
        la.text = [NSString stringWithFormat:@"%d번", indexPath.row];
        //    [cell add Subview:la];
        [lazyImages addLazyImageForCell:cell4 withIndexPath:indexPath];

        
        return cell4;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
            return 125;
        else if (indexPath.row == 1) {
            NSString *text = [dic objectForKey:@"title"];
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:20.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            CGFloat height = MAX(size.height, 44.0f);
//            return height + (CELL_CONTENT_MARGIN * 2)-20 +30;
            return 105;
        }else if (indexPath.row == 2){
            NSString *text = [dic objectForKey:@"title"];
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:20.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            CGFloat height = MAX(size.height, 44.0f);
            return height + (CELL_CONTENT_MARGIN * 2)-20 +30;

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


#pragma mark -
#pragma mark MHLazyTableImagesDelegate

- (NSURL*)lazyImageURLForIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 1) {
        NSDictionary *dic1 = [entriesArray objectAtIndex:indexPath.row];
        NSString *url_string = [IMAGE_BASE stringByAppendingString:[dic1 objectForKey:@"thumbnail"]];
        return [NSURL URLWithString:url_string];
    }else{
        NSString *url_string = [IMAGE_BASE stringByAppendingString:[dic objectForKey:@"thumbnail"]];
        return [NSURL URLWithString:url_string];
    }
}

- (UIImage*)postProcessLazyImage:(UIImage*)image_ forIndexPath:(NSIndexPath*)indexPath
{
    if (image_.size.width != kAppIconHeight && image_.size.height != kAppIconHeight)
	{
        CGSize itemSize = CGSizeMake(kAppIconHeight, kAppIconHeight);
		UIGraphicsBeginImageContextWithOptions(itemSize, YES, 0);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image_ drawInRect:imageRect];
		UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return newImage;
    }
    else
    {
        return image_;
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate


- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{    
	[lazyImages scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate
{
	[lazyImages scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

#pragma mark - Detail Button

- (void)photo_btn:(id)sender
{
    
    PhotoDetailViewController *photoDetailView = [[PhotoDetailViewController alloc] initWithNibName:@"PhotoDetailViewController" bundle:nil];
    photoDetailView.thumbnail = image;
    photoDetailView.image_url = [dic objectForKey:@"image"];
    [self.navigationController pushViewController:photoDetailView animated:YES];
}

- (void)chat_btn:(id)sender
{

    if ([[userDefaults objectForKey:@"user_id"] isEqualToString:[dic objectForKey:@"seller_id"]]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"채팅하기" message:@"본인과 대화할 수는 없습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        
        return;
    }


    
    
    ChatViewController *chatView = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
//    [(CustomTabbarController *)self.tabBarController hideNewTabbar];
    chatView.hidesBottomBarWhenPushed = YES;
    
    NSLog(@"%@", dic);
    
    chatView.to_id = [dic objectForKey:@"seller_id"];
    chatView.to_nick = [dic objectForKey:@"seller_nick"];
    chatView.kinds = 1;
    
    NSLog(@"id %@ nick %@", [dic objectForKey:@"seller_id"], [dic objectForKey:@"seller_nick"]);
    
    [self.navigationController pushViewController:chatView animated:YES];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected");
    if (indexPath.section == 1) {
        self.dic = [entriesArray objectAtIndex:indexPath.row];
        [self.bookTableView reloadData];
        [self.bookTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

#pragma mark - RSSFeed

- (void)entriesRSSFeed:(NSString *)address
{
	[entriesArray removeAllObjects];
    
    NSURL *url = [NSURL URLWithString:address];
	
	NSError *error = nil;
    CXMLDocument *rssParser = [[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:&error];
    
    if (error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"판매자의 다른물품 보기" message:@"네트워크상태를 확인하세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        return;
    }
    
    
    NSArray *resultNodes = NULL;
    
    resultNodes = [rssParser nodesForXPath:@"//item" error:nil];
    for (CXMLElement *resultElement in resultNodes) {
        NSMutableDictionary *newsItem = [[NSMutableDictionary alloc] init];
        int counter;
        for(counter = 0; counter < [resultElement childCount]; counter++) {
            [newsItem setObject:[[resultElement childAtIndex:counter] stringValue] forKey:[[resultElement childAtIndex:counter] name]];
        }
        [entriesArray addObject:[newsItem copy]];
    }
}

#pragma mark Autoreleasepool rss

- (void)start_rss
{
    @autoreleasepool {
        entriesAddress = [FEED_BOOKS stringByAppendingFormat:@"search=0&sale=2&category=6&id=%@&page=1/", [dic objectForKey:@"seller_id"]];
        NSLog(@"%@", entriesAddress);
        [self entriesRSSFeed:entriesAddress];
        [self.bookTableView reloadData];
        
    }
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBook" object:self];
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
