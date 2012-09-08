//
//  TimerViewController.h
//  iTomato
//
//  Created by mac on 4/12/10.
//  Copyright 2010 Jevgeni Zelenkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iTomatoAppDelegate.h"
#import "Todo.h"


@interface TimerViewController : UIViewController {
	NSTimer *timer;
	IBOutlet UILabel *timerLabel;
	IBOutlet UILabel *todoTitle;
	iTomatoAppDelegate *delegate;
	NSString *todoTitlePreload;
	Todo *currentTodo;
}

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) IBOutlet UILabel *timerLabel;
@property (nonatomic, retain) IBOutlet UILabel *todoTitle;
@property (nonatomic, retain) iTomatoAppDelegate *delegate;
@property (nonatomic, retain) NSString *todoTitlePreload;
@property (nonatomic, retain) Todo *currentTodo;


-(void) ticktack;
-(void) updateTimerLabel;
-(void) backButtonPressed;
@end
