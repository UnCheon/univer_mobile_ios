//
//  RegisterBookViewController.m
//  Univer
//
//  Created by 백 운천 on 12. 10. 3..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import "RegisterBookViewController.h"
#import "CategoryView.h"
#import "ASIFormDataRequest.h"

#define BOOK_URL                    @"http://54.249.52.26/books/"
#define CATEGORY_REGION                              @"http://54.249.52.26/feeds/region/"
#define CATEGORY_UNIVERSITY                         @"http://54.249.52.26/feeds/univ/"
#define CATEGORY_COLLEGE                            @"http://54.249.52.26/feeds/college/"
#define NAVER_ISBN                                  @"http://openapi.naver.com/search?key=159707e8f9723afcda699c6c3e6af7cf&query=art&display=10&start=1&target=book_adv&d_isbn="




@implementation RegisterBookViewController
@synthesize scrollView, uni_btn, coll_btn, region_btn, photo_btn;
@synthesize title_field, publisher_field, author_field, created_field, original_field, discount_field, content_view;
@synthesize alert, spiner;
@synthesize meetBtn, parcelBtn;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"등록";
        isbnDic = [[NSMutableDictionary alloc] initWithCapacity:5];
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
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:repeatingImage];

    
    [super viewDidLoad];
    meet_bool = NO;
    parcel_bool = NO;
    userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:0 forKey:@"image"];
    
    saleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saleBtn.frame = CGRectMake(124, 20, 70, 28);
    [saleBtn setImage:[UIImage imageNamed:@"bk_rg_sale_unselected.png"] forState:UIControlStateNormal];
    [saleBtn setImage:[UIImage imageNamed:@"bk_rg_sale_selected.png"] forState:UIControlStateSelected];
    [saleBtn setImage:[UIImage imageNamed:@"bk_rg_sale_selected.png"] forState:UIControlStateHighlighted];
    [saleBtn addTarget:self action:@selector(segBtn:) forControlEvents:UIControlEventTouchUpInside];
    saleBtn.tag = 1;
    saleBtn.selected = YES;
    sell = @"1";

    
    purchaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    purchaseBtn.frame = CGRectMake(saleBtn.frame.origin.x+saleBtn.frame.size.width, saleBtn.frame.origin.y, saleBtn.frame.size.width, saleBtn.frame.size.height);
    [purchaseBtn setImage:[UIImage imageNamed:@"bk_rg_purchase_unselected.png"] forState:UIControlStateNormal];
    [purchaseBtn setImage:[UIImage imageNamed:@"bk_rg_purchase_selected.png"] forState:UIControlStateSelected];
    [purchaseBtn setImage:[UIImage imageNamed:@"bk_rg_purchase_selected.png"] forState:UIControlStateHighlighted];
    [purchaseBtn addTarget:self action:@selector(segBtn:) forControlEvents:UIControlEventTouchUpInside];
    purchaseBtn.tag = 2;

    
    [scrollView addSubview:saleBtn];
    [scrollView addSubview:purchaseBtn];
    
    
    scrollView.contentSize = CGSizeMake(320, 1000);
    scrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:scrollView];
    
    [self removeAllObjects];
	[self addObject:title_field];
	[self addObject:publisher_field];
	[self addObject:author_field];
	[self addObject:created_field];
    [self addObject:original_field];
    [self addObject:discount_field];
    [self addObject_:content_view];
    
    // Do any additional setup after loading the view from its nib.
    
    
    regionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 166, 21)];
    regionLabel.backgroundColor = [UIColor clearColor];
    regionLabel.textAlignment = UITextAlignmentCenter;
    regionLabel.textColor = [UIColor grayColor];
    regionLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];
    [region_btn addSubview:regionLabel];
    
    universityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 166, 21)];
    universityLabel.backgroundColor = [UIColor clearColor];
    universityLabel.textAlignment = UITextAlignmentCenter;
    universityLabel.textColor = [UIColor grayColor];
    universityLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];
    [uni_btn addSubview:universityLabel];
    
    collegeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 166, 21)];
    collegeLabel.backgroundColor = [UIColor clearColor];
    collegeLabel.textAlignment = UITextAlignmentCenter;
    collegeLabel.textColor = [UIColor grayColor];
    collegeLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:15];
    [coll_btn addSubview:collegeLabel];

    
    
}




- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [scrollView setContentOffset:CGPointMake(0, 0)];

    
    CDataManager *dataManager = [CDataManager getDataManager];
    
    region_dic = [dataManager.data objectForKey:@"region"];
    uni_dic = [dataManager.data objectForKey:@"university"];
    coll_dic = [dataManager.data objectForKey:@"college"];
    
    
    
    
    if (region_dic != nil) {
        if (uni_dic != nil) {
            if (coll_dic != nil) {
                regionLabel.text = [region_dic objectForKey:@"name"];
                universityLabel.text = [uni_dic objectForKey:@"nick"];
                collegeLabel.text = [coll_dic objectForKey:@"nick"];
            }else{
                regionLabel.text = [region_dic objectForKey:@"name"];
                universityLabel.text = [uni_dic objectForKey:@"nick"];
                collegeLabel.text = @"단과대학";
            }
        }else{
            regionLabel.text = [region_dic objectForKey:@"name"];
            universityLabel.text = @"대학교";
            collegeLabel.text = @"단과대학";
        }
    }else{
        regionLabel.text = @"지역";
        universityLabel.text = @"대학교";
        collegeLabel.text = @"단과대학";
    }
    
    
    if ([userDefaults integerForKey:@"image"]==1) {
        photo_btn.imageView.image = image;
    }else{
        image = NULL;
        photo_btn.imageView.image = [UIImage imageNamed:@"bk_image.png"];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.scrollView = nil;
    self.photo_btn = nil;
    self.region_btn = nil;
    self.uni_btn = nil;
    self.coll_btn = nil;
    self.title_field = nil;
    self.publisher_field = nil;
    self.author_field = nil;
    self.created_field = nil;
    self.original_field = nil;
    self.discount_field = nil;
    self.spiner = nil;
    self.alert = nil;
    self.content_view = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Category Button & Photo Button



- (IBAction)regionBtn:(id)sender {
    CategoryView *categoryView = [[CategoryView alloc] initWithNibName:@"CategoryView"bundle:nil];
    categoryView.address = CATEGORY_REGION;
    categoryView.delegate = self;
    categoryView.kinds = 0;
    categoryView.category = @"region";
    categoryView.id = 0;
    
    [self.navigationController pushViewController:categoryView animated:YES];
    
}

- (IBAction)universityBtn:(id)sender {
    
    CDataManager *dataManager = [CDataManager getDataManager];
    
    if (![dataManager.data objectForKey:@"region"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"학교선택" message:@"지역을 먼저 선택하여야 합니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }else{
        CategoryView *categoryView = [[CategoryView alloc] initWithNibName:@"CategoryView" bundle:nil];
        NSString *address = [CATEGORY_UNIVERSITY stringByAppendingFormat:@"%@/", [[userDefaults objectForKey:@"region"] objectForKey:@"id"]];
        categoryView.address = address;
        categoryView.kinds = 1;
        
        categoryView.category = @"university";
        categoryView.id = [[dataManager.data objectForKey:@"region"] objectForKey:@"id"];
        
        [self.navigationController pushViewController:categoryView animated:YES];
    }
}

- (IBAction)collegeBtn:(id)sender {
    CDataManager *dataManager = [CDataManager getDataManager];
    if (![dataManager.data objectForKey:@"university"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"카테고리" message:@"학교를 먼저 선택하여야 합니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }else{
        CategoryView *categoryView = [[CategoryView alloc] initWithNibName:@"CategoryView" bundle:nil];
        categoryView.address = [CATEGORY_COLLEGE stringByAppendingFormat:@"%@/", [[userDefaults objectForKey:@"university"] objectForKey:@"id"]];
        categoryView.kinds = 2;
        
        categoryView.category = @"college";
        categoryView.id = [[dataManager.data objectForKey:@"university"] objectForKey:@"id"];
        
        
        [self.navigationController pushViewController:categoryView animated:YES];
    }
}

- (IBAction)photo_btn:(id)sender
{
    if ([userDefaults integerForKey:@"image"] == 1) {
        photo_btn.imageView.image = [UIImage imageNamed:@"bk_image.png"];
        image = NULL;
        [userDefaults setInteger:0 forKey:@"image"];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@""
                                      delegate:self
                                      cancelButtonTitle:@"취소"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"라이브러리에서 선택", @"사진 촬영하기", nil];
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}


#pragma mark - UIImagePickerController Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    picker_bool = YES;
    
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


- (IBAction)press_barcode:(id)sender{
    
    picker_bool = NO;
	ZBarReaderViewController *reader = [ZBarReaderViewController new];
    
	reader = [ZBarReaderViewController new];
	reader.readerDelegate = self;
	
    
    UIView *barcodeview = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 460.0f)];
    UIImageView *barcodeup = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 80.0f)];
    UIImageView *barcodedown = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 160.0f, 320.0f, 300.0f)];
    [barcodeup setImage:[UIImage imageNamed:@"barcodeup.png"]];
    [barcodedown setImage:[UIImage imageNamed:@"barcodedown.png"]];
    
    [barcodeview addSubview:barcodeup];
    [barcodeview addSubview:barcodedown];
    
    reader.cameraOverlayView = barcodeview;
    
    
    //    이 주석은 카메라화면이 뜨는 곳에 다른 뷰(이미지)를 더 추가하기 위해서 작성한 코드이다.
 	
	
	ZBarImageScanner *scanner = reader.scanner;
	
	
	[scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    [self presentViewController:reader animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (picker_bool) {
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [userDefaults setInteger:1 forKey:@"image"];
        
    }else{
        id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
        
        ZBarSymbol *symbol = nil;
        for(symbol in results)
            break;
        isbn = symbol.data;
        NSLog(@"%@", symbol.data);
        //	barcode_number.text = symbol.data;
        //symbol.data가 바코드 번호이다.
        
        
        /*
         if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
         [self performSelector: @selector(playBeep)
         withObject: nil
         afterDelay: 0.01];
         //     이부분은 스캔이 되었을때, 삐 소리가 하게 하는 부분이다.
         */
        
        [self start_rss];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];

	
}




/*
 - (void)imagePickerController:(UIImagePickerController *)picker_ didFinishPickingMediaWithInfo:(NSDictionary *)info
 {
 
 image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
 [userDefaults setInteger:1 forKey:@"image"];
 [self dismissModalViewControllerAnimated:YES];
 
 }
 */



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
    // 맨 처음으로 보내기
    /*	if (textField == m_textfield8) {
     [m_textfield1 becomeFirstResponder];
     }
     else*/
    if (textField.tag == 5)
        [content_view becomeFirstResponder];
    else
        [self nextField:textField];
    
    
    
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
	CGRect frame = [object convertRect:object.bounds toView:scrollView];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.25];
	
	if (object) {
		offsetY = frame.origin.y - 62;
		if (offsetY < 0.0f)
			offsetY = 0.0f;
	}
	
	[scrollView setContentOffset:CGPointMake(0, offsetY)];
	
	[UIView commitAnimations];
}

#pragma mark - TextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.25];
    [scrollView setContentOffset:CGPointMake(0, 600)];
	[UIView commitAnimations];
    
}

#pragma mark - ScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [title_field resignFirstResponder];
    [publisher_field resignFirstResponder];
    [author_field resignFirstResponder];
    [created_field resignFirstResponder];
    [content_view resignFirstResponder];
}

- (IBAction)sell_btn:(id)sender
{
    
//    int btnCount = [segment selectedSegmentIndex];
//    if (btnCount == 0)
//        sell = @"1";
//    else
//        sell = @"0";
//    
//    NSLog(@"%@", sell);
}


#pragma mark - Register cycle

- (IBAction)register_btn:(id)sender
{
    if ([title_field.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"등록" message:@"책제목을 입력하세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }else if ([publisher_field.text isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"등록" message:@"출판사를 입력하세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }else if ([author_field.text isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"등록" message:@"저자를 입력하세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }else if ([created_field.text isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"등록" message:@"출판일을 입력하세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }else if ([original_field.text isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"등록" message:@"원가를 입력하세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }else if ([discount_field.text isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"등록" message:@"판매가를 입력하세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }else if(!parcel_bool && !meet_bool){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"등록" message:@"택배 또는 직거래중 하나 이상의 거래방법을 택해야 합니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        
    }else{
        
        NSString *book_title = title_field.text;
        NSString *publisher = publisher_field.text;
        NSString *author = author_field.text;
        NSString *created = created_field.text;
        NSString *original_price = [original_field.text stringByAppendingString:@""];
        NSString *discount_price = [discount_field.text stringByAppendingString:@""];
        NSString *content = content_view.text;
        
        CDataManager *dataManager = [CDataManager getDataManager];
        
        NSString *region_id = [[dataManager.data objectForKey:@"region"] objectForKey:@"id"];
        NSString *uni_id = [[dataManager.data objectForKey:@"university"] objectForKey:@"id"];
        NSString *college_id = [[dataManager.data objectForKey:@"college"] objectForKey:@"id"];
        
                
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"카테고리" message:@"지역, 학교, 단과대학을 모두 선택해야 합니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];

        if (![dataManager.data objectForKey:@"region"]) {
            [alertView show];
            return;
        }
        if (![dataManager.data objectForKey:@"university"]) {
            [alertView show];
            return;
        }
        if (![dataManager.data objectForKey:@"college"]) {
            [alertView show];
            return;
        }


          
        NSString *sale = @"1";
        NSString *parcel;
        NSString *meet;
        
        if (parcel_bool)
            parcel = @"1";
        else
            parcel = @"0";
        
        if (meet_bool)
            meet = @"1";
        else
            meet = @"0";
        
        
        NSURL *url = [[NSURL alloc] initWithString:BOOK_URL];
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
        [request setRequestMethod:@"POST"];
        [request setPostFormat:ASIMultipartFormDataPostFormat];
        [request setShouldContinueWhenAppEntersBackground:YES];
        [request setPostValue:book_title forKey:@"title"];
        [request setPostValue:original_price forKey:@"original_price"];
        [request setPostValue:discount_price forKey:@"discount_price"];
        [request setPostValue:created forKey:@"published"];
        [request setPostValue:@"1" forKey:@"edition"];
        [request setPostValue:publisher forKey:@"publisher"];
        [request setPostValue:author forKey:@"book_author"];
        [request setPostValue:content forKey:@"content"];
        [request setPostValue:region_id forKey:@"region"];
        [request setPostValue:uni_id forKey:@"university"];
        [request setPostValue:college_id forKey:@"college"];
        [request setPostValue:sale forKey:@"sale"];
        [request setPostValue:parcel forKey:@"parcel"];
        [request setPostValue:meet forKey:@"meet"];
        [request setPostValue:@"1" forKey:@"country"];
        [request setPostValue:sell forKey:@"sell"];
        [request setPostValue:isbn forKey:@"isbn"];
        [request setPostValue:[userDefaults objectForKey:@"user_id"] forKey:@"user_id"];
        [request setPostValue:[userDefaults objectForKey:@"value"] forKey:@"value"];
    
        if (image) {
            NSString *fileName = @"photo.jpg";
            [request addPostValue:fileName forKey:@"image"];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.001);
            [request setData:imageData withFileName:fileName andContentType:@"image/jpeg" forKey:@"image"];
        }
        
        alert = [[UIAlertView alloc] initWithTitle:@"잠시만 기다려 주세요.." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        
        spiner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spiner.center = CGPointMake(alert.bounds.size.width/2, alert.bounds.size.height/2+10);
        [spiner startAnimating];
        [alert addSubview:spiner];

        [request setDelegate:self];
        [request startAsynchronous];
    }
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
    NSString *result = [NSString stringWithString:[request responseString]];
    
    NSLog(@"%@", result);
    
    if ([result isEqualToString:@"200"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBook" object:self];

        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"상품 등록이 완료되었습니다. " message:nil delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        myAlert.tag = 2;
        [myAlert show];
        [userDefaults setInteger:1 forKey:@"my"];
        
        title_field.text = @"";
        publisher_field.text = @"";
        author_field.text = @"";
        created_field.text = @"";
        original_field.text = @"";
        discount_field.text = @"";
        content_view.text = @"";
        parcel_bool = NO;
        parcel_check.image = [UIImage imageNamed:@"check.png"];
        meet_bool = NO;
        meet_check.image = [UIImage imageNamed:@"check.png"];
        image = NULL;
        photo_btn.imageView.image = [UIImage imageNamed:@"bk_image.png"];
        [scrollView setContentOffset:CGPointMake(0, 0)];
        
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


- (void)start_rss
{
    @autoreleasepool {
        NSString *feedAddress = [NAVER_ISBN stringByAppendingString:isbn];
        [self isbnRSSFeed:feedAddress];
    }
}

- (void)isbnRSSFeed:(NSString *)feedAddress
{
    NSLog(@"%@", feedAddress);
    
    NSURL *url = [NSURL URLWithString: feedAddress];
	
	NSError *error = nil;
    CXMLDocument *rssParser = [[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:&error];
    
    if (error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"isbn" message:@"네트워크상태를 확인하세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
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
        isbnDic = newsItem;
    }
    
    UIAlertView *alert_ = [[UIAlertView alloc] initWithTitle:[isbnDic objectForKey:@"title"] message:[isbnDic objectForKey:@"description"] delegate:self cancelButtonTitle:@"사용" otherButtonTitles:@"취소" ,nil ];
    alert_.tag = 1;
    [alert_ show];
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex ==0){
        if (alertView.tag == 1) {
            [self isbnAutoComplete];
            [discount_field becomeFirstResponder];
        }else if(alertView.tag == 2){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if(buttonIndex == 1){
        
    }
}


- (void)isbnAutoComplete
{
    title_field.text = [isbnDic objectForKey:@"title"];
    publisher_field.text = [isbnDic objectForKey:@"publisher"];
    author_field.text = [isbnDic objectForKey:@"author"];
    created_field.text = [isbnDic objectForKey:@"pubdate"];
    original_field.text = [isbnDic objectForKey:@"price"];
    //    content_view.text = [isbnDic objectForKey:@"description"];
    
    NSURL *url = [NSURL URLWithString:[isbnDic objectForKey:@"image"]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    image = [UIImage imageWithData:data];
    photo_btn.imageView.image = image;
    [userDefaults setInteger:1 forKey:@"image"];
}

- (IBAction)parcelBtn:(id)sender
{
    
    if (parcel_bool) {
        parcel_bool = NO;
        parcelBtn.selected = NO;
    }else{
        parcel_bool = YES;
        parcelBtn.selected = YES;
    }
}
- (IBAction)meetBtn:(id)sender
{
    if (meet_bool) {
        meet_bool = NO;
        meetBtn.selected = NO;
    }else{
        meet_bool = YES;
        meetBtn.selected = YES;
    }
}

- (void)segBtn:(UIButton *)btn
{
    if (btn.tag == 1) {
        saleBtn.selected = YES;
        purchaseBtn.selected = NO;
        sell = @"1";
    }else{
        saleBtn.selected = NO;
        purchaseBtn.selected = YES;
        sell = @"0";
    }
}




@end
