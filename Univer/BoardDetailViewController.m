//
//  BoardDetailViewController.m
//  Univer
//
//  Created by 백 운천 on 12. 11. 2..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import "BoardDetailViewController.h"
#import "ASIFormDataRequest.h"
#import "CustomTabbarController.h"

@implementation BoardDetailViewController
@synthesize uniTableView;
@synthesize image, dic, kinds;
@synthesize alert, spiner;


#define ENTRYCOUNT 30
#define COMMENT_URL                                  @"http://54.249.52.26/comments/entry/"
#define ENTRY_COMMENT_FEED                             @"http://54.249.52.26/feeds/comments/entry/"
#define IMAGE_BASE                               @"http://54.249.52.26/media/"



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShow:)
													 name:UIKeyboardWillShowNotification
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillHide:)
													 name:UIKeyboardWillHideNotification
												   object:nil];
        
        uniArray = [[NSMutableArray alloc] initWithCapacity:10];
        updateArray = [[NSMutableArray alloc] initWithCapacity:10];
        
        page = 1;
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 31, 44)];
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame =CGRectMake(0, 7, 31, 31);
        [btn1 setBackgroundImage:[UIImage imageNamed:@"cm_back_selected.png"] forState:UIControlStateHighlighted];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"cm_back_unselected.png"] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
        [leftView addSubview:btn1];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
        self.navigationItem.leftBarButtonItem = leftItem;
        
        userDefaults = [NSUserDefaults standardUserDefaults];
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
    UIImage *repeatingImage = [UIImage imageNamed:@"cm_background_pattern.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:repeatingImage];

    [super viewDidLoad];
    [(CustomTabbarController *)self.tabBarController hideNewTabbar];
    
    uniTableView = [[UITableView alloc] init];
    uniTableView.backgroundColor = [UIColor clearColor];
    uniTableView.delegate = self;
    uniTableView.dataSource = self;
    
    NSLog(@"%@", image);

    [self.view addSubview:uniTableView];
    
    refreshControl= [[ODRefreshControl alloc] initInScrollView:self.uniTableView];
    
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];

    
    // Growing TextView;
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, 320, 40)];
    
	textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 240, 40)];
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	textView.minNumberOfLines = 1;
	textView.maxNumberOfLines = 6;
	textView.returnKeyType = UIReturnKeyGo; //just as an example
	textView.font = [UIFont systemFontOfSize:15.0f];
	textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    
    // textView.text = @"test\n\ntest";
	// textView.animateHeightChange = NO; //turns off animation
    
    [self.view addSubview:containerView];
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(5, 0, 248, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [containerView addSubview:imageView];
    [containerView addSubview:textView];
    [containerView addSubview:entryImageView];
    
    UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(containerView.frame.size.width - 69, 8, 63, 27);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[doneBtn setTitle:@"전송" forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
	[containerView addSubview:doneBtn];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [NSThread detachNewThreadSelector:@selector(threadStart) toTarget:self withObject:nil];
    
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yy"];
    year = [dateFormat stringFromDate:date];
    NSLog(@"year iphone : %@", year);


    
    

    imageDataView = [[UIImageView alloc] initWithFrame:CGRectMake(-5, 80, 310, 460)];
    imageDataView.contentMode = UIViewContentModeScaleAspectFit;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
	uniTableView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-40);
    if (kinds == 1) {
        [textView becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [(CustomTabbarController *)self.tabBarController showNewTabbar];

    [super viewWillDisappear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)resignTextView
{
    
    content = textView.text;
    
    
    NSURL *url = [NSURL URLWithString:COMMENT_URL];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request setShouldContinueWhenAppEntersBackground:YES];
    
    [request setPostValue:content forKey:@"content"];
    [request setPostValue:[dic objectForKey:@"id"] forKey:@"id"];
    [request setPostValue:[userDefaults objectForKey:@"user_id"] forKey:@"user_id"];
    [request setPostValue:[userDefaults objectForKey:@"value"] forKey:@"value"];
    [request setDelegate:self];
    [request startAsynchronous];
    
    
    alert = [[UIAlertView alloc] initWithTitle:@"잠시만 기다려 주세요.." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    
    spiner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spiner.center = CGPointMake(alert.bounds.size.width/2, alert.bounds.size.height/2+10);
    [spiner startAnimating];
    [alert addSubview:spiner];
     
    
}




- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
    NSString *result = [NSString stringWithString:[request responseString]];
    
    NSLog(@"%@", result);
    
    if ([result isEqualToString:@"200"]) {
        NSDictionary *commentDic = [NSDictionary dictionaryWithObjectsAndKeys:@"백운천", @"title", content, @"description", nil];
        textView.text = @"";
        [uniArray addObject:commentDic];
        [uniTableView reloadData];
        
        
//        NSUInteger index;
//        if([uniArray count] > 0)
//        {
//            index= [uniArray count] + 2;
//        }else if ([uniArray count] == 0)
//        {
//            index = 2;
//        }
//        
//        [uniTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        [textView resignFirstResponder];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:result delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    //    NSError *error = [request error];
    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"댓글쓰기" message:@"네트워크 상태를 확인하세요." delegate:self cancelButtonTitle:@"알겠음" otherButtonTitles:nil];
    [myAlert show];
}




#pragma Keyboard notification

- (void)keyboardWillShow:(NSNotification *)notif {
    
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
	
    
	[UIView commitAnimations];
    
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
    uniTableView.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height-keyboardBounds.size.height-40);
    
	// set views with new info
	containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
    

}


-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	containerView.frame = containerFrame;
	uniTableView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-40);
	// commit animations
	[UIView commitAnimations];
}

#pragma mark - GrowingTextView

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	containerView.frame = r;
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



#pragma -TableView Cycle


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [uniArray count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier2 = @"Cell2";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    
    UILabel *nicknameLabel;
    UILabel *createdLabel;
    UILabel *categoryLabel;
    UILabel *contentLabel;
    UIView *cellView;
    UIView *cellSubView;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];

        nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
        nicknameLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];
        
        createdLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, nicknameLabel.frame.origin.y, 100, 30)];
        createdLabel.backgroundColor = [UIColor clearColor];
        createdLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:11];
        createdLabel.textColor = [UIColor grayColor];
        
        categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(nicknameLabel.frame.origin.x, createdLabel.frame.origin.y+30, 200, 30)];
        categoryLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:12];
        categoryLabel.textColor = [UIColor grayColor];
        
        contentLabel = [[UILabel alloc] init];
        contentLabel.lineBreakMode = UILineBreakModeHeadTruncation;
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:14];
        
        cellView = [[UIView alloc] init];
        cellView.backgroundColor = [UIColor whiteColor];
        
        [cellView addSubview:nicknameLabel];
        [cellView addSubview:createdLabel];
        [cellView addSubview:categoryLabel];
        [cellView addSubview:contentLabel];
//        [cellView addSubview:imageDataView];
        

        cellSubView = [[UIView alloc] init];
        cellSubView.backgroundColor = [UIColor lightTextColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    
    
    
    UIView *commentView;
    UILabel *commentTitleLabel;
    UILabel *commentContentLabel;
    UILabel *commentTimeLabel;

    
    if (cell2 == nil) {
        cell2 = [[UITableViewCell alloc] init];
        [cell2 setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        commentView = [[UIView alloc] init];
        commentView.backgroundColor = [UIColor whiteColor];
        
        commentTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, 30)];
        commentTitleLabel.backgroundColor = [UIColor clearColor];
        commentTitleLabel.textAlignment = UITextAlignmentLeft;
        commentTitleLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];
        
        commentContentLabel = [[UILabel alloc] init];
        commentContentLabel.backgroundColor = [UIColor clearColor];
        commentContentLabel.textAlignment = UITextAlignmentLeft;
        commentContentLabel.font = [UIFont fontWithName:@"NanumGothic" size:14];
        
        
        
        
        commentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 5, 100, 30)];
        commentTimeLabel.backgroundColor = [UIColor clearColor];
        commentTimeLabel.textAlignment = UITextAlignmentLeft;
        commentTimeLabel.font = [UIFont fontWithName:@"NanumGothic" size:11];
        commentTimeLabel.textColor = [UIColor grayColor];
        
        [cell2 addSubview:commentView];
        [cell2 addSubview:commentTitleLabel];
        [cell2 addSubview:commentContentLabel];
        [cell2 addSubview:commentTimeLabel];

    }
    

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

    
    
    
    
    if (indexPath.row == 0) {
        nicknameLabel.text = [dic objectForKey:@"title"];
        
        createdLabel.text = nowString;
        categoryLabel.text = [NSString stringWithFormat:@"%@ / %@", [dic objectForKey:@"region"], [dic objectForKey:@"university"]];
        
        contentLabel.text = [dic objectForKey:@"description"];

        NSLog(@"%@", [dic objectForKey:@"description"]);
        
        CGSize size = [[dic objectForKey:@"description"] sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(280.0f, 11000.0f) lineBreakMode:UILineBreakModeTailTruncation];
        
        
        if ([[dic objectForKey:@"image"] isEqualToString:@""]) {
            contentLabel.frame = CGRectMake(10, 80, 280, size.height);
            cellView.frame = CGRectMake(10, 10, 300, contentLabel.frame.size.height + contentLabel.frame.origin.y+20);
        }else{
            contentLabel.frame = CGRectMake(10, 80+480, 280, size.height);
            cellView.frame = CGRectMake(10, 10, 300, contentLabel.frame.size.height + contentLabel.frame.origin.y+20);
            [cellView addSubview:imageDataView];
        }
        
        
        [cell addSubview:cellView];
        
        
        
        cellSubView.frame =CGRectMake(9, cellView.frame.origin.y+cellView.frame.size.height, 302, 40);
        
        
        UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];


        likeBtn.frame = CGRectMake(9, 0, 50, 40);
        [likeBtn setTitle:@"좋아요" forState:UIControlStateNormal];
        [likeBtn setTitleColor:[UIColor colorWithRed:0.376471 green:0.666667 blue:0.760784 alpha:1] forState:UIControlStateNormal];
        likeBtn.titleLabel.font = [UIFont systemFontOfSize:14];

        UIImageView *likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(170, 9, 20, 20)];
        UIImageView *commentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(230, 9, 20, 20)];
        likeImageView.image = [UIImage imageNamed:@"com_like.png"];
        commentImageView.image = [UIImage imageNamed:@"com_re.png"];
        
        UILabel *likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 9, 40, 20)];
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 9, 40, 20)];
        likeLabel.backgroundColor = [UIColor clearColor];
        commentLabel.backgroundColor = [UIColor clearColor];
        likeLabel.text = [dic objectForKey:@"like"];
        commentLabel.text = [dic objectForKey:@"comment"];
        
        [cellSubView addSubview:likeBtn];
        [cellSubView addSubview:likeLabel];
        [cellSubView addSubview:commentLabel];
        [cellSubView addSubview:likeImageView];
        [cellSubView addSubview:commentImageView];
        
        [cell addSubview:cellView];
        [cell addSubview:cellSubView];
        
        return cell;

    }
    else{
        NSDictionary *dic_ = [uniArray objectAtIndex:indexPath.row-1];
        
        
        
        NSString *timeString = [dic_ objectForKey:@"created"];
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
        
        commentTimeLabel.text = nowString;
        
        
        commentTitleLabel.text= [dic_ objectForKey:@"title"];
        
        
        
        NSString *text = [dic_ objectForKey:@"description"];
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(250.0f, 480.0f) lineBreakMode:UILineBreakModeWordWrap];
        
        commentView.frame = CGRectMake(10, 0, 300, size.height+43);
        
        
        commentContentLabel.frame = CGRectMake(20, 35, size.width + 5, size.height);
        commentContentLabel.numberOfLines = 0;
		commentContentLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        commentContentLabel.text = text;
        
        
        
        return cell2;
    }

    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *dic = [uniArray objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        NSString *content = [dic objectForKey:@"description"];
        
        CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(280.0f, 11000.0f) lineBreakMode:UILineBreakModeTailTruncation];
        
        
        if ([[dic objectForKey:@"image"] isEqualToString:@""]) {
            return size.height+154;
        }else{
            return size.height+154+480;
        }

    }else{
        NSString *content = [[uniArray objectAtIndex:indexPath.row-1] objectForKey:@"description"];
        CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(280.0f, 11000.0f) lineBreakMode:UILineBreakModeTailTruncation];

        return size.height + 42;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [textView resignFirstResponder];
}




#pragma - RSS


- (void)threadStart
{
    
    NSLog(@"%@", dic);
    if (imageDataView.image == nil) {
        NSURL *url = [NSURL URLWithString:[IMAGE_BASE stringByAppendingString:[dic objectForKey:@"image"]]];
        
        NSLog(@"url : %@", url);
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        imageDataView.image = [UIImage imageWithData:imageData];
        [imageDataView reloadInputViews];
//        [imageDataView setNeedsLayout];
        
        
    }
    
    page = 1;
    @autoreleasepool {
        [uniArray removeAllObjects];
        [self.uniTableView reloadData];
        NSString *feedAddress = [ENTRY_COMMENT_FEED stringByAppendingFormat:@"entry_id=%@&page=%d/", [dic objectForKey:@"id"], page];
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
//        NSString *feedAddress = [self returnAddress];
//        [self updateRSSFeed:feedAddress];
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



#pragma - Scroll Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"%f", scrollView.contentOffset.y);
    
    int position = page*(ENTRYCOUNT*80-self.uniTableView.bounds.size.height);
    NSLog(@"%d", position);
    if (scrollView.contentOffset.y > position) {
        page +=1;
        [NSThread detachNewThreadSelector:@selector(updateThreadStart) toTarget:self withObject:nil];
    }
}





@end


