//
//  ProfessorEvaluateViewController.m
//  Univer
//
//  Created by 백 운천 on 12. 10. 5..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import "ProfessorEvaluateViewController.h"
#import "ASIFormDataRequest.h"

#define EVALUATE_URL                               @"http://54.249.52.26/evaluations/"

@implementation ProfessorEvaluateViewController
@synthesize uniScrollView, professorDic, textView;
@synthesize spiner, alert;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        quality_string = @"0";
        personality_string = @"0";
        report_string = @"0";
        grade_string = @"0";
        attendance_string = @"0";
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
        
        // non selecttion
        like = @"2";
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
    userDefaults = [NSUserDefaults standardUserDefaults];

    UIImage *repeatingImage = [UIImage imageNamed:@"cm_background_pattern.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:repeatingImage];

    [super viewDidLoad];
    
    [self addObject:textView];
    
    likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    likeBtn.frame = CGRectMake(75, 240, 85, 32);
    [likeBtn setImage:[UIImage imageNamed:@"pf_register_cc_unselected.png"] forState:UIControlStateNormal];
    [likeBtn setImage:[UIImage imageNamed:@"pf_register_cc_selected.png"] forState:UIControlStateSelected];
    [likeBtn setImage:[UIImage imageNamed:@"pf_register_cc_selected.png"] forState:UIControlStateHighlighted];
    likeBtn.tag = 1;
    [likeBtn addTarget:self action:@selector(segmentBtn:) forControlEvents:UIControlEventAllTouchEvents];
    
    
    disLikeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    disLikeBtn.frame = CGRectMake(likeBtn.frame.origin.x+likeBtn.frame.size.width, likeBtn.frame.origin.y, 85, 32);
    [disLikeBtn setImage:[UIImage imageNamed:@"pf_register_bcc_unselected.png"] forState:UIControlStateNormal];
    [disLikeBtn setImage:[UIImage imageNamed:@"pf_register_bcc_selected.png"] forState:UIControlStateSelected];
    [disLikeBtn setImage:[UIImage imageNamed:@"pf_register_bcc_selected.png"] forState:UIControlStateHighlighted];
    [disLikeBtn addTarget:self action:@selector(segmentBtn:) forControlEvents:UIControlEventTouchUpInside];
    disLikeBtn.tag = 2;
    
    [uniScrollView addSubview:likeBtn];
    [uniScrollView addSubview:disLikeBtn];
    
    
    UILabel *textViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, likeBtn.frame.origin.y+likeBtn.frame.size.height+27, 100, 20)];
    textViewLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:16];
    textViewLabel.text = @"한줄평가";
    textViewLabel.backgroundColor = [UIColor clearColor];
    [uniScrollView addSubview:textViewLabel];

    uniScrollView.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height);


    uniScrollView.contentSize = CGSizeMake(320, 1030);
    [self.view addSubview:uniScrollView];
    [self setUpEditableRateView];
    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUpEditableRateView {
    DYRateView *quality_star = [[DYRateView alloc] initWithFrame:CGRectMake(80, 20, self.view.bounds.size.width - 100, 20) fullStar:[UIImage imageNamed:@"StarFullLarge.png"] emptyStar:[UIImage imageNamed:@"StarEmptyLarge.png"]];
    quality_star.padding = 20;
    quality_star.alignment = RateViewAlignmentCenter;
    quality_star.editable = YES;
    quality_star.delegate = self;
    quality_star.tag = 1;
    
    UILabel *qualityLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, quality_star.frame.origin.y , 50, 20)];
    qualityLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:16];
    qualityLabel.text = @"강의 질";
    
    
    DYRateView *personality_star = [[DYRateView alloc] initWithFrame:CGRectMake(80, 60, self.view.bounds.size.width - 100, 20) fullStar:[UIImage imageNamed:@"StarFullLarge.png"] emptyStar:[UIImage imageNamed:@"StarEmptyLarge.png"]];
    personality_star.padding = 20;
    personality_star.alignment = RateViewAlignmentCenter;
    personality_star.editable = YES;
    personality_star.delegate = self;
    personality_star.tag = 2;
    
    UILabel *personalityLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, personality_star.frame.origin.y , 50, 20)];
    personalityLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:16];
    personalityLabel.text = @"인   성";

    
    
    DYRateView *report_star = [[DYRateView alloc] initWithFrame:CGRectMake(80, 100, self.view.bounds.size.width - 100, 20) fullStar:[UIImage imageNamed:@"StarFullLarge.png"] emptyStar:[UIImage imageNamed:@"StarEmptyLarge.png"]];
    report_star.padding = 20;
    report_star.alignment = RateViewAlignmentCenter;
    report_star.editable = YES;
    report_star.delegate = self;
    report_star.tag = 3;
    
    UILabel *reportLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, report_star.frame.origin.y , 50, 20)];
    reportLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:16];
    reportLabel.text = @"과   제";

    
    
    DYRateView *grade_star = [[DYRateView alloc] initWithFrame:CGRectMake(80, 140, self.view.bounds.size.width - 100, 20) fullStar:[UIImage imageNamed:@"StarFullLarge.png"] emptyStar:[UIImage imageNamed:@"StarEmptyLarge.png"]];
    grade_star.padding = 20;
    grade_star.alignment = RateViewAlignmentCenter;
    grade_star.editable = YES;
    grade_star.delegate = self;
    grade_star.tag = 4;
    
    UILabel *gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, grade_star.frame.origin.y , 50, 20)];
    gradeLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:16];
    gradeLabel.text = @"학   점";

    
    DYRateView *attendance_star = [[DYRateView alloc] initWithFrame:CGRectMake(80, 180, self.view.bounds.size.width - 100, 20) fullStar:[UIImage imageNamed:@"StarFullLarge.png"] emptyStar:[UIImage imageNamed:@"StarEmptyLarge.png"]];
    attendance_star.padding = 20;
    attendance_star.alignment = RateViewAlignmentCenter;
    attendance_star.editable = YES;
    attendance_star.delegate = self;
    attendance_star.tag = 5;
    
    UILabel *attendanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, attendance_star.frame.origin.y , 50, 20)];
    attendanceLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:16];
    attendanceLabel.text = @"출   석";

    
    
    [self.uniScrollView addSubview:quality_star];
    [self.uniScrollView addSubview:personality_star];
    [self.uniScrollView addSubview:report_star];
    [self.uniScrollView addSubview:grade_star];
    [self.uniScrollView addSubview:attendance_star];
    
    [self.uniScrollView addSubview:qualityLabel];
    [self.uniScrollView addSubview:personalityLabel];
    [self.uniScrollView addSubview:reportLabel];
    [self.uniScrollView addSubview:gradeLabel];
    [self.uniScrollView addSubview:attendanceLabel];
    
    // Set up a label view to display rate
}



- (void)rateView:(DYRateView *)rateView changedToNewRate:(NSNumber *)rate {
//    self.rateLabel.text = [NSString stringWithFormat:@"Rate: %d", rate.intValue];
    if (rateView.tag == 1) {
        quality_string = [NSString stringWithFormat:@"%d", rate.intValue*2];
    }else if (rateView.tag == 2){
        personality_string = [NSString stringWithFormat:@"%d", rate.intValue*2];
    }else if (rateView.tag == 3){
        report_string = [NSString stringWithFormat:@"%d", rate.intValue*2];
    }else if (rateView.tag == 4){
        grade_string = [NSString stringWithFormat:@"%d", rate.intValue*2];
    }else if (rateView.tag == 5){
        attendance_string = [NSString stringWithFormat:@"%d", rate.intValue*2];
    }
}


- (void)segmentBtn:(UIButton *)btn
{
    // likeBtn 1 ,  disLikeBtn 2
    if (btn.tag == 1) {
        likeBtn.selected = YES;
        disLikeBtn.selected = NO;
        like = @"1";
    }else{
        likeBtn.selected = NO;
        disLikeBtn.selected = YES;
        like = @"0";
    }
    
}

- (IBAction)evaluate:(id)sender
{

    if ([like isEqualToString:@"2"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Evaluate" message:@"추천/비추천 중 하나를 선택해야 합니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    NSURL *url = [NSURL URLWithString:EVALUATE_URL];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request setShouldContinueWhenAppEntersBackground:YES];
    [request setPostValue:[professorDic objectForKey:@"id"] forKey:@"professor"];
    [request setPostValue:quality_string forKey:@"quality"];
    [request setPostValue:personality_string forKey:@"personality"];
    [request setPostValue:report_string forKey:@"report"];
    [request setPostValue:grade_string forKey:@"grade"];
    [request setPostValue:attendance_string forKey:@"attendance"];
    [request setPostValue:[userDefaults objectForKey:@"user_id"] forKey:@"user_id"];
    [request setPostValue:[userDefaults objectForKey:@"value"] forKey:@"value"];
    NSLog(@"%@", like);
    [request setPostValue:like forKey:@"like"];
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
    [alert dismissWithClickedButtonIndex:0 animated:YES];

    NSString *result = [NSString stringWithString:[request responseString]];
    NSLog(@"%@", result);
    if ([result intValue] == 200) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProfessor" object:self];

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"평가되었습니다." message:nil delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        alertView.tag = 1;
        [alertView show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"error." message:result delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        alertView.tag = 0;
        [alertView show];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    //    NSError *error = [request error];
    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"책 등록하기" message:@"네트워크 상태를 확인하세요." delegate:self cancelButtonTitle:@"알겠음" otherButtonTitles:nil];
    [myAlert show];
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        return;
    }
}



#pragma mark - TextFeild Delegate
// TextField View Delegate
// 포커스 왔을때...
-(BOOL) textFieldShouldBeginEditing:(UITextField*)textField {
    
    [self animateView:textField];
	
	
	return YES;
}
// 포커스 사라질때...
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	return YES;
}
// 리턴키 이벤트
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	return YES;
}
// 글자수 제한은 이곳에서
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	return YES;
}

#pragma mark - TextField auto scroll
//~TextField View Delegate
// 포커스가 TextField의 위치Y값을 기준으로 스크롤뷰 or 뷰의 위치 변경
- (void)animateView:(UITextField *)object
{
	// 버튼 좌표를 윈도우 스크린 좌표로 변환 시킴
//	CGFloat offsetY = 0;
//	CGRect frame = [object convertRect:object.bounds toView:uniScrollView];
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:0.25];
//	
//	if (object) {
//		offsetY = frame.origin.y - 62;
//		if (offsetY < 0.0f)
//			offsetY = 0.0f;
//	}
//		
//	[UIView commitAnimations];
//    [uniScrollView setContentOffset:CGPointMake(0, offsetY)];

}



#pragma mark - TextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)_textView
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.25];
    [uniScrollView setContentOffset:CGPointMake(0, 600)];
	[UIView commitAnimations];
    
    CGFloat offsetY = 0;
	CGRect frame = [textView convertRect:textView.bounds toView:uniScrollView];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.25];
	
	if (textView) {
		offsetY = frame.origin.y - 62;
		if (offsetY < 0.0f)
			offsetY = 0.0f;
	}
	
	
	[UIView commitAnimations];
    [uniScrollView setContentOffset:CGPointMake(0, offsetY)];


}





@end
