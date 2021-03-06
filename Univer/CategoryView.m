//
//  CategoryView.m
//  Univer
//
//  Created by ucb on 12. 4. 10..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "CategoryView.h"

@implementation CategoryView
@synthesize delegate, kinds, address, filteredListContent, spiner, alert;
@synthesize category, id, dic_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    Utils *util = [Utils sharedUtils];
    [util setDelegate:self];
    [util getCategoryList:category id:id];
    
    
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"cm_navigation_background_2.jpg"] forBarMetrics:UIBarMetricsDefault];

    [super viewDidLoad];
    

    /*
    [category_array removeAllObjects];
    [self.tableView reloadData];
    
    alert = [[UIAlertView alloc] initWithTitle:@"잠시만 기다려 주세요.." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    
    spiner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spiner.center = CGPointMake(alert.bounds.size.width/2, alert.bounds.size.height/2+10);
    [spiner startAnimating];
    [alert addSubview:spiner];

    
    filteredListContent = [[NSMutableArray alloc] initWithCapacity:10];
    
    if (kinds == 0) 
        self.title = @"지역 선택";
    else if(kinds == 1)
        self.title = @"학교 선택";
    else if(kinds == 2)
        self.title = @"단과대 선택";
    
    
    [NSThread detachNewThreadSelector:@selector(start_rss) toTarget:self withObject:nil];
    // Do any additional setup after loading the view from its nib.
    
    */
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    self.spiner = nil;
    self.alert = nil;
    self.address = nil;
    self.filteredListContent = nil;
    self.delegate = nil;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma - TableView cycle

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    if (tableView == self.searchDisplayController.searchResultsTableView) 
        return @"";
    else{
        NSDictionary *Dic = [sectionData objectAtIndex:section];
        NSString *sectionName = [Dic objectForKey:@"section_name"];
        return sectionName;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    if (tableView == self.searchDisplayController.searchResultsTableView) 
        return 1;
    else
        return [sectionData count];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredListContent count];
    }else{
        NSDictionary *Dic = [sectionData objectAtIndex:section];
        NSMutableArray *ar = [Dic objectForKey:@"name"];
        return [ar count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [[filteredListContent objectAtIndex:indexPath.row] objectForKey:@"name"];
    }else{
        NSDictionary *Dic = [sectionData objectAtIndex:indexPath.section];
        NSMutableArray *ar = [Dic objectForKey:@"name"];
        cell.textLabel.text = [ar objectAtIndex:indexPath.row]; 
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    CDataManager *dataManager = [CDataManager getDataManager];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSLog(@"전체선택");
        if ([category isEqualToString:@"region"]){
            
            [dataManager.data removeObjectForKey:@"region"];
            [dataManager.data removeObjectForKey:@"university"];
            [dataManager.data removeObjectForKey:@"college"];
        }
        else if([category isEqualToString:@"university"]){
            [dataManager.data removeObjectForKey:@"university"];
            [dataManager.data removeObjectForKey:@"college"];
        }
        else if([category isEqualToString:@"college"]){
            [dataManager.data removeObjectForKey:@"college"];
        }
    }else{
        
        self.dic_ = [[NSDictionary alloc] init];
        
        
        
        

        if (tableView == self.searchDisplayController.searchResultsTableView) {
            dic_ = [filteredListContent objectAtIndex:indexPath.row];
        }else{
            NSDictionary *dic = [sectionData objectAtIndex:indexPath.section];
            NSMutableArray *title_array = [dic objectForKey:@"name"];
            NSMutableArray *nick_array = [dic objectForKey:@"nick"];
            NSMutableArray *uni_id = [dic objectForKey:@"id"];
            dic_ = [NSDictionary dictionaryWithObjectsAndKeys:[title_array objectAtIndex:indexPath.row], @"name", [nick_array objectAtIndex:indexPath.row], @"nick", [uni_id objectAtIndex:indexPath.row], @"id", nil];

            NSLog(@"%@", dic_);
    
        }

        
        CDataManager *dataManager = [CDataManager getDataManager];
        if ([category isEqualToString:@"region"]){

            [dataManager.data setObject:dic_ forKey:@"region"];
            [dataManager.data removeObjectForKey:@"university"];
            [dataManager.data removeObjectForKey:@"college"];
        }
        else if([category isEqualToString:@"university"]){
            [dataManager.data setObject:dic_ forKey:@"university"];
            [dataManager.data removeObjectForKey:@"college"];
        }
        else if([category isEqualToString:@"college"]){
            [dataManager.data setObject:dic_ forKey:@"college"];
        }
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"launch" object:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}




- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)name atIndex:(NSInteger)index {
    if (index == 0) {
        [self.tableView setContentOffset:CGPointMake(0,0) animated: NO];
    }
    for(int i = 0; i < [sectionData count]; i++)
    {
        NSDictionary *Dic = [sectionData objectAtIndex:i];
        NSString *sectionName = [Dic objectForKey:@"section_name"];
        if([sectionName isEqualToString:name])
        {
            return i;
        }
    }
    return -1;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView 
{
    return index_array;
}

#pragma mark - Indexing & Search

- (NSString *)subtract:(NSString*)data 
{
	
	NSComparisonResult result = [data compare:@"나"];
	if(result == NSOrderedAscending) 
		return @"ㄱ";
	result = [data compare:@"다"];
	if(result == NSOrderedAscending) 
		return @"ㄴ";
	result = [data compare:@"라"];
	if(result == NSOrderedAscending) 
		return @"ㄷ";
	result = [data compare:@"마"];
	if(result == NSOrderedAscending) 
		return @"ㄹ";
	result = [data compare:@"바"];
	if(result == NSOrderedAscending) 
		return @"ㅁ";
	result = [data compare:@"사"];
	if(result == NSOrderedAscending) 
		return @"ㅂ";
	result = [data compare:@"아"];
	if(result == NSOrderedAscending) 
		return @"ㅅ";
	result = [data compare:@"자"];
	if(result == NSOrderedAscending) 
		return @"ㅇ";
	result = [data compare:@"차"];
	if(result == NSOrderedAscending) 
		return @"ㅈ";
	result = [data compare:@"카"];
	if(result == NSOrderedAscending) 
		return @"ㅊ";
	result = [data compare:@"타"];
	if(result == NSOrderedAscending) 
		return @"ㅋ";
	result = [data compare:@"파"];
	if(result == NSOrderedAscending) 
		return @"ㅌ";
	result = [data compare:@"하"];
	if(result == NSOrderedAscending) 
		return @"ㅍ";
    return @"ㅎ";
}

- (void)reset
{        
    
    sectionData = [[NSMutableArray alloc] init];
    index_array = [[NSMutableArray alloc] initWithCapacity:100];
	Index = [[NSArray alloc] initWithObjects:UITableViewIndexSearch, @"★", @"ㄱ", @"ㄴ", @"ㄷ", @"ㄹ", @"ㅁ", @"ㅂ", @"ㅅ", @"ㅇ", @"ㅈ", @"ㅊ", @"ㅋ", @"ㅌ", @"ㅍ", @"ㅎ",@"A",@"●",@"F",@"●",@"K",@"●",@"P",@"●",@"U",@"●",@"Z",@"#", nil];
    [index_array addObject:[Index objectAtIndex:0]];
    
    [sectionData removeAllObjects];
    
	NSMutableArray *temp[[Index count]];
    NSMutableArray *temp_nick[[Index count]];
    NSMutableArray *temp_id[[Index count]];    
	for(int i = 0; i < [Index count]; i++)
	{
		temp[i] = [NSMutableArray arrayWithCapacity:100];
		temp_nick[i] = [NSMutableArray arrayWithCapacity:100];        
        temp_id[i] = [NSMutableArray arrayWithCapacity:100];                
	}
	NSArray *name = category_array;
	for(int i = 0; i < [Index count]; i++)
	{
		NSString *pre = [Index objectAtIndex:i];
		for(int j = 0; j < [name count]; j++)
		{
			NSString *str = [[name objectAtIndex:j] objectForKey:@"name"];
            NSString *nick = [[name objectAtIndex:j] objectForKey:@"nick"];            
            NSString *id_string = [[name objectAtIndex:j] objectForKey:@"id"];            
			if([pre isEqualToString:[self subtract:str]])
			{
				[temp[i] addObject:str];
				[temp_nick[i] addObject:nick];                
                [temp_id[i] addObject:id_string];
			}
		}
        if ([temp[i] count] !=0)
        {
            [index_array addObject:pre];
        }
	}
	for(int i = 0; i < [Index count]; i++)
	{
		if([temp[i] count] != 0){
            
			NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:[Index objectAtIndex:i], @"section_name", temp[i], @"name", temp_id[i], @"id", temp_nick[i], @"nick" ,nil];
			[sectionData addObject:data];
		}
	}
    
    NSArray *allArray = [NSArray arrayWithObject:@"전체선택"];
    
    NSDictionary *allDic = [NSDictionary dictionaryWithObjectsAndKeys:@"★", @"section_name", allArray, @"name", @"", @"id", @"전체선택", @"nick", nil];
    [sectionData insertObject:allDic atIndex:0];

}

- (void)filterContentForSearchText:(NSString*)searchText
{
    
    [self.filteredListContent removeAllObjects];
    
    for (NSDictionary *dic in category_array)
    {
        // NSComparisonResult result = [person.name localizedCompare:searchText];
        NSRange range = [[dic objectForKey:@"name"] rangeOfString:searchText];
        if (range.location != NSNotFound)
        {
            [self.filteredListContent addObject:dic];
        }
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark - Utils Delegate
- (void)didFinishLoadingCategoryData:(NSMutableArray *)feedArray
{
    NSLog(@"%@", feedArray);
    category_array = feedArray;
    [self reset];
    [self.tableView reloadData];
}



@end
