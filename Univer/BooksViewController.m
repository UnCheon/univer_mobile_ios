//
//  BooksViewController.m
//  Univer
//
//  Created by 백 운천 on 12. 10. 3..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import "BooksViewController.h"
#import "RegisterBookViewController.h"
#import "BookDetailViewController.h"
#import "ChangeViewController.h"
#import "CategoryView.h"
#import "CustomCell.h"


#define IMAGE_BASE                              @"http://54.249.52.26"
#define BOOK_BASE_URL                            @"http://54.249.52.26/feeds/books/"
#define CATEGORY_REGION                              @"http://54.249.52.26/feeds/region/"
#define CATEGORY_UNIVERSITY                         @"http://54.249.52.26/feeds/univ/"
#define CATEGORY_COLLEGE                            @"http://54.249.52.26/feeds/college/"
#define CATEGORY_MAJOR                            @"http://54.249.52.26/feeds/major/"

#define ENTRYCOUNT 30


#define kCustomRowHeight  60.0
#define kCustomRowCount   7
#define kAppIconHeight    60



@implementation BooksViewController
@synthesize headerView, uniTableView;
@synthesize uniSearchBar;
@synthesize regionBtn, universityBtn, collegeBtn;
@synthesize footerSpiner;
@synthesize segBtn1, segBtn2, segBtn3;
@synthesize regionLabel, universityLabel, collegeLabel;
@synthesize searchBackButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.title = @"books";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launch:) name:@"launch" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launch:) name:@"reloadBook" object:nil];


        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 31, 44)];
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 44)];

        segBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        segBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        segBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        
        segBtn1.frame = CGRectMake(80, 7, 50, 31);
        [segBtn1 setImage:[UIImage imageNamed:@"bk_sale_selected.png"] forState:UIControlStateNormal];
        [segBtn1 setImage:[UIImage imageNamed:@"bk_sale_selected.png"] forState:UIControlStateHighlighted];
        [segBtn1 addTarget:self action:@selector(segBtn:) forControlEvents:UIControlEventTouchUpInside];
        segBtn1.tag = 1;
        
        segBtn2.frame = CGRectMake(130, 7, 50, 31);
        [segBtn2 setImage:[UIImage imageNamed:@"bk_purchase_unselected.png"] forState:UIControlStateNormal];
        [segBtn2 setImage:[UIImage imageNamed:@"bk_purchase_selected.png"] forState:UIControlStateHighlighted];
        
        [segBtn2 addTarget:self action:@selector(segBtn:) forControlEvents:UIControlEventTouchUpInside];
        segBtn2.tag = 2;
        
        segBtn3.frame = CGRectMake(180, 7, 50, 31);
        [segBtn3 setImage:[UIImage imageNamed:@"bk_my_unselected.png"] forState:UIControlStateNormal];
        [segBtn3 setImage:[UIImage imageNamed:@"bk_my_selected.png"] forState:UIControlStateHighlighted];
        
        [segBtn3 addTarget:self action:@selector(segBtn:) forControlEvents:UIControlEventTouchUpInside];
        segBtn3.tag = 3;

        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn1.frame =CGRectMake(0, 7, 31, 31);
        [btn1 setBackgroundImage:[UIImage imageNamed:@"cm_search_selected.png"] forState:UIControlStateHighlighted];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"cm_search_unselected.png"] forState:UIControlStateNormal];
//        [btn1 addTarget:self action:@selector(uniSearchBar:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
        
        btn2.frame = CGRectMake(0, 7, 31, 31);
        [btn2 setImage:[UIImage imageNamed:@"cm_register_unselected.png"] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"cm_register_selected.png"] forState:UIControlStateHighlighted];
        [btn2 addTarget:self action:@selector(registerBookBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [leftView addSubview:btn1];
        [rightView addSubview:btn2];
        [leftView addSubview:segBtn1];
        [leftView addSubview:segBtn2];
        [leftView addSubview:segBtn3];
        
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
        self.navigationItem.rightBarButtonItem = rightItem;
        self.navigationItem.leftBarButtonItem = leftItem;

        

        
        
        [universityLabel setTextColor:[UIColor colorWithRed:66.0 green:66.0 blue:66.0 alpha:1.0]];
        [collegeLabel setTextColor:[UIColor colorWithRed:66.0 green:66.0 blue:66.0 alpha:1.0]];
        
        
        is_search = NO;
        page = 1;

        sell_url = @"1";
        
        uniArray = [[NSMutableArray alloc] initWithCapacity:10];
        updateArray = [[NSMutableArray alloc] initWithCapacity:10];
        
        userDefaults = [NSUserDefaults standardUserDefaults];
        
        
        lazyImages = [[MHLazyTableImages alloc] init];
		lazyImages.placeholderImage = [UIImage imageNamed:@"bk_book.png"];
		lazyImages.delegate = self;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"cm_navigation_background_2.jpg"] forBarMetrics:UIBarMetricsDefault];

    [searchBackButton addTarget:self action:@selector(uniSearchBar:) forControlEvents:UIControlEventTouchUpInside];
    
    lazyImages.tableView = self.uniTableView;

    
    regionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, 107, 21)];
    regionLabel.backgroundColor = [UIColor clearColor];
    regionLabel.textAlignment = UITextAlignmentCenter;
    regionLabel.textColor = [UIColor grayColor];
    regionLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];
    [regionBtn addSubview:regionLabel];

    universityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, 107, 21)];
    universityLabel.backgroundColor = [UIColor clearColor];
    universityLabel.textAlignment = UITextAlignmentCenter;
    universityLabel.textColor = [UIColor grayColor];
    universityLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];
    [universityBtn addSubview:universityLabel];
    
    collegeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, 107, 21)];
    collegeLabel.backgroundColor = [UIColor clearColor];
    collegeLabel.textAlignment = UITextAlignmentCenter;
    collegeLabel.textColor = [UIColor grayColor];
    collegeLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];
    [collegeBtn addSubview:collegeLabel];
    
    
    
    uniSearchBar.frame = CGRectMake(0, -44, 320, 44);

    uniSearchBar.hidden = YES;
    searchBackButton.hidden = YES;
 
    [headerView addSubview:uniSearchBar];
    
    
    refreshControl= [[ODRefreshControl alloc] initInScrollView:self.uniTableView];
    
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
//	self.tableView.rowHeight = 80;

    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    region_dic = [userDefaults objectForKey:@"region"];
    uni_dic = [userDefaults objectForKey:@"university"];
    coll_dic = [userDefaults objectForKey:@"college"];
    
    
    
    if (region_dic != nil) {
        if (uni_dic != nil) {
            if (coll_dic != nil) {
                regionLabel.text = [region_dic objectForKey:@"title"];
                universityLabel.text = [uni_dic objectForKey:@"title"];
                collegeLabel.text = [coll_dic objectForKey:@"title"];
            }else{
                regionLabel.text = [region_dic objectForKey:@"title"];
                universityLabel.text = [uni_dic objectForKey:@"title"];
                collegeLabel.text = @"단과대선택";
            }
        }else{
            regionLabel.text = [region_dic objectForKey:@"title"];
            universityLabel.text = @"대학선택";
            collegeLabel.text = @"단과대선택";
        }
    }else{
        regionLabel.text = @"지역선택";
        universityLabel.text = @"대학선택";
        collegeLabel.text = @"단과대선택";
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)launch:(NSNotification *)notification
{
    [NSThread detachNewThreadSelector:@selector(threadStart) toTarget:self withObject:nil];

}



- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)_refreshControl
{
    double delayInSeconds = 1.0;
    [NSThread detachNewThreadSelector:@selector(threadStart) toTarget:self withObject:nil];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
    });
}

#pragma - Navigation Button Actions

- (void)registerBookBtn:(id)sender
{
    RegisterBookViewController *registerBookViewCtr = [[RegisterBookViewController alloc] initWithNibName:@"RegisterBookViewController" bundle:nil];
    [self.navigationController pushViewController:registerBookViewCtr animated:YES];
}

- (void)uniSearchBar:(id)sender
{
    uniSearchBar.showsCancelButton = YES;
    
    for (UIView *view in uniSearchBar.subviews) {
        
        
        //if subview is the button
        if ([[view.class description] isEqualToString:@"UINavigationButton"]) {
            
            //change the button images and text for different states
            [((UIButton *)view) setEnabled:YES];
            
            [((UIButton *)view) setTitle:@"취소" forState:UIControlStateNormal];
            /*
             [((UIButton *)view) setImage:[UIImage imageNamed:@"button image"] forState:UIControlStateNormal];
             [((UIButton *)view) setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
             [((UIButton *)view) setBackgroundImage:[UIImage imageNamed:@"button_pressed"] forState:UIControlStateSelected];
             [((UIButton *)view) setBackgroundImage:[UIImage imageNamed:@"button_pressed"] forState:UIControlStateHighlighted];
             */
            
            //if the subview is the background
        }else if([[view.class description] isEqualToString:@"UISearchBarBackground"]) {
            
            //put a custom gradient overtop the background
            
            //if the subview is the textfield
        }else if([[view.class description] isEqualToString:@"UISearchBarTextField"]){
            
            //change the text field if you wish
            
        }
        
    }
    if (is_search) {
        is_search = NO;
        self.uniSearchBar.showsCancelButton = NO;
        searchBackButton.hidden = YES;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        self.uniSearchBar.frame = CGRectMake(0, -44, 320, 44);
        [self.uniSearchBar resignFirstResponder];
        [UIView commitAnimations];
        [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(searchBarHidden:) userInfo:nil repeats:NO];
        
    }else{
        is_search = YES;
        self.uniSearchBar.hidden = NO;
        searchBackButton.hidden = NO;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        self.uniSearchBar.frame = CGRectMake(0, 0, 320, 44);
        
        [self.uniSearchBar becomeFirstResponder];
        [UIView commitAnimations];
    }
}


-(void)searchBarCancelButtonClicked:(UISearchBar*)searchBar
{
    is_search = NO;
    self.uniSearchBar.showsCancelButton = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    self.uniSearchBar.frame = CGRectMake(0, -44, 320, 44);
    [self.uniSearchBar resignFirstResponder];
    [UIView commitAnimations];
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(searchBarHidden:) userInfo:nil repeats:NO];
}

- (void)searchBarHidden:(id)sender
{
    self.uniSearchBar.hidden = YES;
    searchBackButton.hidden = YES;
}





#pragma -TableView Cycle


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    return [uniArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CustomCell *cell;
    
    UIImageView *cellBackgroundView;
    UIImageView *backgroundView;
    UILabel *titleLabel;
    UILabel *categoryLabel;
    UILabel *priceLabel;
    UIImageView *parcelImageView;
    UIImageView *meetImageView;

    
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cellBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
        cellBackgroundView.image = [UIImage imageNamed:@"bk_normal.png"];
        
        backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(154, 0, 166, 80)];
        
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 7, 220, 21)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];

        
        categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 27, 240, 21)];
        categoryLabel.backgroundColor = [UIColor clearColor];
        categoryLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:14];
        categoryLabel.textColor = [UIColor grayColor];
        
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 55, 100, 21)];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:14];
        priceLabel.textColor = [UIColor colorWithRed:0.376471 green:0.666667 blue:0.760784 alpha:1];
        
        parcelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(82, 55, 44, 20)];
        meetImageView = [[UIImageView alloc] initWithFrame:CGRectMake(137, 55, 44, 20)];
        
        [cell addSubview:cellBackgroundView];
        [cell addSubview:titleLabel];
        [cell addSubview:categoryLabel];
        [cell addSubview:priceLabel];
        [cell addSubview:parcelImageView];
        [cell addSubview:meetImageView];


    }
    NSDictionary *dic;
    
    dic = [uniArray objectAtIndex:indexPath.row];

    
    
    titleLabel.text = [dic objectForKey:@"title"];
    
    NSString *categoryString = [[dic objectForKey:@"region"] stringByAppendingFormat:@" / %@ / %@", [dic objectForKey:@"university"], [dic objectForKey:@"college"]];
    
    categoryLabel.text = categoryString;
    
    
    priceLabel.text = [NSString stringWithFormat:@"%@원", [dic objectForKey:@"discount_price"]];
    
    
    if ([[dic objectForKey:@"parcel"] isEqualToString:@"0"])
        parcelImageView.image = [UIImage imageNamed:@"bk_parcel_false.png"];
    else
        parcelImageView.image = [UIImage imageNamed:@"bk_parcel_true.png"];
    
    if ([[dic objectForKey:@"meet"] isEqualToString:@"0"])
        meetImageView.image = [UIImage imageNamed:@"bk_meet_false.png"];
    else
        meetImageView.image = [UIImage imageNamed:@"bk_meet_true.png"];
    
    	    
    
    int sale = [[dic objectForKey:@"sale"] intValue];
    
    if(sale == 2){
        backgroundView.image = [UIImage imageNamed:@"bk_reserved.png"];
        [cell addSubview:backgroundView];
    }else if(sale == 3){
        backgroundView.image = [UIImage imageNamed:@"bk_soldout.png"];
        [cell addSubview:backgroundView];
    }
    
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(170, 1, 60, 20)];
    la.text = [NSString stringWithFormat:@"%d번", indexPath.row];
//    [cell addSubview:la];

    [lazyImages addLazyImageForCell:cell withIndexPath:indexPath];

    
    return cell;

}



#pragma mark -
#pragma mark MHLazyTableImagesDelegate

- (NSURL*)lazyImageURLForIndexPath:(NSIndexPath*)indexPath
{
    NSDictionary *dic = [uniArray objectAtIndex:indexPath.row];
    NSString *url_string = [IMAGE_BASE stringByAppendingString:[dic objectForKey:@"thumbnail"]];
	return [NSURL URLWithString:url_string];
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

#pragma mark -
#pragma mark UIScrollViewDelegate


- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
	[lazyImages scrollViewDidEndDecelerating:scrollView];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *passDic = [uniArray objectAtIndex:indexPath.row];
    
    NSString *my_id = [userDefaults objectForKey:@"user_id"];
    
    BookDetailViewController *bookDetailViewCtr = [[BookDetailViewController alloc] initWithNibName:@"BookDetailViewController" bundle:nil];
    bookDetailViewCtr.dic = [uniArray objectAtIndex:indexPath.row];
    
    bookDetailViewCtr.image = [uniTableView cellForRowAtIndexPath:indexPath].imageView.image;
    

    
    if ([sell_url isEqualToString:@"3"] || [[passDic objectForKey:@"seller_id"] isEqualToString:my_id]) {
        bookDetailViewCtr.hidesBottomBarWhenPushed = YES;
    }
    
    [self.navigationController pushViewController:bookDetailViewCtr animated:YES];
    
    return;
}






#pragma - RSS

- (void)threadStart
{
    @autoreleasepool {
        page = 1;
        [uniArray removeAllObjects];
        [self.uniTableView reloadData];
        NSString *feedAddress = [self returnAddress];
        [self uniRSSFeed:feedAddress];
        [refreshControl endRefreshing];
        [self.uniTableView reloadData];
    }

}

- (void)uniRSSFeed:(NSString *)feedAddress
{
    NSLog(@"%@", feedAddress);
    NSURL *url = [NSURL URLWithString: feedAddress];
    NSError *error = nil;
    CXMLDocument *rssParser = [[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:&error];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"팝니다." message:@"네트워크상태를 확인하세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
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
        [uniArray addObject:[newsItem copy]];
    }
}


- (void)updateThreadStart
{
    @autoreleasepool {
        [footerSpiner startAnimating];
        [updateArray removeAllObjects];
        [self.uniTableView reloadData];
        NSString *feedAddress = [self returnAddress];
        [self updateRSSFeed:feedAddress];
        [self.uniTableView reloadData];
        [footerSpiner stopAnimating];
    }
}

- (void)updateRSSFeed:(NSString *)feedAddress
{


    NSURL *url = [NSURL URLWithString: feedAddress];
    NSError *error = nil;
    CXMLDocument *rssParser = [[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:&error];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"팝니다." message:@"네트워크상태를 확인하세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
    
    NSArray *resultNodes = NULL;
    resultNodes = [rssParser nodesForXPath:@"//item" error:nil];
    
    for (CXMLElement *resultElement in resultNodes) {
        NSMutableDictionary *newsItem = [[NSMutableDictionary alloc] init];
        int counter;
        for(counter = 0; counter < [resultElement childCount]; counter++) {
            [newsItem setObject:[[resultElement childAtIndex:counter] stringValue] forKey:[[resultElement childAtIndex:counter] name]];
        }
        [updateArray addObject:[newsItem copy]];
    }
    [uniArray addObjectsFromArray:updateArray];
    

}

- (NSString *)returnAddress
{
    NSString *search_url;
    NSString *id_url;
    
    if (is_search) {
        search_url = @"1";
    }else{
        search_url = @"0";
    }
    
    
    
    
    if ([userDefaults objectForKey:@"region"]) {
        if ([userDefaults objectForKey:@"university"]) {
            if ([userDefaults objectForKey:@"college"]) {
                if ([userDefaults objectForKey:@"major"]) {
                    category_url = @"4";
                    id_url = [[userDefaults objectForKey:@"major"] objectForKey:@"id"];
                }else{
                    category_url = @"3";
                    id_url = [[userDefaults objectForKey:@"college"] objectForKey:@"id"];                    
                }
            }else{
                category_url = @"2";
                id_url = [[userDefaults objectForKey:@"university"] objectForKey:@"id"];                
            }
        }else{
            category_url = @"1";
            id_url = [[userDefaults objectForKey:@"region"] objectForKey:@"id"];
        }
    }else{
        category_url = @"0";
        id_url = @"0";
    }
    if ([sell_url isEqualToString:@"3"]) {
        category_url = @"5";
        id_url = [userDefaults objectForKey:@"user_id"];
    }

    NSString *returnAddress = [BOOK_BASE_URL stringByAppendingFormat:@"search=%@&sale=%@&category=%@&id=%@&page=%d/", search_url, sell_url, category_url, id_url, page];
    
    return returnAddress;
}


#pragma - Category Button

- (IBAction)regionBtn:(id)sender {
    CategoryView *categoryView = [[CategoryView alloc] initWithNibName:@"CategoryView"bundle:nil];
    categoryView.address = CATEGORY_REGION;
    categoryView.delegate = self;
    categoryView.kinds = 0;
    [self.navigationController pushViewController:categoryView animated:YES];
    
}

- (IBAction)universityBtn:(id)sender {
    if (![userDefaults objectForKey:@"region"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"학교선택" message:@"지역을 먼저 선택하여야 합니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }else{
        CategoryView *categoryView = [[CategoryView alloc] initWithNibName:@"CategoryView" bundle:nil];
        NSString *address = [CATEGORY_UNIVERSITY stringByAppendingFormat:@"%@/", [[userDefaults objectForKey:@"region"] objectForKey:@"id"]];
        categoryView.address = address;
        categoryView.kinds = 1;
        [self.navigationController pushViewController:categoryView animated:YES];
    }
}

- (IBAction)collegeBtn:(id)sender {
    if (![userDefaults objectForKey:@"university"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"카테고리" message:@"학교를 먼저 선택하여야 합니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }else{
        CategoryView *categoryView = [[CategoryView alloc] initWithNibName:@"CategoryView" bundle:nil];
        categoryView.address = [CATEGORY_COLLEGE stringByAppendingFormat:@"%@/", [[userDefaults objectForKey:@"university"] objectForKey:@"id"]];
        categoryView.kinds = 2;
        [self.navigationController pushViewController:categoryView animated:YES];
    }
}


- (void)segBtn:(UIButton *)btn
{
    if (btn.tag == 1) {
        [segBtn1 setImage:[UIImage imageNamed:@"bk_sale_selected.png"] forState:UIControlStateNormal];
        [segBtn2 setImage:[UIImage imageNamed:@"bk_purchase_unselected.png"] forState:UIControlStateNormal];
        [segBtn3 setImage:[UIImage imageNamed:@"bk_my_unselected.png"] forState:UIControlStateNormal];

        sell_url = @"1";
        
    }else if (btn.tag == 2){
        [segBtn1 setImage:[UIImage imageNamed:@"bk_sale_unselected.png"] forState:UIControlStateNormal];
        [segBtn2 setImage:[UIImage imageNamed:@"bk_purchase_selected.png"] forState:UIControlStateNormal];
        [segBtn3 setImage:[UIImage imageNamed:@"bk_my_unselected.png"] forState:UIControlStateNormal];

        sell_url = @"0";
    }else if (btn.tag == 3){
        [segBtn1 setImage:[UIImage imageNamed:@"bk_sale_unselected.png"] forState:UIControlStateNormal];
        [segBtn2 setImage:[UIImage imageNamed:@"bk_purchase_unselected.png"] forState:UIControlStateNormal];
        [segBtn3 setImage:[UIImage imageNamed:@"bk_my_selected.png"] forState:UIControlStateNormal];

        sell_url = @"3";
        category_url = @"5";
    }
    [NSThread detachNewThreadSelector:@selector(threadStart) toTarget:self withObject:nil];

}


#pragma - Scroll Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[lazyImages scrollViewDidEndDragging:scrollView willDecelerate:decelerate];

    NSLog(@"%f", scrollView.contentOffset.y);
    
    if (is_search) {
        int position = searchPage*1600-291;
        if (scrollView.contentOffset.y > position) {
            searchPage +=1;
            [NSThread detachNewThreadSelector:@selector(update_search_rss) toTarget:self withObject:nil];
        }
    }else{
        int position = page*(ENTRYCOUNT*80-self.uniTableView.bounds.size.height);
        if (scrollView.contentOffset.y > position) {
            page +=1;
            [NSThread detachNewThreadSelector:@selector(updateThreadStart) toTarget:self withObject:nil];
        }
    }
}

- (void)test:(id)sender
{
    [self.uniTableView reloadData];
    
}

@end
