//
//  ChatRoomsViewController.m
//  Univer
//
//  Created by 백 운천 on 12. 10. 3..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import "ChatRoomsViewController.h"
#import "ChatViewController.h"
#import "TDBadgedCell.h"
#import "CustomTabbarController.h"


#define CHATROOM_URL                       @"http://54.249.52.26/feeds/chatRooms/user_id="


@implementation ChatRoomsViewController
@synthesize uniTableView, uniArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"ChatRooms";
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:@"login" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:@"push" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:@"reloadChatRoom" object:nil];
        

        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 31, 44)];
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame =CGRectMake(0, 7, 31, 31);
        [btn1 setBackgroundImage:[UIImage imageNamed:@"ch_settinng_seleted.png"] forState:UIControlStateHighlighted];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"ch_settinng_unseleted.png"] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(editBtn:) forControlEvents:UIControlEventTouchUpInside];
        [leftView addSubview:btn1];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
        self.navigationItem.leftBarButtonItem = leftItem;

        
        uniArray = [[NSMutableArray alloc] initWithCapacity:10];
        badgeCount = 0;
        isParsing = NO;
        
        userDefaults = [NSUserDefaults standardUserDefaults];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"cm_navigation_background_2.jpg"] forBarMetrics:UIBarMetricsDefault];
    
    [super viewDidLoad];
    
    
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    today = [dateFormat stringFromDate:date];
    NSLog(@"today iphone : %@", today);
    

//    NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"이근호", @"title", @"책 팔렸나요?", @"description", @"5분전", @"pubDate", nil];
//    [uniArray addObject:dic1];
    
    [self.uniTableView reloadData];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.uniTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma -TableView Cycle


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d", [uniArray count]);
    return [uniArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    TDBadgedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    UIImageView *cellBackgroundView;
    UILabel *timeLabel;
    UILabel *timeLabel2;
    UILabel *lastMessageLabel;
    UILabel *titleLabel;
    UILabel *seperateLabel;
    int cellBadgeCount;
    
    if (cell == nil) {
        cell = [[TDBadgedCell alloc] init];

        cellBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
        cellBackgroundView.image = [UIImage imageNamed:@"bk_normal.jpg"];
        cell.backgroundView = cellBackgroundView;
        
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 220, 21)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:17];
        [cell addSubview:titleLabel];
        
        seperateLabel = [[UILabel alloc] initWithFrame:CGRectMake(205, 7, 220, 21)];
        seperateLabel.backgroundColor = [UIColor clearColor];
        seperateLabel.textColor = [UIColor lightGrayColor];
        seperateLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:13];
        [cell addSubview:seperateLabel];



        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 5, 70, 30)];
        [timeLabel setFont:[UIFont systemFontOfSize: 11]];
        timeLabel.textAlignment = UITextAlignmentRight;
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        timeLabel.textColor = [UIColor grayColor];

        timeLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(250, 25, 70, 30)];
        [timeLabel2 setFont:[UIFont systemFontOfSize: 11]];
        timeLabel2.textAlignment = UITextAlignmentRight;
        [timeLabel2 setBackgroundColor:[UIColor clearColor]];
        timeLabel2.textColor = [UIColor grayColor];

        lastMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 250, 30)];
        [lastMessageLabel setFont:[UIFont systemFontOfSize: 14]];
        lastMessageLabel.textAlignment = UITextAlignmentLeft;
        [lastMessageLabel setBackgroundColor:[UIColor clearColor]];
        lastMessageLabel.textColor = [UIColor grayColor];
        

        [cell addSubview:timeLabel];
        [cell addSubview:lastMessageLabel];
    }
    
    
    NSDictionary *dic = [uniArray objectAtIndex:indexPath.row];
    
    titleLabel.text = [dic objectForKey:@"title"];
    
    if ([[dic objectForKey:@"seller"] isEqual:@"1"]) {
        seperateLabel.text = @"판매중";
    }else{
        seperateLabel.text = @"구매중";
    }
    
    
    NSString *timeString = [dic objectForKey:@"edited"];
    NSArray *timeArray = [timeString componentsSeparatedByString:@"-"];
    
    
    NSArray *arrivedArray = [timeString componentsSeparatedByString:@" "];
    NSString *arrivedTime = [arrivedArray objectAtIndex:0];
    NSLog(@"%@", arrivedTime);
    
    
    NSString *year = [[timeArray objectAtIndex:0] substringWithRange:NSMakeRange(2, 2)];
    NSString *month = [timeArray objectAtIndex:1];
    NSString *dayTimeString = [timeArray objectAtIndex:2];
    NSArray *dayTimeArray = [dayTimeString componentsSeparatedByString:@" "];
    NSString *day = [dayTimeArray objectAtIndex:0];
    NSString *timeString2 = [dayTimeArray objectAtIndex:1];
    
    NSArray *timeArray2 = [timeString2 componentsSeparatedByString:@":"];
    
    NSString *arrivedMin = [NSString stringWithFormat:@"%@:%@", [timeArray2 objectAtIndex:0], [timeArray2 objectAtIndex:1]];
    
    
    NSLog(@"%@, %@", today, arrivedTime);
    
    
    if ([today isEqualToString:arrivedTime]) {
        timeLabel.text = arrivedMin;
    }else{
        timeLabel.text = [NSString stringWithFormat:@"%@.%@.%@", year, month, day];
    }
    
    
    

    
    lastMessageLabel.text = [dic objectForKey:@"description"];
    cellBadgeCount = [[dic objectForKey:@"count"] intValue];
    
    if (cellBadgeCount == 0) {
        cell.badgeString = NULL;
    }else{
        cell.badgeString = [dic objectForKey:@"count"];
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatViewController *chatViewCtr = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    
    chatViewCtr.hidesBottomBarWhenPushed = YES;
    chatViewCtr.to_nick = [[uniArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    chatViewCtr.to_id = [[uniArray objectAtIndex:indexPath.row] objectForKey:@"to_id"];
    chatViewCtr.dic = [uniArray objectAtIndex:indexPath.row];
    chatViewCtr.kinds = 0;
    
    chatViewCtr.indexPath = indexPath.row;
        
    [self.navigationController pushViewController:chatViewCtr animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma - RSS

- (void)update:(NSNotification *)notification
{
    badgeCount = 0;
    if (isParsing) {
        return;
    }else{
        isParsing = YES;
        [NSThread detachNewThreadSelector:@selector(threadStart) toTarget:self withObject:nil];
    }
}

- (void)threadStart
{
    NSLog(@"user_id : %@", [userDefaults objectForKey:@"user_id"]);
    @autoreleasepool {
            [uniArray removeAllObjects];
            NSString *feedAddress = [NSString stringWithFormat:@"%@%@/", CHATROOM_URL, [userDefaults objectForKey:@"user_id"]];
//            [self uniRSSFeed:feedAddress];
            [self.uniTableView reloadData];
            isParsing = NO;
    }
    
}

- (void)uniRSSFeed:(NSString *)feedAddress
{
    
    NSLog(@"%@", feedAddress);
    NSURL *url = [NSURL URLWithString: feedAddress];
    NSError *error = nil;
    CXMLDocument *rssParser = [[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:&error];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"팝니다." message:@"네트워크상태를 확인하세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
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
        badgeCount = badgeCount + [[newsItem objectForKey:@"count"] intValue];
        [uniArray addObject:[newsItem copy]];
    }

    [self updateTabBadge];
}


- (void)editBtn:(id)sender
{
    if (self.uniTableView.editing) {
        [self.uniTableView setEditing:NO animated:YES];
        [editBtn setTitle:@"편집" forState:UIControlStateNormal];
    }else {
        [self.uniTableView setEditing:YES animated:YES];
        [editBtn setTitle:@"완료" forState:UIControlStateNormal];
    }
}

- (void)updateTabBadge
{

    if (badgeCount == 0) {
        [(CustomTabbarController *)self.tabBarController tabbarBadge:NULL];

    }else{
        [(CustomTabbarController *)self.tabBarController tabbarBadge:badgeCount];
    }
}


@end
