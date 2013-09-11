//
//  BoardsViewController.m
//  Univer
//
//  Created by 백 운천 on 12. 10. 11..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import "BoardsViewController.h"
#import "ASIFormDataRequest.h"
#import "WriteEntryViewController.h"
#import "CategoryView.h"
//#import "AsyncImageView.h"
#import "BoardDetailViewController.h"
#import "CustomCmImageCell.h"


#define BOARDS_URL                                  @"http://54.249.52.26/feeds/entries/"
#define ENTRYCOUNT 30
#define CATEGORY_REGION                          @"http://54.249.52.26/feeds/region/"
#define CATEGORY_UNIVERSITY                      @"http://54.249.52.26/feeds/univ/"
#define IMAGE_BASE                               @"http://54.249.52.26/media/"
#define ENTRY_LIKE_URL                           @"http://54.249.52.26/like/entry/"



@implementation BoardsViewController
@synthesize uniTableView;
@synthesize footerSpiner;
@synthesize universityBtn, regionBtn;


#define kCustomRowHeight  60
#define kCustomRowCount   7
#define kAppIconHeight    60


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"커뮤니티";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launch:) name:@"launch" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launch:) name:@"reloadEntry" object:nil];
        
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 31, 44)];
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn2.frame = CGRectMake(0, 7, 31, 31);
        [btn2 setTitle:@"z" forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"cm_register_unselected.png"] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"cm_register_selected.png"] forState:UIControlStateHighlighted];
        [btn2 addTarget:self action:@selector(writeEntry:) forControlEvents:UIControlEventTouchUpInside];
        
        [rightView addSubview:btn2];
        
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];

        self.navigationItem.rightBarButtonItem = rightBarButtonItem;


        
        page = 1;
        
        uniArray = [[NSMutableArray alloc] initWithCapacity:10];
        updateArray = [[NSMutableArray alloc] initWithCapacity:10];
        
        userDefaults = [NSUserDefaults standardUserDefaults];


        lazyImages = [[MHLazyTableImages alloc] init];
		lazyImages.placeholderImage = [UIImage imageNamed:@"black.png"];
		lazyImages.delegate = self;

    
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"cm_navigation_background_2.jpg"] forBarMetrics:UIBarMetricsDefault];

    UIImage *repeatingImage = [UIImage imageNamed:@"cm_background_pattern.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:repeatingImage];
    
    [regionBtn setTitle:@"" forState:UIControlStateNormal];
    [universityBtn setTitle:@"" forState:UIControlStateNormal];
    
    refreshControl= [[ODRefreshControl alloc] initInScrollView:self.uniTableView];
    
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    regionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, 160, 21)];
    regionLabel.backgroundColor = [UIColor clearColor];
    regionLabel.textAlignment = UITextAlignmentCenter;
    regionLabel.textColor = [UIColor grayColor];
    regionLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];
    [regionBtn addSubview:regionLabel];
    
    universityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, 160, 21)];
    universityLabel.backgroundColor = [UIColor clearColor];
    universityLabel.textAlignment = UITextAlignmentCenter;
    universityLabel.textColor = [UIColor grayColor];
    universityLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];
    [universityBtn addSubview:universityLabel];

    
    lazyImages.tableView = self.uniTableView;

    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yy"];
    year = [dateFormat stringFromDate:date];
    NSLog(@"year iphone : %@", year);

    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    
    region_dic = [userDefaults objectForKey:@"region"];
    uni_dic = [userDefaults objectForKey:@"university"];

    
    if (region_dic != nil) {
        if (uni_dic != nil) {
            regionLabel.text = [region_dic objectForKey:@"title"];
            universityLabel.text = [uni_dic objectForKey:@"title"];
            
            }else{
                regionLabel.text = [region_dic objectForKey:@"title"];
                universityLabel.text = @"대학교";
            }
        }else{
            regionLabel.text = @"지역";
            universityLabel.text = @"대학교";
        }

    [self.uniTableView reloadData];

    [super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma - Refresh method

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)_refreshControl
{
    double delayInSeconds = 1.0;
    [NSThread detachNewThreadSelector:@selector(threadStart) toTarget:self withObject:nil];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
    });
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



#pragma -TableView Cycle


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [uniArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier1 = @"Cell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CustomCmImageCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];

    likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 9, 40, 20)];
    commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 9, 40, 20)];

    
    UIView *cellTitleView;
    UIView *cellSubview;
    UILabel *cellNameLabel;
    UILabel *cellCategoryLabel;
    UILabel *cellTimeLabel;
    UILabel *cellContentLabel;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        
        cellTitleView = [[UIView alloc] init];
        cellTitleView.backgroundColor = [UIColor whiteColor];
        
        cellSubview = [[UIView alloc] init];
        cellSubview.backgroundColor = [UIColor lightTextColor];
        
        cellNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
        cellNameLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];
        
        cellTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, cellNameLabel.frame.origin.y, 100, 30)];
        cellTimeLabel.backgroundColor = [UIColor clearColor];
        cellTimeLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:11];
        cellTimeLabel.textColor = [UIColor grayColor];
        
        cellCategoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellNameLabel.frame.origin.x, cellNameLabel.frame.origin.y+30, 200, 30)];
        cellCategoryLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:12];
        cellCategoryLabel.textColor = [UIColor grayColor];
        
        cellContentLabel = [[UILabel alloc] init];
        cellContentLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];
        cellContentLabel.lineBreakMode = UILineBreakModeTailTruncation;
        cellContentLabel.numberOfLines = 0;
        
        [cellTitleView addSubview:cellNameLabel];
        [cellTitleView addSubview:cellTimeLabel];
        [cellTitleView addSubview:cellCategoryLabel];
        [cellTitleView addSubview:cellContentLabel];
        
        [cell addSubview:cellTitleView];
        [cell addSubview:cellSubview];
        
        
        UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        likeBtn.frame = CGRectMake(9, 0, 50, 40);
        commentBtn.frame = CGRectMake(70, 0, 40, 40);
        [likeBtn setTitle:@"좋아요" forState:UIControlStateNormal];
        [likeBtn setTitleColor:[UIColor colorWithRed:0.376471 green:0.666667 blue:0.760784 alpha:1] forState:UIControlStateNormal];
        [likeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        likeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [commentBtn setTitle:@"댓글" forState:UIControlStateNormal];
        [commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [commentBtn setTitleColor:[UIColor colorWithRed:0.376471 green:0.666667 blue:0.760784 alpha:1] forState:UIControlStateNormal];
        commentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [likeBtn addTarget:self action:@selector(likeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [commentBtn addTarget:self action:@selector(commentBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(170, 9, 20, 20)];
        UIImageView *commentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(230, 9, 20, 20)];
        likeImageView.image = [UIImage imageNamed:@"com_like.png"];
        commentImageView.image = [UIImage imageNamed:@"com_re.png"];
        
        
        likeLabel.backgroundColor = [UIColor yellowColor];
        commentLabel.backgroundColor = [UIColor clearColor];
        
        
        
        [cellSubview addSubview:likeBtn];
        [cellSubview addSubview:commentBtn];
        
        [cellSubview addSubview:likeLabel];
        [cellSubview addSubview:commentLabel];
        
        [cellSubview addSubview:likeImageView];
        [cellSubview addSubview:commentImageView];

        
    }
    
    UIView *cell1TitleView;
    UIView *cell1ContentView;
    UIView *cell1Subview;
    UILabel *cell1NameLabel;
    UILabel *cell1CategoryLabel;
    UILabel *cell1TimeLabel;
    UILabel *cell1ContentLabel;
    
    
    if (cell1 == nil) {
        cell1 = [[CustomCmImageCell alloc] init];
        
        cell1TitleView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 70)];
        cell1TitleView.backgroundColor = [UIColor whiteColor];
        
        cell1ContentView = [[UIView alloc] init];
        cell1ContentView.backgroundColor = [UIColor whiteColor];
        
        cell1Subview = [[UIView alloc] init];
        cell1Subview.backgroundColor = [UIColor lightTextColor];
        
        
        cell1NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
        cell1NameLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];
        
        cell1TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, cellNameLabel.frame.origin.y, 100, 30)];
        cell1TimeLabel.backgroundColor = [UIColor clearColor];
        cell1TimeLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:11];
        cell1TimeLabel.textColor = [UIColor grayColor];
        
        cell1CategoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellNameLabel.frame.origin.x, cellNameLabel.frame.origin.y+30, 200, 30)];
        cell1CategoryLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:12];
        cell1CategoryLabel.textColor = [UIColor grayColor];

        cell1ContentLabel = [[UILabel alloc] init];
        cell1ContentLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];
        cell1ContentLabel.lineBreakMode = UILineBreakModeTailTruncation;
        cell1ContentLabel.numberOfLines = 0;

        [cell1TitleView addSubview:cell1NameLabel];
        [cell1TitleView addSubview:cell1TimeLabel];
        [cell1TitleView addSubview:cell1CategoryLabel];
        
        [cell1ContentView addSubview:cell1ContentLabel];
        
        [cell1 addSubview:cell1TitleView];
        [cell1 addSubview:cell1ContentView];
        [cell1 addSubview:cell1Subview];
        
        
        
        UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        likeBtn.frame = CGRectMake(9, 0, 50, 40);
        commentBtn.frame = CGRectMake(70, 0, 40, 40);
        [likeBtn setTitle:@"좋아요" forState:UIControlStateNormal];
        [likeBtn setTitleColor:[UIColor colorWithRed:0.376471 green:0.666667 blue:0.760784 alpha:1] forState:UIControlStateNormal];
        [likeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        likeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [commentBtn setTitle:@"댓글" forState:UIControlStateNormal];
        [commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [commentBtn setTitleColor:[UIColor colorWithRed:0.376471 green:0.666667 blue:0.760784 alpha:1] forState:UIControlStateNormal];
        commentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [likeBtn addTarget:self action:@selector(likeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [commentBtn addTarget:self action:@selector(commentBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(170, 9, 20, 20)];
        UIImageView *commentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(230, 9, 20, 20)];
        likeImageView.image = [UIImage imageNamed:@"com_like.png"];
        commentImageView.image = [UIImage imageNamed:@"com_re.png"];
        
        
        likeLabel.backgroundColor = [UIColor clearColor];
        commentLabel.backgroundColor = [UIColor clearColor];
        

        
        [cell1Subview addSubview:likeBtn];
        [cell1Subview addSubview:commentBtn];
        
        [cell1Subview addSubview:likeLabel];
        [cell1Subview addSubview:commentLabel];
        
        [cell1Subview addSubview:likeImageView];
        [cell1Subview addSubview:commentImageView];
        
    }
    
    
    
    
    
    NSDictionary *dic = [uniArray objectAtIndex:indexPath.row];
    
    NSString *categoryString = [NSString stringWithFormat:@"%@ / %@", [dic objectForKey:@"region"], [dic objectForKey:@"university"]];
    
    NSString *contentString = [dic objectForKey:@"description"];
    CGSize contentSize = [contentString sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(280.0f, 110.0f) lineBreakMode:UILineBreakModeTailTruncation];

    likeLabel.tag = indexPath.row+1;
    
    
    NSString *timeString = [dic objectForKey:@"created"];
    NSArray *timeArray = [timeString componentsSeparatedByString:@"-"];

    NSString *yearString = [[timeArray objectAtIndex:0] substringWithRange:NSMakeRange(2, 2)];
    NSString *month = [timeArray objectAtIndex:1];
    NSString *dayTimeString = [timeArray objectAtIndex:2];
    NSArray *dayTimeArray = [dayTimeString componentsSeparatedByString:@" "];
    NSString *day = [dayTimeArray objectAtIndex:0];
    NSString *timeString2 = [dayTimeArray objectAtIndex:1];
    
    NSArray *timeArray2 = [timeString2 componentsSeparatedByString:@":"];
    
    NSString *tiemaStringFinal = [NSString stringWithFormat:@"%@:%@", [timeArray2 objectAtIndex:0], [timeArray2 objectAtIndex:1]];
    
    
    NSString *nowString;
    
    if ([year isEqualToString:yearString]) {
        nowString = [NSString stringWithFormat:@"%@.%@  %@", month, day, tiemaStringFinal];
    }else{
        nowString = [NSString stringWithFormat:@"%@.%@.%@", yearString, month, day];
    }

    
    
    if ([[dic objectForKey:@"image"] isEqualToString:@""]) {
        cellTitleView.frame = CGRectMake(cell1TitleView.frame.origin.x , cell1TitleView.frame.origin.y, cell1TitleView.frame.size.width, cell1TitleView.frame.size.height+contentSize.height+10);
        
        cellNameLabel.text = [dic objectForKey:@"title"];
        cellTimeLabel.text = nowString;
        cellCategoryLabel.text = categoryString;
        
        cellContentLabel.frame = CGRectMake(cellCategoryLabel.frame.origin.x, cellCategoryLabel.frame.origin.y+30, cellTitleView.frame.size.width-cellCategoryLabel.frame.origin.x*2, contentSize.height);
        cellContentLabel.text = contentString;
        
        cellSubview.frame = CGRectMake(cellTitleView.frame.origin.x, cellTitleView.frame.origin.y + cellTitleView.frame.size.height, cellTitleView.frame.size.width, 40);
        
        likeLabel.text = [dic objectForKey:@"like"];
        commentLabel.text = [dic objectForKey:@"comment"];

        [cellSubview addSubview:likeLabel];
        [cellSubview addSubview:commentLabel];
        return cell;
        
        
    }else{
        cell1NameLabel.text = [dic objectForKey:@"title"];
        cell1TimeLabel.text = nowString;
        cell1CategoryLabel.text = categoryString;
        
        cell1ContentView.frame = CGRectMake(cell1TitleView.frame.origin.x, cell1CategoryLabel.frame.origin.y+40+200, cell1TitleView.frame.size.width, contentSize.height+20);
        
        
        cell1ContentLabel.frame = CGRectMake(10, 10, cell1TitleView.frame.size.width-cell1CategoryLabel.frame.origin.x*2, contentSize.height);
        
        cell1ContentLabel.text = contentString;
        
        cell1Subview.frame = CGRectMake(cell1ContentView.frame.origin.x , cell1ContentView.frame.origin.y+cell1ContentView.frame.size.height, cell1TitleView.frame.size.width, 40);
        
        
        [lazyImages addLazyImageForCell:cell1 withIndexPath:indexPath];
        
        
        likeLabel.text = [dic objectForKey:@"like"];
        commentLabel.text = [dic objectForKey:@"comment"];

        [cell1Subview addSubview:likeLabel];
        [cell1Subview addSubview:commentLabel];
        
        NSLog(@"%f, %f", cell1.imageView.image.size.width, cell1.imageView.image.size.height);
        

        
        return cell1;
    }

    
    
    
    
    
    
    /*
    
    
    
    NSString *content = [dic objectForKey:@"description"];
    
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(280.0f, 110.0f) lineBreakMode:UILineBreakModeTailTruncation];


    contentLabel.lineBreakMode = UILineBreakModeTailTruncation;
    contentLabel.numberOfLines = 0;
    
    nicknameLabel.text = nickname;
    createdLabel.text = created;
    universityLabel.text = university;
    contentLabel.text = content;
    
    UIView *cellView = [[UIView alloc] init];
    UIImageView *imageView;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizesSubviews = YES;
    imageView.clipsToBounds = YES;


    
    cellView.backgroundColor = [UIColor whiteColor];
    if ([[dic objectForKey:@"image"] isEqualToString:@""]) {
        cellView.frame = CGRectMake(9, 9, 302, size.height+61+40);
    }else{
        cellView.frame = CGRectMake(9, 9, 302, size.height+61+40+175);
        [lazyImages addLazyImageForCell:cell withIndexPath:indexPath];

    }
    
    [cellView addSubview:nicknameLabel];
    [cellView addSubview:createdLabel];
    [cellView addSubview:universityLabel];
    [cellView addSubview:contentLabel];
    
    
    
    UIView *cellSubView = [[UIView alloc] initWithFrame:CGRectMake(9, cellView.frame.origin.y+cellView.frame.size.height, 302, 40)];
    
    cellSubView.backgroundColor = [UIColor lightTextColor];

    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    likeBtn.frame = CGRectMake(9, 0, 50, 40);
    commentBtn.frame = CGRectMake(70, 0, 40, 40);
    [likeBtn setTitle:@"좋아요" forState:UIControlStateNormal];
    [likeBtn setTitleColor:[UIColor colorWithRed:0.376471 green:0.666667 blue:0.760784 alpha:1] forState:UIControlStateNormal];
    [likeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    likeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [commentBtn setTitle:@"댓글" forState:UIControlStateNormal];
    [commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [commentBtn setTitleColor:[UIColor colorWithRed:0.376471 green:0.666667 blue:0.760784 alpha:1] forState:UIControlStateNormal];
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [likeBtn addTarget:self action:@selector(likeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [commentBtn addTarget:self action:@selector(commentBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(170, 9, 20, 20)];
    UIImageView *commentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(230, 9, 20, 20)];
    likeImageView.image = [UIImage imageNamed:@"com_like.png"];
    commentImageView.image = [UIImage imageNamed:@"com_re.png"];
    
    
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 9, 40, 20)];

    likeLabel.backgroundColor = [UIColor clearColor];
    commentLabel.backgroundColor = [UIColor clearColor];
    likeLabel.text = [dic objectForKey:@"like"];
    commentLabel.text = [dic objectForKey:@"comment"];
    
    likeLabel.tag = indexPath.row+1;
    
    [cellSubView addSubview:likeBtn];
    [cellSubView addSubview:commentBtn];
    [cellSubView addSubview:likeLabel];
    [cellSubView addSubview:commentLabel];
    [cellSubView addSubview:likeImageView];
    [cellSubView addSubview:commentImageView];
    

    
    if ([[dic objectForKey:@"image"] isEqualToString:@""]) {
        [cell addSubview:cellView];
        [cell addSubview:cellSubView];
        return cell;
    }else{
        cellView.frame = CGRectMake(cellView.frame.origin.x, cellView.frame.origin.y, cellView.frame.size.width, 60);
        
        [cell1 addSubview:cellView];
        [cellView bringSubviewToFront:cell1.imageView];
        [cell1.imageView bringSubviewToFront:cellView];
        [cell1 addSubview:cellSubView];
//        [cell1 addSubview:asyncImageView];
    
//        [lazyImages addLazyImageForCell:cell1 withIndexPath:indexPath];

        cell1.imageView.image = [UIImage imageNamed:@"StarFull.png"];
        
        return cell1;
        
    }
    */
    return cell;
}


#pragma mark -
#pragma mark UIScrollViewDelegate


- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
	[lazyImages scrollViewDidEndDecelerating:scrollView];
}

#pragma mark -
#pragma mark MHLazyTableImagesDelegate

- (NSURL*)lazyImageURLForIndexPath:(NSIndexPath*)indexPath
{
    NSDictionary *dic = [uniArray objectAtIndex:indexPath.row];
    NSString *url_string = [IMAGE_BASE stringByAppendingString:[dic objectForKey:@"image"]];
    NSLog(@"imageUrl = %@", url_string);
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [uniArray objectAtIndex:indexPath.row];
    

    NSString *content = [dic objectForKey:@"description"];
    
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(280.0f, 110.0f) lineBreakMode:UILineBreakModeTailTruncation];

    if ([[dic objectForKey:@"image"] isEqualToString:@""]) {
        return size.height+61+40+18+40;
    }else{
        return size.height+61+40+18+40+175+40;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BoardDetailViewController *boardDetailViewController = [[BoardDetailViewController alloc] initWithNibName:@"BoardDetailViewController" bundle:nil];
    NSDictionary *dic = [uniArray objectAtIndex:indexPath.row];
    boardDetailViewController.dic = dic;
    
//    if ([[dic objectForKey:@"image"] isEqualToString:@""]) {
//        boardDetailViewController.image = nil;
//    }else{
//        boardDetailViewController.image = [uniTableView cellForRowAtIndexPath:indexPath].imageView.image;
//
////        boardDetailViewController.image = ((AsyncImageView *)[asyncImageView viewWithTag:indexPath.row]).imageView.image;
//    }
    
    boardDetailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:boardDetailViewController animated:YES];
}




#pragma - RSS

- (void)launch:(NSNotification *)notification
{
    [NSThread detachNewThreadSelector:@selector(threadStart) toTarget:self withObject:nil];
}

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
    
    NSLog(@"uniarray : %@", uniArray);
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
    NSString *category_url;
    NSString *id_url;
    
    
    if ([userDefaults objectForKey:@"region"]) {
        if ([userDefaults objectForKey:@"university"]) {
            category_url = @"2";
            id_url = [[userDefaults objectForKey:@"university"] objectForKey:@"id"];
            
        }else{
            category_url = @"1";
            id_url = [[userDefaults objectForKey:@"region"] objectForKey:@"id"];
        }
    }else{
        category_url = @"0";
        id_url = @"0";
    }
    
    NSString *returnAddress = [BOARDS_URL stringByAppendingFormat:@"category=%@&id=%@&page=%d/", category_url, id_url, page];
    
    return returnAddress;
}



#pragma - Scroll Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"%f", scrollView.contentOffset.y);
	[lazyImages scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
    
    int position = page*(ENTRYCOUNT*80-self.uniTableView.bounds.size.height);
    NSLog(@"%d", position);
    if (scrollView.contentOffset.y > position) {
        page +=1;
        [NSThread detachNewThreadSelector:@selector(updateThreadStart) toTarget:self withObject:nil];
    }
}

- (void)writeEntry:(id)sender
{
    WriteEntryViewController *writeEntryViewController = [[WriteEntryViewController alloc] initWithNibName:@"WriteEntryViewController" bundle:nil];
    [self.navigationController pushViewController:writeEntryViewController animated:YES];
}



- (void)commentBtn:(id)sender
{
    UITableViewCell *cell = (UITableViewCell*)[[sender superview] superview];
    NSIndexPath *indexPath = [self.uniTableView indexPathForCell:cell];
    
    BoardDetailViewController *boardDetailViewController = [[BoardDetailViewController alloc] initWithNibName:@"BoardDetailViewController" bundle:nil];
    NSDictionary *dic = [uniArray objectAtIndex:indexPath.row];
    boardDetailViewController.dic = dic;
    
    if ([[dic objectForKey:@"image"] isEqualToString:@""]) {
        boardDetailViewController.image = nil;
    }else{
//        boardDetailViewController.image = ((AsyncImageView *)[asyncImageView viewWithTag:indexPath.row]).imageView.image;
    }
    boardDetailViewController.kinds = 1;
    boardDetailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:boardDetailViewController animated:YES];
    
}


- (void)likeBtn:(id)sender
{
    UITableViewCell *cell = (UITableViewCell*)[[sender superview] superview];
    NSIndexPath *indexPath = [self.uniTableView indexPathForCell:cell];

    NSDictionary *dic = [[uniArray objectAtIndex:indexPath.row] copy];
    
    
    NSURL *url = [NSURL URLWithString:ENTRY_LIKE_URL];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request setShouldContinueWhenAppEntersBackground:YES];
    [request setPostValue:[dic objectForKey:@"id"] forKey:@"id"];
    [request setPostValue:[userDefaults objectForKey:@"user_id"] forKey:@"user_id"];
    [request setPostValue:[userDefaults objectForKey:@"value"] forKey:@"value"];
    request.tag = indexPath.row;
    [request setDelegate:self];
    [request startAsynchronous];
    
}




- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    
    NSString *result = [NSString stringWithString:[request responseString]];
    
    NSLog(@"%@", result);
    
    if ([result isEqualToString:@"200"]) {
        int index = request.tag;
        NSDictionary *dic = [uniArray objectAtIndex:index];
        NSMutableDictionary *newDic = [[NSMutableDictionary alloc] initWithCapacity:10];

        int newLikeInt = [[dic objectForKey:@"like"] intValue] +1;
        NSString *newLikeString = [NSString stringWithFormat:@"%d", newLikeInt];
        
        [newDic setObject:[dic objectForKey:@"title"] forKey:@"title"];
        [newDic setObject:[dic objectForKey:@"comment"] forKey:@"comment"];
        [newDic setObject:[dic objectForKey:@"created"] forKey:@"created"];
        [newDic setObject:[dic objectForKey:@"description"] forKey:@"description"];
        [newDic setObject:[dic objectForKey:@"id"] forKey:@"id"];
        [newDic setObject:[dic objectForKey:@"image"] forKey:@"image"];
        [newDic setObject:newLikeString forKey:@"like"];
        [newDic setObject:[dic objectForKey:@"pubDate"] forKey:@"pubDate"];
        [newDic setObject:[dic objectForKey:@"region"] forKey:@"region"];
        [newDic setObject:[dic objectForKey:@"university"] forKey:@"university"];
        
        
        [uniArray replaceObjectAtIndex:index withObject:newDic];
        
        [self.uniTableView reloadData];

    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:result delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
    // Use when fetching binary data
    //    NSData *responseData = [request responseData      ];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    //    NSError *error = [request error];
        
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"네트워크 상태를 확인하세요." delegate:self cancelButtonTitle:@"알겠음" otherButtonTitles:nil];
    [myAlert show];
}


@end
