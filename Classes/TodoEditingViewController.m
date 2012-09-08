//
//  TodoEditingViewController.m
//  iTomato
//
//  Created by mac on 4/9/10.
//  Copyright 2010 Jevgeni Zelenkov. All rights reserved.
//

#import "TodoEditingViewController.h"


@implementation TodoEditingViewController
@synthesize titleText, pomsSlider, pomsLabel, datePicker, navTitle;

#pragma mark -
#pragma mark View lifecycle

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	titleText = nil;
	pomsLabel = nil;
	pomsSlider = nil;
	datePicker = nil;
	navTitle = nil;
}


#pragma mark -
#pragma mark todo interface methods

- (IBAction) save:(id)sender{}; // will be reimplemented
- (IBAction) cancel:(id)sender{}; // will be reimplemented

/**
 Hides keyboard when not in the textarea
 */
- (IBAction) hideKeyboard:(id)sender {
	[titleText resignFirstResponder];
}

/**
 is executed every time when slider position is changed
 */
- (IBAction) sliderChanged:(id)sender {
	UISlider *slider = (UISlider *)sender;
	
	int progressAsInt = (int)(slider.value + 0.5f);
	NSString *tempVal = [[NSString alloc] initWithFormat:@"%d", progressAsInt];
	pomsLabel.text = tempVal;
	
    [tempVal release];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[titleText release];
	[pomsSlider release];
	[pomsLabel release];
	[datePicker release];
	[navTitle release];
    [super dealloc];
}

@end
