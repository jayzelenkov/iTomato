//
//  ArchiveDetailViewController.h
//  iTomato
//
//  Created by mac on 4/12/10.
//  Copyright 2010 Jevgeni Zelenkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iTomatoAppDelegate.h"
#import "Todo.h"


@interface ArchiveDetailViewController : UITableViewController {
	iTomatoAppDelegate *delegate;
	Todo *selectedTodo;
	NSNumberFormatter *numberFormatter;
	NSDateFormatter *dateFormatter;
	NSUInteger todoRow;
	
}

@property (nonatomic, retain) iTomatoAppDelegate *delegate;
@property (nonatomic, retain) Todo *selectedTodo;
@property (nonatomic, retain) NSNumberFormatter *numberFormatter;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, assign) NSUInteger todoRow;

@end
