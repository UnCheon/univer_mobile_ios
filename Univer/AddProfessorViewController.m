//
//  AddProfessorViewController.m
//  Univer
//
//  Created by 백 운천 on 12. 10. 9..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import "AddProfessorViewController.h"
#import "CategoryView.h"
#import "ASIFormDataRequest.h"

#define CATEGORY_REGION                              @"http://54.249.52.26/feeds/region/"
#define CATEGORY_UNIVERSITY                         @"http://54.249.52.26/feeds/univ/"
#define CATEGORY_COLLEGE                            @"http://54.249.52.26/feeds/college/"
#define ADD_PROFESSORS                            @"http://54.249.52.26/professors/"


@implementation AddProfessorViewController
@synthesize uniScrollView, regionBtn, universityBtn, collegeBtn, titleField, photoImageView;
@synthesize spiner, alert;

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
    UIImage *repeatingImage = [UIImage imageNamed:@"cm_background_pattern.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:repeatingImage];

    [super viewDidLoad];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    uniScrollView.contentSize = CGSizeMake(441, 44);
    uniScrollView.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height);
    [self.view addSubview:uniScrollView];
    
    [self addObject:titleField];
    
    

    photoImageView.layer.cornerRadius = 10.0;
    photoImageView.layer.masksToBounds = YES;
    photoImageView.layer.borderColor = [UIColor clearColor].CGColor;
    photoImageView.layer.borderWidth = 3.0;
    
    
    photoImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    photoImageView.layer.shadowOffset = CGSizeMake(0, 1);
    photoImageView.layer.shadowOpacity = 1;
    photoImageView.layer.shadowRadius = 1.0;
    photoImageView.clipsToBounds = NO;

    
    regionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 166, 21)];
    regionLabel.backgroundColor = [UIColor clearColor];
    regionLabel.textAlignment = UITextAlignmentCenter;
    regionLabel.textColor = [UIColor grayColor];
    regionLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];
    [regionBtn addSubview:regionLabel];
    
    universityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 166, 21)];
    universityLabel.backgroundColor = [UIColor clearColor];
    universityLabel.textAlignment = UITextAlignmentCenter;
    universityLabel.textColor = [UIColor grayColor];
    universityLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];
    [universityBtn addSubview:universityLabel];
    
    collegeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 166, 21)];
    collegeLabel.backgroundColor = [UIColor clearColor];
    collegeLabel.textAlignment = UITextAlignmentCenter;
    collegeLabel.textColor = [UIColor grayColor];
    collegeLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];
    [collegeBtn addSubview:collegeLabel];

    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [uniScrollView setContentOffset:CGPointMake(0, 0)];

    
    if (image != nil) {
        photoImageView.image = image;
    }else{
        photoImageView.image = [UIImage imageNamed:@"pf_no.png"];
    }
    
    regionDic = [userDefaults objectForKey:@"region"];
    universityDic = [userDefaults objectForKey:@"university"];
    collegeDic = [userDefaults objectForKey:@"college"];
    
    if (regionDic != nil) {
        if (universityDic != nil) {
            if (collegeDic != nil) {
                regionLabel.text = [regionDic objectForKey:@"title"];
                universityLabel.text = [universityDic objectForKey:@"title"];
                collegeLabel.text = [collegeDic objectForKey:@"title"];
            }else{
                regionLabel.text = [regionDic objectForKey:@"title"];
                universityLabel.text = [universityDic objectForKey:@"title"];
                collegeLabel.text = @"단과대학";
            }
        }else{
            regionLabel.text = [regionDic objectForKey:@"title"];
            universityLabel.text = @"대학교";
            collegeLabel.text = @"단과대학";
        }
    }else{
        regionLabel.text = @"지역";
        universityLabel.text = @"대학교";
        collegeLabel.text = @"단과대학";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)regionBtn:(id)sender
{
    CategoryView *categoryView = [[CategoryView alloc] initWithNibName:@"CategoryView" bundle:nil];
    
    categoryView.address = CATEGORY_REGION;
    categoryView.delegate = self;
    categoryView.kinds = 0;
    
    [self.navigationController pushViewController:categoryView animated:YES];
    
    
}

- (IBAction)universityBtn:(id)sender
{
    if (regionDic == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"학교 선택" message:@"지역을 먼저 선택해야 합니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }else{
        
        CategoryView *categoryView = [[CategoryView alloc] initWithNibName:@"CategoryView" bundle:nil];
        
        categoryView.delegate = self;
        categoryView.kinds = 1;
        
        categoryView.address = [CATEGORY_UNIVERSITY stringByAppendingFormat:@"%@/", [regionDic objectForKey:@"id"]];
        
        [self.navigationController pushViewController:categoryView animated:YES];
    }
}


- (IBAction)collegeBtn:(id)sender
{
    if (universityDic == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"단과대학 선택" message:@"대학교를 먼저 선택해야 합니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }else{
        CategoryView *categoryView = [[CategoryView alloc] initWithNibName:@"CategoryView" bundle:nil];
        
        categoryView.address = [CATEGORY_COLLEGE stringByAppendingFormat:@"%@/", [universityDic objectForKey:@"id"]];
        categoryView.delegate = self;
        categoryView.kinds = 2;
        
        [self.navigationController pushViewController:categoryView animated:YES];
    }
}

- (IBAction)photoBtn:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@""
                                      delegate:self
                                      cancelButtonTitle:@"취소"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"라이브러리에서 선택", @"사진 촬영하기", nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];

}


#pragma mark - UIImagePickerController Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.editing = YES;
    picker.delegate = self;
    
    if(buttonIndex == 0){
        picker.wantsFullScreenLayout = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        [self presentViewController:picker animated:YES completion:nil];
    }else if(buttonIndex == 1){
        picker.wantsFullScreenLayout = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)registerBtn:(id)sender
{
    if (regionDic == nil || universityDic==nil || collegeDic == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"지역, 학교, 단과대학을 선택하세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if ([titleField.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"이름을 써야 합니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }


    
    NSURL *url = [[NSURL alloc] initWithString:ADD_PROFESSORS];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request setShouldContinueWhenAppEntersBackground:YES];
    [request setPostValue:titleField.text forKey:@"name"];
    [request setPostValue:[regionDic objectForKey:@"id"] forKey:@"region"];
    [request setPostValue:[universityDic objectForKey:@"id"] forKey:@"university"];
    [request setPostValue:[collegeDic objectForKey:@"id"] forKey:@"college"];
    
    
    if (image) {
        NSString *fileName = @"photo.jpg";
        [request addPostValue:fileName forKey:@"image"];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.001);
        [request setData:imageData withFileName:fileName andContentType:@"image/jpeg" forKey:@"image"];
    }
    
    
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProfessor" object:self];

        [self.navigationController popViewControllerAnimated:(YES)];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:result delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
    // Use when fetching binary data
    //    NSData *responseData = [request responseData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    //    NSError *error = [request error];
    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"책 등록하기" message:@"네트워크 상태를 확인하세요." delegate:self cancelButtonTitle:@"알겠음" otherButtonTitles:nil];
    [myAlert show];
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
	CGFloat offsetY = 0;
	CGRect frame = [object convertRect:object.bounds toView:uniScrollView];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.25];
	
	if (object) {
		offsetY = frame.origin.y - 62;
		if (offsetY < 0.0f)
			offsetY = 0.0f;
	}
	
	[uniScrollView setContentOffset:CGPointMake(0, offsetY)];
	
	[UIView commitAnimations];
}


@end
