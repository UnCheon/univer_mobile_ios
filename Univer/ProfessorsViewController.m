//
//  ProfessorsViewController.m
//  Univer
//
//  Created by 백 운천 on 12. 10. 3..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import "ProfessorsViewController.h"
#import "ProfessorDetailViewController.h"
#import "CategoryView.h"
#import "AddProfessorViewController.h"
#import "CustomCell.h"



#define PROFESSOR_BASE_URL                       @"http://54.249.52.26/feeds/professors/"
#define IMAGE_BASE                               @"http://54.249.52.26"
#define BOOK_BASE_URL                            @"http://54.249.52.26/feeds/books/"
#define CATEGORY_REGION                          @"http://54.249.52.26/feeds/region/"
#define CATEGORY_UNIVERSITY                      @"http://54.249.52.26/feeds/univ/"
#define CATEGORY_COLLEGE                         @"http://54.249.52.26/feeds/college/"
#define CATEGORY_MAJOR                           @"http://54.249.52.26/feeds/major/"

#define ENTRYCOUNT 30

#define kCustomRowHeight  60.0
#define kCustomRowCount   7
#define kAppIconHeight    60


@implementation ProfessorsViewController
@synthesize uniSearchBar, uniTableView, headerView;
@synthesize regionBtn, universityBtn, collegeBtn;
@synthesize footerSpiner;
@synthesize searchBackButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"professors";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launch:) name:@"launch" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launch:) name:@"reloadProfessor" object:nil];


        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 31, 44)];
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 42, 44)];

        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn1.frame =CGRectMake(0, 7, 31, 31);
        [btn1 setTitle:@"검색" forState:UIControlStateNormal];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"cm_search_selected.png"] forState:UIControlStateHighlighted];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"cm_search_unselected.png"] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(uniSearchBar:) forControlEvents:UIControlEventTouchUpInside];
        
        btn2.frame = CGRectMake(0, 7, 31, 31);
        [btn2 setTitle:@"z" forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"cm_register_unselected.png"] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"cm_register_selected.png"] forState:UIControlStateHighlighted];
        [btn2 addTarget:self action:@selector(addProfessor:) forControlEvents:UIControlEventTouchUpInside];
        
        [leftView addSubview:btn1];
        [rightView addSubview:btn2];
        
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        
        is_search = NO;
        page = 1;
        
        
        uniArray = [[NSMutableArray alloc] initWithCapacity:10];
        updateArray = [[NSMutableArray alloc] initWithCapacity:10];
        userDefaults = [NSUserDefaults standardUserDefaults];
     
        lazyImages = [[MHLazyTableImages alloc] init];
		lazyImages.placeholderImage = [UIImage imageNamed:@"pf_no.png"];
		lazyImages.delegate = self;

        
    }
    return self;
}

- (void)viewDidLoad
{
    [searchBackButton addTarget:self action:@selector(uniSearchBar:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"cm_navigation_background_2.jpg"] forBarMetrics:UIBarMetricsDefault];

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
    
    [self.uniTableView reloadData];
    
    [super viewDidLoad];

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
    
    [self.uniTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)launch:(NSNotification *)notification
{
    page = 1;
    [NSThread detachNewThreadSelector:@selector(threadStart) toTarget:self withObject:nil];
    
}

- (void)addProfessor:(id)sender
{
    AddProfessorViewController *addProfessorViewCtr = [[AddProfessorViewController alloc] initWithNibName:@"AddProfessorViewController" bundle:nil];
    [self.navigationController pushViewController:addProfessorViewCtr animated:YES];
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
    UILabel *titleLabel;
    UILabel *gradeLabel;
    UILabel *likeLabel;
    UILabel *dislikeLabel;
    UILabel *commentLabel;
    UILabel *categoryLabel;
    DYRateView *rateView;
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cellBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
        cellBackgroundView.image = [UIImage imageNamed:@"bk_normal.png"];

        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(81, 7, 100, 21)];
        titleLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:14];
        
        gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 59, 40, 14)];
        
        likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 59, 40, 14)];
        
        dislikeLabel = [[UILabel alloc] initWithFrame:CGRectMake(132, 59, 40, 14)];
        
        commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(182, 59, 40, 14)];
        
        categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 27, 240, 21)];
        categoryLabel.backgroundColor = [UIColor clearColor];
        categoryLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:14];
        categoryLabel.textColor = [UIColor grayColor];
        
        
        rateView = [[DYRateView alloc] initWithFrame:CGRectMake(150, 7, 160, 14)];
        
        [cell addSubview:cellBackgroundView];
        [cell addSubview:titleLabel];
        [cell addSubview:rateView];
        [cell addSubview:categoryLabel];
        [cell addSubview:likeLabel];
        [cell addSubview:dislikeLabel];
        [cell addSubview:commentLabel];

    }
    
    NSDictionary *dic = [uniArray objectAtIndex:indexPath.row];
    int total = [[dic objectForKey:@"total"] intValue];
    int count = [[dic objectForKey:@"count"] intValue]*5;

    if (count == 0) {
        count = 1;
    }

    

    
    
    NSString *categoryString = [[dic objectForKey:@"region"] stringByAppendingFormat:@" / %@ / %@", [dic objectForKey:@"university"], [dic objectForKey:@"college"]];
    categoryLabel.text = categoryString;

    float grade = (float)total/(float)count;
    

    
    titleLabel.text = [dic objectForKey:@"title"];

    rateView.rate = grade/2;
    rateView.alignment = RateViewAlignmentLeft;
    
    gradeLabel.text = [@"" stringByAppendingFormat:@"%6.1f", grade];
    gradeLabel.textColor = [UIColor grayColor];
    UIFont *font = [UIFont fontWithName:@"NanumGothicBold" size:14];
    gradeLabel.font = font;
    
    likeLabel.text = [@"추천 " stringByAppendingString:[dic objectForKey:@"like"]];
    likeLabel.textColor = [UIColor grayColor];
    likeLabel.font = font;
    
    dislikeLabel.text = [@"비추 " stringByAppendingString:[dic objectForKey:@"dislike"]];
    dislikeLabel.textColor = [UIColor grayColor];
    dislikeLabel.font = font;
    

    
    
    commentLabel.text = [@"댓글 " stringByAppendingString:[dic objectForKey:@"comment_count"]];
    commentLabel.textColor = [UIColor grayColor];
    commentLabel.font = font;
    
    [lazyImages addLazyImageForCell:cell withIndexPath:indexPath];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfessorDetailViewController *professorDetailViewController = [[ProfessorDetailViewController alloc] initWithNibName:@"ProfessorDetailViewController" bundle:nil];
    professorDetailViewController.hidesBottomBarWhenPushed = YES;
    professorDetailViewController.professor_dic = [uniArray objectAtIndex:indexPath.row];
    professorDetailViewController.image = [uniTableView cellForRowAtIndexPath:indexPath].imageView.image;
    

    [self.navigationController pushViewController:professorDetailViewController animated:YES];
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



#pragma - RSS

- (void)threadStart
{
    @autoreleasepool {
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
    
    NSLog(@"%@", resultNodes);
    for (CXMLElement *resultElement in resultNodes) {
        NSMutableDictionary *newsItem = [[NSMutableDictionary alloc] init];
        int counter;
        for(counter = 0; counter < [resultElement childCount]; counter++) {
            [newsItem setObject:[[resultElement childAtIndex:counter] stringValue] forKey:[[resultElement childAtIndex:counter] name]];
        }
        [updateArray addObject:[newsItem copy]];
    }
    NSLog(@"%d", [updateArray count]);
    [uniArray addObjectsFromArray:updateArray];
    
    NSLog(@"%d", [uniArray count]);
}


- (NSString *)returnAddress
{
    NSString *search_url;
    NSString *category_url;
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
    
    NSString *returnAddress = [PROFESSOR_BASE_URL stringByAppendingFormat:@"search=%@&category=%@&id=%@&page=%d/", search_url, category_url, id_url, page];
    
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
        NSLog(@"%d", position);
        if (scrollView.contentOffset.y > position) {
            page +=1;
            [NSThread detachNewThreadSelector:@selector(updateThreadStart) toTarget:self withObject:nil];
        }
    }
}


@end
