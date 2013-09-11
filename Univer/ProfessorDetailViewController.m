//
//  ProfessorDetailViewController.m
//  Univer
//
//  Created by 백 운천 on 12. 10. 5..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import "ProfessorDetailViewController.h"
#import "ProfessorEvaluateViewController.h"
#import "PentaView.h"
#import "ASIFormDataRequest.h"
#import "CustomCell.h"
#import "CustomTabbarController.h"


@implementation ProfessorDetailViewController
@synthesize uniTableView;
@synthesize professor_dic;
@synthesize image;
@synthesize spiner, alert;
@synthesize footerSpiner;

#define FEED_IMAGE                                       @"http://54.249.52.26"
#define COMMENT_URL                                      @"http://54.249.52.26/comments/professor/"
#define FEED_COMMENT                                     @"http://54.249.52.26/feeds/comments/professor/"
#define ENTRYCOUNT 30


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"교수정보";

        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 42, 44)];
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn1.frame = CGRectMake(0, 7, 36, 31);
        [btn1 setBackgroundImage:[UIImage imageNamed:@"pr_evaluation_btn_selected.png"] forState:UIControlStateHighlighted];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"pr_evaluation_btn_unselected.png"] forState:UIControlStateNormal];
        
        
        [btn1 addTarget:self action:@selector(evaluate:) forControlEvents:UIControlEventTouchUpInside];
        
        [rightView addSubview:btn1];
        
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        
        
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
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame =CGRectMake(0, 7, 31, 31);
        [btn2 setBackgroundImage:[UIImage imageNamed:@"cm_back_selected.png"] forState:UIControlStateHighlighted];
        [btn2 setBackgroundImage:[UIImage imageNamed:@"cm_back_unselected.png"] forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
        [leftView addSubview:btn2];
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
    
    UIImage *repeatingImage = [UIImage imageNamed:@"cm_background_pattern.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:repeatingImage];

    userDefaults = [NSUserDefaults standardUserDefaults];
    
    [(CustomTabbarController *)self.tabBarController hideNewTabbar];
    
    [super viewDidLoad];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yy"];
    year = [dateFormat stringFromDate:date];
    NSLog(@"year iphone : %@", year);

    
    footerSpiner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    [self.view addSubview:uniTableView];
    
    NSLog(@"tableview %f", uniTableView.frame.size.height);
    
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
    
    // Do any additional setup after loading the view from its nib.
    
    [NSThread detachNewThreadSelector:@selector(threadStart) toTarget:self withObject:nil];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [(CustomTabbarController *)self.tabBarController hideNewTabbar];
    uniTableView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-40);

}

- (void)viewWillDisappear:(BOOL)animated
{
    [(CustomTabbarController *)self.tabBarController showNewTabbar];
    [super viewWillDisappear:YES];
}

- (void)resignTextView
{
    content = textView.text;
    
    if ([content isEqualToString:@""]) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:COMMENT_URL];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request setShouldContinueWhenAppEntersBackground:YES];

    [request setPostValue:content forKey:@"comment"];
    [request setPostValue:[professor_dic objectForKey:@"id"] forKey:@"professor"];
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
        textView.text = @"";
        [NSThread detachNewThreadSelector:@selector(threadStart) toTarget:self withObject:nil];
        
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma -TableView Cycle


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count : %d", [uniArray count]);
    return [uniArray count] + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = nil;
    UITableViewCell *cell1 = nil;
    UITableViewCell *cell2 = nil;
    
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier1 = @"Cell1";
    static NSString *CellIdentifier2 = @"Cell2";
        
//    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
//    cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    
    UILabel *titleLabel;
    UILabel *commentTitleLabel;
    UILabel *commentContentLabel;
    UILabel *commentTimeLabel;
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 5, 107, 21)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = UITextAlignmentLeft;
        titleLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];
        [cell addSubview:titleLabel];
    }
    if (cell1 == nil) {
        cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        cell1.backgroundColor = [UIColor whiteColor];
    }
    if (cell2 == nil) {
        cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        cell2.backgroundColor = [UIColor whiteColor];
        
        commentTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, 30)];
        commentTitleLabel.backgroundColor = [UIColor clearColor];
        commentTitleLabel.textAlignment = UITextAlignmentLeft;
        commentTitleLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];

        commentContentLabel = [[UILabel alloc] init];
        commentContentLabel.backgroundColor = [UIColor clearColor];
        commentContentLabel.textAlignment = UITextAlignmentLeft;
        commentContentLabel.lineBreakMode = UILineBreakModeWordWrap;
        commentContentLabel.numberOfLines = 0;
        
        commentContentLabel.font = [UIFont fontWithName:@"NanumGothic" size:14];
        

        
        
        commentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 5, 100, 30)];
        commentTimeLabel.backgroundColor = [UIColor clearColor];
        commentTimeLabel.textAlignment = UITextAlignmentLeft;
        commentTimeLabel.font = [UIFont fontWithName:@"NanumGothic" size:11];
        commentTimeLabel.textColor = [UIColor grayColor];
        
        
        [cell2 addSubview:commentTitleLabel];
        [cell2 addSubview:commentContentLabel];
        [cell2 addSubview:commentTimeLabel];
        
    }
    

    
    if (indexPath.row == 0) {
        
        UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        photoBtn.frame = CGRectMake(10, 10, 60, 60);

        cell.imageView.image = image;
        
        titleLabel.text = [professor_dic objectForKey:@"title"];
        
        UILabel *count_label = [[UILabel alloc] initWithFrame:CGRectMake(105, 30, 200, 20)];
        count_label.backgroundColor = [UIColor clearColor];
        count_label.textAlignment = UITextAlignmentLeft;
        count_label.textColor = [UIColor grayColor];
        count_label.font = [UIFont fontWithName:@"NanumGothicBold" size:13];

        UILabel *like = [[UILabel alloc] initWithFrame:CGRectMake(105, 55, 200, 20)];
        
        
        count_label.text = [@"평가한 사람수 : " stringByAppendingString:[professor_dic objectForKey:@"count"]];
        
        
        like.text = [NSString stringWithFormat:@"추천 %@   비추천 %@   댓글수 %@", [professor_dic objectForKey:@"like"], [professor_dic objectForKey:@"dislike"], [professor_dic objectForKey:@"comment_count"]];
        like.backgroundColor = [UIColor clearColor];
        like.textAlignment = UITextAlignmentLeft;
        like.textColor = [UIColor grayColor];
        like.font = [UIFont fontWithName:@"NanumGothicBold" size:13];
        
        [cell addSubview:photoBtn];
        [cell addSubview:count_label];
        [cell addSubview:like];
        
        return cell;
        
    }else if (indexPath.row == 1){
        
        UIImageView *cellBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 316)];
        cellBackgroundView.image = [UIImage imageNamed:@"pr_evaluation_graph3_20"];
        [cell1 addSubview:cellBackgroundView];
        
        UILabel *qulityLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 205, 50, 20)];
        qulityLabel.backgroundColor = [UIColor clearColor];
        qulityLabel.text = @"강의 질";
        [cell1 addSubview:qulityLabel];

        UILabel *gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 249, 50, 20)];
        gradeLabel.backgroundColor = [UIColor clearColor];
        gradeLabel.text = @"학    점";
        [cell1 addSubview:gradeLabel];

        UILabel *reportLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 293, 50, 20)];
        reportLabel.backgroundColor = [UIColor clearColor];
        reportLabel.text = @"과    제";
        [cell1 addSubview:reportLabel];

        
        UILabel *attendanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 271, 50, 20)];
        attendanceLabel.backgroundColor = [UIColor clearColor];
        attendanceLabel.text = @"출    석";
        [cell1 addSubview:attendanceLabel];

        UILabel *personalityLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 227, 50, 20)];
        personalityLabel.backgroundColor = [UIColor clearColor];
        personalityLabel.text = @"인    성";
        [cell1 addSubview:personalityLabel];

        
        float count = [[professor_dic objectForKey:@"count"] floatValue];
        if (count == 0) {
            count =1;
        }
        
        DYRateView *qulityRate = [[DYRateView alloc] initWithFrame:CGRectMake(qulityLabel.frame.origin.x+100, qulityLabel.frame.origin.y, 200, 20)];
        qulityRate.rate = [[professor_dic objectForKey:@"quality"] floatValue] /count/2;
        qulityRate.alignment = RateViewAlignmentLeft;
        [cell1 addSubview:qulityRate];

        
        
        DYRateView *gradeRate = [[DYRateView alloc] initWithFrame:CGRectMake(gradeLabel.frame.origin.x+100, gradeLabel.frame.origin.y, 200, 20)];
        gradeRate.rate = [[professor_dic objectForKey:@"grade"] floatValue] /count/2;
        gradeRate.alignment = RateViewAlignmentLeft;
        [cell1 addSubview:gradeRate];
        
        DYRateView *reportRate = [[DYRateView alloc] initWithFrame:CGRectMake(reportLabel.frame.origin.x+100, reportLabel.frame.origin.y, 200, 20)];
        reportRate.rate = [[professor_dic objectForKey:@"report"] floatValue] /count/2;
        reportRate.alignment = RateViewAlignmentLeft;
        [cell1 addSubview:reportRate];

        
        DYRateView *attendanceRate = [[DYRateView alloc] initWithFrame:CGRectMake(attendanceLabel.frame.origin.x+100, attendanceLabel.frame.origin.y, 200, 20)];
        attendanceRate.rate = [[professor_dic objectForKey:@"attendance"] floatValue] /count/2;
        attendanceRate.alignment = RateViewAlignmentLeft;
        [cell1 addSubview:attendanceRate];
        
        
        DYRateView *personalityRate = [[DYRateView alloc] initWithFrame:CGRectMake(personalityLabel.frame.origin.x+100, personalityLabel.frame.origin.y, 200, 20)];
        personalityRate.rate = [[professor_dic objectForKey:@"personality"] floatValue] /count/2;
        personalityRate.alignment = RateViewAlignmentLeft;
        [cell1 addSubview:personalityRate];


        
        
        
        float r = 77;
        float mul = r/10;
        
        
        CALayer *layer = [CALayer layer];
        [layer setMasksToBounds:YES];
        [layer setBackgroundColor:[[UIColor redColor] CGColor]];
        [layer setCornerRadius:r];
        [layer setFrame:CGRectMake((320-r*2)/2, 20, r * 2, r * 2)];
        
//        [cell1.layer addSublayer:layer];
        
        float er = [[professor_dic objectForKey:@"report"] floatValue]/count *mul;
        float br = [[professor_dic objectForKey:@"quality"] floatValue]/count *mul;
        float cr = [[professor_dic objectForKey:@"grade"] floatValue]/count *mul;
        float dr = [[professor_dic objectForKey:@"attendance"] floatValue]/count *mul;
        float ar = [[professor_dic objectForKey:@"personality"] floatValue]/count *mul;
        
        
        PentaView *pentaView = [[PentaView alloc] initWithFrame:CGRectMake((320-r*2)/2, 20, r*2, r*2)];
        pentaView.frame = CGRectMake((320-r*2)/2, 30, r*2, r*2);
        
        
        
        CGPoint a = CGPointMake(ar*cos(0.3141594)+r, r-ar*sin(0.3141594));
        CGPoint b = CGPointMake(br*cos(1.570797)+r, r-br*sin(1.570797));
        CGPoint c = CGPointMake(cr*cos(2.8274346)+r, r-cr*sin(2.8274346));
        CGPoint d = CGPointMake(dr*cos(4.0840722)+r, r-dr*sin(4.0840722));
        CGPoint e = CGPointMake(er*cos(5.3407098)+r, r-er*sin(5.3407098));
        
        
        [pentaView pentaA:a B:b C:c D:d E:e];
        [cell1 addSubview:pentaView];
    
        return cell1;
        
    }else{
    
        NSDictionary *dic = [uniArray objectAtIndex:indexPath.row-2];
        NSString *text = [dic objectForKey:@"description"];
        
        
        
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
        
        commentTimeLabel.text = nowString;

        
        commentTitleLabel.text= [dic objectForKey:@"title"];
        
        
        
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(250.0f, 480.0f) lineBreakMode:UILineBreakModeWordWrap];
        
        commentContentLabel.frame = CGRectMake(20, 35, size.width + 5, size.height);
        commentContentLabel.numberOfLines = 0;
		commentContentLabel.lineBreakMode = UILineBreakModeWordWrap;

        commentContentLabel.text = text;


        
        return cell2;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [textView resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 90;
    }else if (indexPath.row == 1) {
        return 316;
    }else{
        
        NSString *body = [[uniArray objectAtIndex:indexPath.row-2] objectForKey:@"description"];
        
        CGSize size = [body sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(250.0, 480.0) lineBreakMode:UILineBreakModeWordWrap];
        
        return size.height+40;
    }
}


- (void)evaluate:(id)sender
{
    ProfessorEvaluateViewController *professorEvaluateViewController = [[ProfessorEvaluateViewController alloc] initWithNibName:@"ProfessorEvaluateViewController" bundle:nil];
    professorEvaluateViewController.professorDic = professor_dic;
    [self.navigationController pushViewController:professorEvaluateViewController animated:YES];
    
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
    
//    NSUInteger index;
//	if([uniArray count] > 0)
//	{
//        index= [uniArray count] + 2;
//    }else if ([uniArray count] == 0)
//    {
//        index = 2;
//    }
//    
//    [uniTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];

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



#pragma makr - XML parsing

- (void)threadStart
{
    @autoreleasepool {
        page = 1;
        [uniArray removeAllObjects];
        [self.uniTableView reloadData];
        NSString *feedAddress = [FEED_COMMENT stringByAppendingFormat:@"professor_id=%@&page=%d/", [professor_dic objectForKey:@"id"], page];
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


- (void)updateThreadStart
{
    @autoreleasepool {
        [footerSpiner startAnimating];
        [updateArray removeAllObjects];
        NSString *feedAddress = [FEED_COMMENT stringByAppendingFormat:@"professor_id=%@&page=%d/", [professor_dic objectForKey:@"id"], page];
        [self updateRSSFeed:feedAddress];
        [self.uniTableView reloadData];
        [footerSpiner stopAnimating];
    }
}

- (void)updateRSSFeed:(NSString *)feedAddress
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
        [updateArray addObject:[newsItem copy]];
    }
    NSLog(@"%d", [updateArray count]);
    [uniArray addObjectsFromArray:updateArray];
    
    NSLog(@"%d", [uniArray count]);
}



#pragma refresh

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)_refreshControl
{
    double delayInSeconds = 1.0;
    [NSThread detachNewThreadSelector:@selector(threadStart) toTarget:self withObject:nil];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
    });
}




#pragma - Scroll Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"%f", scrollView.contentOffset.y);
    
    int position = page*(ENTRYCOUNT*60-self.uniTableView.bounds.size.height)+620;
    NSLog(@"%d", position);
    if (scrollView.contentOffset.y > position) {
        page +=1;
        [NSThread detachNewThreadSelector:@selector(updateThreadStart) toTarget:self withObject:nil];
    }
}





@end
