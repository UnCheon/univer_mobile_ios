//
//  AppDelegate.m
//  Univer
//
//  Created by 백 운천 on 12. 10. 3..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import "AppDelegate.h"
#import "BooksViewController.h"
#import "ProfessorsViewController.h"
#import "ChatRoomsViewController.h"
#import "SettingsViewController.h"
#import "ASIFormDataRequest.h"
#import "BoardsViewController.h"

#define LOGIN_URL                        @"http://54.249.52.26/login/"



@implementation AppDelegate
@synthesize tabbarController = _tabbarController;
@synthesize window;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    //login
    
    // Override point for customization after application launch.
    
    LoginViewController *loginViewCtr = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    loginNavi = [[UINavigationController alloc] initWithRootViewController:loginViewCtr];
    
    
    
    BooksViewController *booksViewCtr = [[BooksViewController alloc] initWithNibName:@"BooksViewController" bundle:nil];
    ProfessorsViewController *professorsViewCtr  = [[ProfessorsViewController alloc] initWithNibName:@"ProfessorsViewController" bundle:nil];
    ChatRoomsViewController *chatRoomsViewCtr = [[ChatRoomsViewController alloc] initWithNibName:@"ChatRoomsViewController" bundle:nil];
    BoardsViewController *boardsViewCtr = [[BoardsViewController alloc] initWithNibName:@"BoardsViewController" bundle:nil];
    SettingsViewController *settingsViewCtr = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    
    
    
    UINavigationController *professorsNavi = [[UINavigationController alloc] initWithRootViewController:professorsViewCtr];
    UINavigationController *booksNavi = [[UINavigationController alloc] initWithRootViewController:booksViewCtr];
    UINavigationController *chatRoomsNavi = [[UINavigationController alloc] initWithRootViewController:chatRoomsViewCtr];
    UINavigationController *boardsNavi = [[UINavigationController alloc] initWithRootViewController:boardsViewCtr];
    UINavigationController *settingsNavi = [[UINavigationController alloc] initWithRootViewController:settingsViewCtr];
    
    NSArray *viewCtrs = [[NSArray alloc] initWithObjects:booksNavi, professorsNavi, chatRoomsNavi, boardsNavi, settingsNavi, nil];
    self.tabbarController.viewControllers = viewCtrs;
    

    [[NSNotificationCenter defaultCenter] postNotificationName:@"launch" object:self];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [userDefaults objectForKey:@"username"];
    NSString *user_id = [userDefaults objectForKey:@"user_id"];
    NSString *value = [userDefaults objectForKey:@"value"];
    NSString *password = [userDefaults objectForKey:@"password"];
    
    
    NSLog(@"%@, %@, %@, %@", username, user_id, value, password);
    
//    if (![username isEqualToString:@""] && ![user_id isEqualToString:@""] && ![value isEqualToString:@""] && ![password isEqualToString:@""]) {
    if(1){
    
        NSURL *url = [NSURL URLWithString:LOGIN_URL];
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
        
        [request setRequestMethod:@"POST"];
        [request setPostFormat:ASIMultipartFormDataPostFormat];
        [request setShouldContinueWhenAppEntersBackground:YES];
        [request setPostValue:@"1" forKey:@"username"];
        [request setPostValue:@"1" forKey:@"password"];
        [request setDelegate:self];
        [request startAsynchronous];
    }else{
        self.window.rootViewController = loginNavi;
        [self.window makeKeyAndVisible];
    }
    
        
    return YES;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *result = [NSString stringWithString:[request responseString]];
    NSLog(@"%@", result);
        
    if ([result intValue] == 200) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:self];        
        [self loginSuccess];

    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"로그인" message:result delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        
        self.window.rootViewController = loginNavi;
        [self.window makeKeyAndVisible];

        
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"로그인 실패");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    const unsigned *tokenBytes = [devToken bytes];
    
    NSString *apnsDeviceToken = [NSString stringWithFormat:@"%08X%08X%08X%08X%08X%08X%08X%08X",
                                 ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                                 ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                                 ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
    NSLog(@"%@", apnsDeviceToken);
    [userDefaults setObject:apnsDeviceToken forKey:@"deviceToken"];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
	NSDictionary *aps = [userInfo valueForKey:@"aps"];
    //    [NSThread detachNewThreadSelector:@selector(update) toTarget:self  withObject:nil ];
	NSLog(@"userInfo Alert : %@", [aps valueForKey:@"alert"]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:self];
}

- (void)loginSuccess
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:self];

    self.window.rootViewController = self.tabbarController;
    [self.window makeKeyAndVisible];
}

- (void)logoutSuccess
{
    self.window.rootViewController = loginNavi;
    [self.window makeKeyAndVisible];

}

@end
