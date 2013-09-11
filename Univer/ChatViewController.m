//
//  ChatViewController.m
//  Univer
//
//  Created by 백 운천 on 12. 10. 4..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import "ChatViewController.h"
#import "CustomTabbarController.h"
#import "ChatRoomsViewController.h"


#define CHAT_URL                @"http://54.249.52.26:3000/join/"
#define CHATROOM_CHECK_URL      @"http://54.249.52.26/chatRoomCheck/"

@implementation ChatViewController

@synthesize webView;
@synthesize to_id, to_nick;
@synthesize dic;
@synthesize kinds, indexPath, chatRoomList;

@synthesize alert, spiner;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = to_nick;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShow:)
													 name:UIKeyboardWillShowNotification
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillHide:)
													 name:UIKeyboardWillHideNotification
												   object:nil];
        

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


    self.title = to_nick;
    
    [super viewDidLoad];

    
//    alert = [[UIAlertView alloc] initWithTitle:@"잠시만 기다려 주세요.." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//    [alert show];
//    
//    spiner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    spiner.center = CGPointMake(alert.bounds.size.width/2, alert.bounds.size.height/2+10);
//    [spiner startAnimating];
//    [alert addSubview:spiner];

    
    
    NSLog(@"%f", self.view.frame.size.height);
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-40)];
    webView.delegate = self;
    
    [self.view addSubview:webView];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    my_id = [userDefaults objectForKey:@"user_id"];
    
    
    int to_id_value = [to_id intValue];
    int my_id_value = [my_id intValue];
    
    
    if (to_id_value > my_id_value) {
        roomName = [NSString stringWithFormat:@"%d.%d", to_id_value, my_id_value];
    }else{
        roomName = [NSString stringWithFormat:@"%d.%d", my_id_value, to_id_value];
    }
    
    NSLog(@"%@", roomName);

    
    NSString *is_chatRoom = @"1";
    if (kinds == 0) {
        to_id = [dic objectForKey:@"to_id"];
        seller = [dic objectForKey:@"seller"];
        chatRoom_id = [dic objectForKey:@"chatRoom_id"];
        
        NSMutableArray *webViewParams = [NSMutableArray arrayWithObjects:
                                         @"roomName", roomName,
                                         @"is_chatRoom", is_chatRoom,
                                         @"chatRoom_id", chatRoom_id,
                                         @"to_id", to_id,
                                         @"my_id", my_id,
                                         @"my_seller", seller,
                                         @"device_type", @"1",
                                         nil];
        
        NSLog(@"webviewParams : %@", webViewParams);
        
        [self UIWebViewWithPost:self.webView url:CHAT_URL params:webViewParams];
        [webView endEditing:YES];
        
    
    }else{
        
        seller = @"0";
        // 확인해야 한다. - 챗방이 존재하는지
        
        NSURL *url = [NSURL URLWithString:CHATROOM_CHECK_URL];
        
        request = [[ASIFormDataRequest alloc] initWithURL:url];
        [request setRequestMethod:@"POST"];
        [request setPostFormat:ASIMultipartFormDataPostFormat];
        [request setShouldContinueWhenAppEntersBackground:YES];
        [request setPostValue:to_id forKey:@"other_user_id"];
        [request setPostValue:[userDefaults objectForKey:@"user_id"] forKey:@"user_id"];
        [request setPostValue:[userDefaults objectForKey:@"value"] forKey:@"value"];
        [request setDelegate:self];
        [request setTag:1];
        [request startAsynchronous];
        
    }
    
    
    
    
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
    textView.font = [UIFont fontWithName:@"NanumGothicBold" size:14];
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
    
	doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(containerView.frame.size.width - 69, 8, 63, 27);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[doneBtn setTitle:@"전송" forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:16];

    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
//    [doneBtn setBackgroundImage:[UIImage imageNamed:@"ch_number_box.png"] forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
	[containerView addSubview:doneBtn];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    // Do any additional setup after loading the view from its nib.
    [(CustomTabbarController *)self.tabBarController hideNewTabbar];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    textView.textColor = [UIColor grayColor];
    textView.text = @"채팅서버에 연결중입니다.";
    textView.editable = NO;
    [doneBtn setEnabled:NO];
    
    [(CustomTabbarController *)self.tabBarController hideNewTabbar];
    webView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 44);
    NSLog(@"%f", self.view.frame.size.height);

}

- (void)viewWillDisappear:(BOOL)animated
{
    
    ChatRoomsViewController *chatListView = (ChatRoomsViewController *)delegate;
    NSMutableDictionary *chatRoom_dic = [[NSMutableDictionary alloc] initWithDictionary:[chatRoomList objectAtIndex:indexPath]];
    [chatRoom_dic setObject:@"0" forKey:@"count"];
    
    [chatRoomList replaceObjectAtIndex:indexPath withObject:chatRoom_dic];
    
    [chatListView setUniArray:chatRoomList];
    
    [self exitChatRoom];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadChatRoom" object:self];

    
    [(CustomTabbarController *)self.tabBarController showNewTabbar];

    [super viewWillDisappear:YES];
}


- (void)viewDidDisappear:(BOOL)animated
{
    request = nil;
    
    [super viewDidDisappear:YES];
}

- (void)requestFinished:(ASIHTTPRequest *)request_
{
    // Use when fetching text data
    
    
    
    NSString *result = [request_ responseString];
    NSLog(@"result : %@", result);
    if (request_.tag == 1) {
        if ([result intValue] == 0) {
            is_chatRoom = @"0";
            chatRoom_id = @"0";
            
            
        }else{
            is_chatRoom = @"1";
            chatRoom_id = result;
        }
        
        NSMutableArray *webViewParams = [NSMutableArray arrayWithObjects:
                                         @"roomName", roomName,
                                         @"is_chatRoom", is_chatRoom,
                                         @"chatRoom_id", chatRoom_id,
                                         @"to_id", to_id,
                                         @"my_id", my_id,
                                         @"my_seller", seller,
                                         @"device_type", @"1",
                                         nil];
        
        NSLog(@"webviewParams : %@", webViewParams);
        
        [self UIWebViewWithPost:self.webView url:CHAT_URL params:webViewParams];
        [webView endEditing:YES];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    //    NSError *error = [request error];
    
    
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"네트워크 상태를 확인하세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [myAlert show];
}


- (void)UIWebViewWithPost:(UIWebView *)uiWebView url:(NSString *)url params:(NSMutableArray *)params
{
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    [s appendString: [NSString stringWithFormat:@"<html><body onload=\"document.forms[0].submit()\">"
                      "<form method=\"post\" action=\"%@\">", url]];
    if([params count] % 2 == 1) { NSLog(@"UIWebViewWithPost error: params don't seem right"); return; }
    for (int i=0; i < [params count] / 2; i++) {
        [s appendString: [NSString stringWithFormat:@"<input type=\"hidden\" name=\"%@\" value=\"%@\" >\n", [params objectAtIndex:i*2], [params objectAtIndex:(i*2)+1]]];
    }
    [s appendString: @"</input></form></body></html>"];
    //NSLog(@"%@", s);
    [webView loadHTMLString:s baseURL:nil];
}

- (void)exitChatRoom
{
    NSString *javascript = @"calljavascriptExitChatRoom()";
    [webView stringByEvaluatingJavaScriptFromString:javascript];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)resignTextView
{
    if ([textView.text isEqualToString:@""]) {
        return;
    }
    NSString *content = textView.text;
    NSString *javascript = [@"callJavascriptFromObjectiveC(" stringByAppendingFormat:@"'%@');", content];
    NSLog(@"%@", javascript);
    [webView stringByEvaluatingJavaScriptFromString:javascript];
    
    textView.text = @"";
}

//@"(function() {
//    var foo = document.getElementById('name');
//    return foo.value; }) ()"


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
	
    webView.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height-keyboardBounds.size.height-40);
    
	// set views with new info
	containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];

    NSString *javascript = @"callJavascriptTextViewResponse()";
    [webView stringByEvaluatingJavaScriptFromString:javascript];
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
	webView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-40);
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



- (void)socketDisconnected {
    
    textView.textColor = [UIColor grayColor];
    textView.text = @"채팅서버에 연결중입니다.";
    textView.editable = NO;
    [doneBtn setEnabled:NO];

    
    NSMutableArray *webViewParams = [NSMutableArray arrayWithObjects:
                                     @"roomName", roomName,
                                     @"is_chatRoom", is_chatRoom,
                                     @"chatRoom_id", chatRoom_id,
                                     @"to_id", to_id,
                                     @"my_id", my_id,
                                     @"my_seller", seller,
                                     @"device_type", @"1",
                                     nil];
    
    NSLog(@"webviewParams : %@", webViewParams);
    
    [self UIWebViewWithPost:self.webView url:CHAT_URL params:webViewParams];
    [webView endEditing:YES];
    
}

- (void)socketConnected {
    textView.text = @"";
    textView.editable = YES;
    textView.textColor = [UIColor blackColor];
    [doneBtn setEnabled:YES];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType

{
    
    
    if ([[[request URL] absoluteString] hasPrefix:@"jscall:"]) {
        
        NSString *requestString = [[request URL] absoluteString];
    
        NSArray *components = [requestString componentsSeparatedByString:@"://"];
        
        NSString *functionName = [components objectAtIndex:1];
        
        [self performSelector:NSSelectorFromString(functionName)];
        
        return NO;
    }
    return YES;
}



@end
