//
//  TimerViewController.m
//  iTomato
//
//  Created by mac on 4/12/10.
//  Copyright 2010 Jevgeni Zelenkov. All rights reserved.
//


#import "TimerViewController.h"


@implementation TimerViewController
@synthesize timer, timerLabel, todoTitle, delegate, todoTitlePreload, currentTodo;

static int Countdown = 0;  // number of seconds of each pomodoro
static BOOL timerAlive = NO; // timer status


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad{
	// set custom navigation item to disable timer
	UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonPressed)];
	[self.navigationItem setLeftBarButtonItem:newBackButton];
	[newBackButton release];
	
	todoTitle.text = todoTitlePreload;
	Countdown = 25 * 60;
	
	// create new timer
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(ticktack) userInfo:nil repeats:YES];
	timerAlive = YES;	
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	timerLabel = nil;
	todoTitle = nil;
	delegate = nil;
	todoTitlePreload = nil;
	currentTodo = nil;
}


#pragma mark -
#pragma mark Timer methods

/**
 decreases time left by 1 second when timeout is reached, sets pomodoros done +1 and goes back
 */
-(void) ticktack{	
	if ( (Countdown > 0) && (timerAlive == YES) ) { // timeout is not reached
		Countdown = Countdown - 1;
		[self updateTimerLabel];
	}else if ( (Countdown < 1) && (timerAlive == YES) ){ // timeout
		
		// show happy message
		UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Congrats!" 
                              message:@"You've completed a pomodoro!" 
                              delegate:self 
                              cancelButtonTitle:@"Yes!" 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
		
		// disable timer
		[timer invalidate];
		timerAlive = NO;
		
		// update todo's pomodoros done count
		int increasedPomsDone = [currentTodo.PomsDone intValue] + 1;
		[currentTodo setPomsDone:[[[NSNumber alloc] initWithInt:increasedPomsDone] autorelease]];
		[delegate updateCoreData];
		
		// go back
		[self.navigationController popViewControllerAnimated:YES];
	}
}

/**
 update time left every second
 */
-(void) updateTimerLabel{
	NSUInteger min = Countdown / 60;
	NSUInteger sec = Countdown % 60;
	
	NSString *updTimerLabel = [[NSString alloc] initWithFormat:@"%02d:%02d", min, sec];
	timerLabel.text = updTimerLabel;
	[updTimerLabel release];
}

/**
 back button pressed
 */
-(void)backButtonPressed{
	// if timer is still alive, disable it
	if(timerAlive == YES){
		[timer invalidate];
		timerAlive = NO;
	}
	
	// go back
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[timerLabel release];
	[todoTitle release];
	[delegate release];
	[todoTitlePreload release];
	[currentTodo release];
    [super dealloc];
}

@end

