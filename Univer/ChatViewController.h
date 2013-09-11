//
//  ChatViewController.h
//  Univer
//
//  Created by 백 운천 on 12. 10. 4..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "ASIFormDataRequest.h"


@interface ChatViewController : UIViewController <HPGrowingTextViewDelegate, UIWebViewDelegate>
{
    NSUserDefaults *userDefaults;
    
    UIWebView *webView;
    NSString *to_id;
    NSString *to_nick;
    NSString *roomName;
    NSString *is_chatRoom;
    NSString *my_id;
    NSString *chatRoom_id;
    NSString *seller;
    
    UIView *containerView;

    HPGrowingTextView *textView;
    
    NSDictionary *dic;

    ASIFormDataRequest *request;
    
    UIAlertView *alert;
    UIActivityIndicatorView *spiner;

    NSMutableArray *chatRoomList;
    int kinds;
    int indexPath;
    id delegate;
    
    
    UIButton *doneBtn;
    

    
    
}

- (void)socketConnected;
- (void)socketDisconnected;



@property (nonatomic, strong) UIWebView *webView;
@property (strong) NSDictionary *dic;
@property (strong) NSString *to_id;
@property (strong) NSString *to_nick;
@property int kinds;
@property int indexPath;
@property (strong) NSMutableArray *chatRoomList;

@property (nonatomic) id delegate;

@property (nonatomic, strong) UIAlertView *alert;
@property (nonatomic, strong) UIActivityIndicatorView *spiner;


@end
