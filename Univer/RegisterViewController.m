//
//  RegisterViewController.m
//  Univer
//
//  Created by 백 운천 on 12. 10. 15..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import "RegisterViewController.h"
#import "CategoryView.h"
#import "ASIFormDataRequest.h"

#define CATEGORY_REGION                              @"http://54.249.52.26/feeds/region/"
#define CATEGORY_UNIVERSITY                         @"http://54.249.52.26/feeds/univ/"
#define CATEGORY_COLLEGE                            @"http://54.249.52.26/feeds/college/"
#define REGISTER_URL                                @"http://54.249.52.26/register/"


@implementation RegisterViewController
@synthesize regionBtn, universityBtn, collegeBtn;
@synthesize emailField, nicknameField, password1Field, password2Field;
@synthesize spiner, alert;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 42, 44)];

        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn1.frame =CGRectMake(0, 2, 40, 40);
        [btn1 setTitle:@"완료" forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(registerBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [rightView addSubview:btn1];

        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];

        self.navigationItem.rightBarButtonItem = rightItem;
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 31, 44)];
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame =CGRectMake(0, 7, 31, 31);
        [btn2 setBackgroundImage:[UIImage imageNamed:@"cm_back_selected.png"] forState:UIControlStateHighlighted];
        [btn2 setBackgroundImage:[UIImage imageNamed:@"cm_back_unselected.png"] forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
        [leftView addSubview:btn2];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
        self.navigationItem.leftBarButtonItem = leftItem;
        
        self.title = @"회원가입";
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
    [emailField becomeFirstResponder];
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Do any additional setup after loading the view from its nib.
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
                [regionBtn setTitle:[region_dic objectForKey:@"title"] forState:UIControlStateNormal];
                [universityBtn setTitle:[uni_dic objectForKey:@"title"] forState:UIControlStateNormal];
                [collegeBtn setTitle:[coll_dic objectForKey:@"title"] forState:UIControlStateNormal];
            }else{
                [regionBtn setTitle:[region_dic objectForKey:@"title"] forState:UIControlStateNormal];
                [universityBtn setTitle:[uni_dic objectForKey:@"title"] forState:UIControlStateNormal];
                [collegeBtn setTitle:@"단과대학" forState:UIControlStateNormal];
            }
        }else{
            [regionBtn setTitle:[region_dic objectForKey:@"title"] forState:UIControlStateNormal];
            [universityBtn setTitle:@"대학교" forState:UIControlStateNormal];
            [collegeBtn setTitle:@"단과대학" forState:UIControlStateNormal];
        }
    }else{
        [regionBtn setTitle:@"지역" forState:UIControlStateNormal];
        [universityBtn setTitle:@"대학교" forState:UIControlStateNormal];
        [collegeBtn setTitle:@"단과대학" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"학교선택" message:@"대학교를 먼저 선택하여야 합니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }else{
        CategoryView *categoryView = [[CategoryView alloc] initWithNibName:@"CategoryView" bundle:nil];
        categoryView.address = [CATEGORY_COLLEGE stringByAppendingFormat:@"%@/", [[userDefaults objectForKey:@"university"] objectForKey:@"id"]];
        categoryView.kinds = 2;
        [self.navigationController pushViewController:categoryView animated:YES];
    }
}

- (void)registerBtn:(id)sender
{
    
    if ([emailField.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"회원가입" message:@"이메일을 입력해주세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if ([nicknameField.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"회원가입" message:@"닉네임을 입력해주세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if ([password1Field.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"회원가입" message:@"비밀번호를 입력하세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (![password1Field.text isEqualToString:password2Field.text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"회원가입" message:@"두개의 비밀번호가 일치하지 않습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (region_dic == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"회원가입" message:@"지역을 선택해야 합니다." delegate: self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }else if (uni_dic == nil){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"회원가입" message:@"학교를 선택해야 합니다." delegate: self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
        
    }else if (coll_dic == nil){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"회원가입" message:@"단과대를 선택해야 합니다." delegate: self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
        
    }else{
        
        alert = [[UIAlertView alloc] initWithTitle:@"잠시만 기다려 주세요.." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        
        spiner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spiner.center = CGPointMake(alert.bounds.size.width/2, alert.bounds.size.height/2+10);
        [spiner startAnimating];
        [alert addSubview:spiner];
        
        
        NSURL *url = [NSURL URLWithString:REGISTER_URL];
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
        request.delegate = self;
        //user
        [request setPostValue:emailField.text forKey:@"email"];
        [request setPostValue:nicknameField.text forKey:@"first_name"];
        [request setPostValue:password1Field.text forKey:@"password"];
        //customUser,  country_id=nation
        [request setPostValue:[region_dic objectForKey:@"id"] forKey:@"region"];
        [request setPostValue:[uni_dic objectForKey:@"id"] forKey:@"university"];
        [request setPostValue:[coll_dic objectForKey:@"id"] forKey:@"college"];
        
        //        아이폰 1, 안드로이드 2, 블랙베리 3
        [request setPostValue:@"1" forKey:@"device_type"];
        [request setPostValue:[userDefaults objectForKey:@"deviceToken"] forKey:@"deviceToken"];
        
        [request startAsynchronous];
        
    }
}



- (void)requestFinished:(ASIHTTPRequest *)request
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];

    NSString *result = [NSString stringWithString:[request responseString]];
    NSLog(@"%@", result);
    int result_value = [result intValue];
    
    if (result_value == 200) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"회원가입" message:@"회원가입이 완료되었습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        alertView.tag = 1;
        [alertView show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"회원가입" message:result delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1){
        [self.navigationController popViewControllerAnimated:YES];
        }
}



@end
