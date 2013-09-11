//
//  WriteEntryViewController.m
//  Univer
//
//  Created by 백 운천 on 12. 11. 2..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import "WriteEntryViewController.h"
#import "CategoryView.h"
#import "ASIFormDataRequest.h"

#define CATEGORY_REGION                          @"http://54.249.52.26/feeds/region/"
#define CATEGORY_UNIVERSITY                      @"http://54.249.52.26/feeds/univ/"
#define WRITE_ENTRY                              @"http://54.249.52.26/entry/"

@implementation WriteEntryViewController
@synthesize textView, imageView;
@synthesize regionBtn, universityBtn;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 31, 44)];
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 setImage:[UIImage imageNamed:@"pf_ok_selected.png"] forState:UIControlStateHighlighted];
        [btn2 setImage:[UIImage imageNamed:@"pf_ok_unselected.png"] forState:UIControlStateNormal];
        
        btn2.frame = CGRectMake(0, 7, 31, 31);
        
        
        [btn2 addTarget:self action:@selector(registerBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [rightView addSubview:btn2];
        
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;

        
        userDefaults = [NSUserDefaults standardUserDefaults];

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

    [super viewDidLoad];
    [textView becomeFirstResponder];
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

    
    if (image != nil) {
        imageView.image = image;
    }else{
        imageView.image = [UIImage imageNamed:@"com_image.png"];
    }

    
    regionDic = [userDefaults objectForKey:@"region"];
    universityDic = [userDefaults objectForKey:@"university"];
    
    
    if (regionDic != nil) {
        if (universityDic != nil) {
            regionLabel.text = [regionDic objectForKey:@"title"];
            universityLabel.text = [universityDic objectForKey:@"title"];
            
        }else{
            regionLabel.text = [regionDic objectForKey:@"title"];
            universityLabel.text = @"대학교";
        }
    }else{
        regionLabel.text = @"지역";
        universityLabel.text = @"대학교";
    }
    
    
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)cancelBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)registerBtn:(id)sender
{
    if (regionDic == nil || universityDic==nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"지역, 학교, 단과대학을 선택하세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if ([textView.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"이름을 써야 합니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    NSURL *url = [[NSURL alloc] initWithString:WRITE_ENTRY];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request setShouldContinueWhenAppEntersBackground:YES];
    [request setPostValue:textView.text forKey:@"content"];
    [request setPostValue:[regionDic objectForKey:@"id"] forKey:@"region"];
    [request setPostValue:[universityDic objectForKey:@"id"] forKey:@"university"];
    [request setPostValue:[userDefaults objectForKey:@"user_id"] forKey:@"user_id"];
    [request setPostValue:[userDefaults objectForKey:@"value"] forKey:@"value"];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadEntry" object:self];

        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"등록이 완료되었습니다. " message:nil delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        myAlert.tag = 2;
        [myAlert show];
        
        
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
    
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"글쓰기" message:@"네트워크 상태를 확인하세요." delegate:self cancelButtonTitle:@"알겠음" otherButtonTitles:nil];
    [myAlert show];
}


-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex ==0){
        if (alertView.tag == 2) {
        [self.navigationController popViewControllerAnimated:YES];
        }
    }
}



@end
