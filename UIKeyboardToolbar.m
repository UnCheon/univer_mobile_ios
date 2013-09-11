//
//  UIKeyboardToolbar.m
//  Ya9Talk
//
//  Created by kim sam hyoun on 11. 10. 5..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIKeyboardToolbar.h"


@implementation UIKeyboardToolbar
//@synthesize m_keyboardToolbar;

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Keyboard toolbar
	if (m_keyboardToolbar == nil) {
		m_keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0f)];
		m_keyboardToolbar.barStyle = UIBarStyleBlack;
		
		NSArray *items = [NSArray arrayWithObjects:@"이전", @"다음", nil];
		UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:items];
		segment.segmentedControlStyle = UISegmentedControlStyleBar;
		// 버튼 스타일 세팅
		segment.momentary = YES;
		segment.frame = CGRectMake(0, 0, 80, 30);
		[segment addTarget:self 
					action:@selector(segmentDidChange:) 
		  forControlEvents:UIControlEventValueChanged];
		
		UIBarButtonItem *controlItem = [[UIBarButtonItem alloc] initWithCustomView:segment];
		
		UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																					  target:nil
																					  action:nil];
		
		UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"완료", @"")
																		style:UIBarButtonItemStyleDone
																	   target:self
																	   action:@selector(resignKeyboard:)];
		[m_keyboardToolbar setItems:[NSArray arrayWithObjects:controlItem, spaceBarItem, doneBarItem, nil]];
	}
	
	if (m_arrTextFields == nil) {
		m_arrTextFields = [[NSMutableArray alloc] init];
	}
}

- (void)viewDidUnload
{
	m_keyboardToolbar = nil;
	m_arrTextFields = nil;
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
// 오브젝트 세팅
- (void)addObject:(UITextField *)object 
{
	if (m_keyboardToolbar == nil)
		return;
	
	object.inputAccessoryView = m_keyboardToolbar;
	
	[m_arrTextFields addObject:object];
}
// textView
- (void)addObject_:(UITextView *)object
{
	if (m_keyboardToolbar == nil)
		return;
	
	object.inputAccessoryView = m_keyboardToolbar;
	
	[m_arrTextFields addObject:object];
}


// 오브젝트 배열 초기화
- (void)removeAllObjects
{
	[m_arrTextFields removeAllObjects];
}

- (void)killFocus
{
    NSInteger firstResponder = [self getFirstResponder];
	if (firstResponder != -1) {
		[[m_arrTextFields objectAtIndex:firstResponder] resignFirstResponder];
    }
}

- (IBAction)resignKeyboard:(id)sender
{
	[self killFocus];
}

- (void)segmentDidChange:(id)sender {
	if ([sender isKindOfClass:[UISegmentedControl class]]) {
		UISegmentedControl *segment = sender;
		
		if (segment.selectedSegmentIndex == 1)	// 다음
			[self nextField:sender];
		else	// 이전
			[self previousField:sender];
	}
}

- (IBAction)previousField:(id)sender
{
	NSInteger firstResponder = [self getFirstResponder];
	firstResponder--;
	if (firstResponder != -1)
		[[m_arrTextFields objectAtIndex:firstResponder] becomeFirstResponder];
}

- (IBAction)nextField:(id)sender
{
	NSInteger firstResponder = [self getFirstResponder];
	firstResponder++;
	if (firstResponder < [m_arrTextFields count])
		[[m_arrTextFields objectAtIndex:firstResponder] becomeFirstResponder];
    else{
        [self killFocus];
    }
    
}

- (NSInteger)getFirstResponder
{
	for (NSInteger index=0; index < [m_arrTextFields count]; index++) {
		UITextField *textField = [m_arrTextFields objectAtIndex:index];
		if ([textField isFirstResponder])
			return index;
	}
	
	return -1;
}

- (void)animateView:(UITextField *)object
{
	
}


@end
