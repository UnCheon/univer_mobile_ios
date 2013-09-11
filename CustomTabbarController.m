//
//  CustomTabbarController.m
//  Uni
//
//  Created by 백 운천 on 12. 9. 26..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import "CustomTabbarController.h"

@interface CustomTabbarController ()

@end

@implementation CustomTabbarController
@synthesize btn1, btn2, btn3, btn4, btn5;
@synthesize chatBadge;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    chatBadge = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(29, 0, 35, 25)];
    chatBadge.hideWhenZero = YES;
    chatBadge.value = NULL;
    chatBadge.shadow = NO;
    chatBadge.shine = NO;
    chatBadge.fillColor = [UIColor colorWithRed:0.376471 green:0.666667 blue:0.760784 alpha:1];
    
    

    [super viewDidLoad];
    [self hideExistingTabBar];
    
    
	// Do any additional setup after loading the view.
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"Began");
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self selectTab:2];
    NSLog(@"Ended");
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"Moved");
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"Cancelled");
    
}




- (UIColor *) myRGBfromHex: (NSString *) code {
    
    NSString *str = [[code stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    
    if ([str length] < 6)  // 일단 6자 이하면 말이 안되니까 검은색을 리턴해주자.
        
        return [UIColor blackColor];
    
    // 0x로 시작하면 0x를 지워준다.
    
    if ([str hasPrefix:@"0X"])
        
        str = [str substringFromIndex:2];
    
    // #으로 시작해도 #을 지워준다.
    
    if ([str hasPrefix:@"#"])
        
        str = [str substringFromIndex:1];
    
    if ([str length] != 6) //그랫는데도 6자 이하면 이것도 이상하니 그냥 검은색을 리턴해주자.
        
        return [UIColor blackColor];
    
    
    
    NSRange range;
    
    range.location = 0;
    
    range.length = 2;
    
    NSString *rcolorString = [str substringWithRange:range];
    
    range.location = 2;
    
    NSString *gcolorString = [str substringWithRange:range];
    
    range.location = 4;
    
    NSString *bcolorString = [str substringWithRange:range];
    
    unsigned int red, green, blue;
    
    [[NSScanner scannerWithString: rcolorString] scanHexInt:&red];
    
    [[NSScanner scannerWithString: gcolorString] scanHexInt:&green];
    
    [[NSScanner scannerWithString: bcolorString] scanHexInt:&blue];
    
    
//        chatBadge.fillColor = [UIColor colorWithRed:0.96f green:0.170f blue:0.194f alpha:0.5];
    
    return [UIColor colorWithRed:((float) red / 255.0f)
            
                           green:((float) green / 255.0f)
            
                            blue:((float) blue / 255.0f)
            
                           alpha:1.0f];
    
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self hideExistingTabBar];
    [self addCustomElements];
    
}


- (void)hideExistingTabBar
{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITabBar class]]) {
            view.hidden = YES;
            break;
        }
    }
}


-(void)addCustomElements
{
    // Initialise our two images
    UIImage *btnImage = [UIImage imageNamed:@"cm_tab1_unselected.png"];
    UIImage *btnImageSelected = [UIImage imageNamed:@"cm_tab1_selected.png"];
    
    btn1 = [UIButton buttonWithType:UIButtonTypeCustom]; //Setup the button
    btn1.frame = CGRectMake(0, [super view].bounds.size.height-49, 64, 49); // Set the frame (size and position) of the button)
    [btn1 setBackgroundImage:btnImage forState:UIControlStateNormal]; // Set the image for the normal state of the button
    [btn1 setBackgroundImage:btnImageSelected forState:UIControlStateSelected]; // Set the image for the selected state of the button
    [btn1 setBackgroundImage:btnImageSelected forState:UIControlStateHighlighted];
    [btn1 setTag:0]; // Assign the button a "tag" so when our "click" event is called we know which button was pressed.
    [btn1 setSelected:true]; // Set this button as selected (we will select the others to false as we only want Tab 1 to be selected initially
    
    // Now we repeat the process for the other buttons
    btnImage = [UIImage imageNamed:@"cm_tab2_unselected.png"];
    btnImageSelected = [UIImage imageNamed:@"cm_tab2_selected.png"];
    btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(64, [super view].bounds.size.height-49, 64, 49);
    [btn2 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btn2 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    [btn2 setBackgroundImage:btnImageSelected forState:UIControlStateHighlighted];
    [btn2 setTag:1];
    
    
    
    btnImage = [UIImage imageNamed:@"cm_tab3_unselected.png"];
    btnImageSelected = [UIImage imageNamed:@"cm_tab3_selected.png"];
    btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(128, [super view].bounds.size.height-49, 64, 49);
    [btn3 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btn3 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    [btn3 setBackgroundImage:btnImageSelected forState:UIControlStateHighlighted];
    [btn3 setTag:2];
    [btn3 addSubview:chatBadge];
    
    
    btnImage = [UIImage imageNamed:@"cm_tab4_unselected.png"];
    btnImageSelected = [UIImage imageNamed:@"cm_tab4_selected.png"];
    btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(192, [super view].bounds.size.height-49, 64, 49);
    [btn4 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btn4 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    [btn4 setBackgroundImage:btnImageSelected forState:UIControlStateHighlighted];
    [btn4 setTag:3];
    
    
    btnImage = [UIImage imageNamed:@"cm_tab5_unselected.png"];
    btnImageSelected = [UIImage imageNamed:@"cm_tab5_selected.png"];
    btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5.frame = CGRectMake(256, [super view].bounds.size.height-49, 64, 49);
    [btn5 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btn5 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    [btn5 setBackgroundImage:btnImageSelected forState:UIControlStateHighlighted];
    [btn5 setTag:4];
    
    // Add my new buttons to the view
    [self.view addSubview:btn1];
    [self.view addSubview:btn2];
    [self.view addSubview:btn3];
    [self.view addSubview:btn4];
    [self.view addSubview:btn5];
    
    // Setup event handlers so that the buttonClicked method will respond to the touch up inside event.
    [btn1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn5 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)buttonClicked:(id)sender
{
    int tagNum = [sender tag];
    [self selectTab:tagNum];
}

- (void)selectTab:(int)tabID
{
    switch(tabID)
    {
        case 0:
            [btn1 setSelected:true];
            [btn2 setSelected:false];
            [btn3 setSelected:false];
            [btn4 setSelected:false];
            [btn5 setSelected:false];
            break;
        case 1:
            [btn1 setSelected:false];
            [btn2 setSelected:true];
            [btn3 setSelected:false];
            [btn4 setSelected:false];
            [btn5 setSelected:false];
            break;
        case 2:
            [btn1 setSelected:false];
            [btn2 setSelected:false];
            [btn3 setSelected:true];
            [btn4 setSelected:false];
            [btn5 setSelected:false];
            break;
        case 3:
            [btn1 setSelected:false];
            [btn2 setSelected:false];
            [btn3 setSelected:false];
            [btn4 setSelected:true];
            [btn5 setSelected:false];
            break;
        case 4:
            [btn1 setSelected:false];
            [btn2 setSelected:false];
            [btn3 setSelected:false];
            [btn4 setSelected:false];
            [btn5 setSelected:true];
            break;

    }
    
    self.selectedIndex = tabID;
}


- (void)hideNewTabbar
{
    self.btn1.hidden = YES;
    self.btn2.hidden = YES;
    self.btn3.hidden = YES;
    self.btn4.hidden = YES;
    self.btn5.hidden = YES;
}

- (void)showNewTabbar
{
    [self hideExistingTabBar];

    self.btn1.hidden = NO;
    self.btn2.hidden = NO;
    self.btn3.hidden = NO;
    self.btn4.hidden = NO;
    self.btn5.hidden = NO;
}

- (void)tabbarBadge:(int)badgeValue
{
    self.chatBadge.value = badgeValue;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
