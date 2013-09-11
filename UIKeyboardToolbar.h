//
//  UIKeyboardToolbar.h
//  Ya9Talk
//
//  Created by kim sam hyoun on 11. 10. 5..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIKeyboardToolbar : UIViewController {
	NSMutableArray *m_arrTextFields;
	
	UIToolbar *m_keyboardToolbar;
}

- (void)addObject:(UITextField *)object;
- (void)addObject_:(UITextView *)object;
- (void)removeAllObjects;
- (void)segmentDidChange:(id)sender;
	
- (void)killFocus;
- (IBAction)resignKeyboard:(id)sender;
- (IBAction)previousField:(id)sender;
- (IBAction)nextField:(id)sender;
- (NSInteger)getFirstResponder;
- (void)animateView:(UITextField *)object;


@end
