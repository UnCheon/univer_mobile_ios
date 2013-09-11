//
//  LoginViewController.m
//  Univer
//
//  Created by 백 운천 on 12. 10. 15..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import "LoginViewController.h"
#import "ASIFormDataRequest.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"

#define LOGIN_URL                   @"http://54.249.52.26/login/"


@implementation LoginViewController
@synthesize emailField, passwordField;
@synthesize alert, spiner;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title  = @"로그인";
    }
    return self;
}


- (void)viewDidLoad
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"cm_navigation_background_2.jpg"] forBarMetrics:UIBarMetricsDefault];
    UIImage *repeatingImage = [UIImage imageNamed:@"cm_background_pattern.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:repeatingImage];


    [super viewDidLoad];
    [emailField becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtn:(id)sender {
    if ([emailField.text isEqualToString:@""]) {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"이메일주소를 입력하세요." message:nil delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alerView show];
        return;
    }else if ([passwordField.text isEqualToString:@""]){
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"비밀번호를 입력하세요." message:nil delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alerView show];
        return;
    }else{
        alert = [[UIAlertView alloc] initWithTitle:@"잠시만 기다려 주세요.." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        
        spiner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spiner.center = CGPointMake(alert.bounds.size.width/2, alert.bounds.size.height/2+10);
        [spiner startAnimating];
        [alert addSubview:spiner];
        
        NSURL *url = [[NSURL alloc] initWithString:LOGIN_URL];
        
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
        
        [request setRequestMethod:@"POST"];
        [request setPostFormat:ASIMultipartFormDataPostFormat];
        [request setShouldContinueWhenAppEntersBackground:YES];
        [request setPostValue:emailField.text forKey:@"username"];
        [request setPostValue:passwordField.text forKey:@"password"];
        [request setDelegate:self];
        [request startAsynchronous];

    }
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
    NSString *result = [NSString stringWithString:[request responseString]];
    NSArray* resultArray = [result componentsSeparatedByString:@"+"];
    NSLog(@"%@", resultArray);
    NSLog(@"%d", [resultArray count]);
    if ([resultArray count] == 2) {
        [emailField resignFirstResponder];
        [passwordField resignFirstResponder];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:emailField.text forKey:@"username"];
        [userDefaults setObject:passwordField.text forKey:@"password"];
        
        [userDefaults setObject:[resultArray objectAtIndex:0] forKey:@"user_id"];
        [userDefaults setObject:[resultArray objectAtIndex:1] forKey:@"value"];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:self];
        
        [[self appDelegate] loginSuccess];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"로그인" message:result delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    //    NSError *error = [request error];
    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"로그인" message:@"네트워크상태를 확인하세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [myAlert show];
}



- (IBAction)registerBtn:(id)sender {
    RegisterViewController *registerViewCtr = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    
    [self.navigationController pushViewController:registerViewCtr animated:YES];
    
}

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
