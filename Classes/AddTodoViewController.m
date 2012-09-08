//
//  AddTodoViewController.m
//  iTomato
//
//  Created by mac on 4/9/10.
//  Copyright 2010 Jevgeni Zelenkov. All rights reserved.
//

#import "AddTodoViewController.h"
#import "Todo.h"
#import "iTomatoAppDelegate.h"

@implementation AddTodoViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[navTitle setTitle:@"New Todo"];
	
	NSDate *now = [NSDate date];
	[datePicker setDate:now animated:YES];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (IBAction)viewDidUnload {

}


#pragma mark -
#pragma mark Add todo methods

/**
 Save button is pressed
 */
- (IBAction)save:(id)sender{
	if([titleText.text isEqual:@""]){ // Show warning if title is not set
		UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Warning" 
                              message:@"Please, type in a title" 
                              delegate:self 
                              cancelButtonTitle:@"OK" 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
	}else{ // saving new todo
		iTomatoAppDelegate *delegate = (iTomatoAppDelegate*)[[UIApplication sharedApplication] delegate];
		// create empty todo in core data
		Todo *newTodo = (Todo *)[NSEntityDescription insertNewObjectForEntityForName:@"Todo" inManagedObjectContext:delegate.managedObjectContext];
		
		// set values of new todo in core data
		[newTodo setTitle:titleText.text];
		[newTodo setDueDate:datePicker.date];
		[newTodo setIsArchived:[[[NSNumber alloc] initWithInt:0] autorelease]];
		[newTodo setPomsTotal:[[[NSNumber alloc] initWithInt:[pomsLabel.text intValue]] autorelease]];
		[newTodo setPomsDone:[[[NSNumber alloc] initWithInt:0] autorelease]];
		
		// save new todo in core data
		[delegate updateCoreData];
		
		// add new todo into the todosArray
		[delegate.todosArray insertObject:newTodo atIndex:0];
		
		// sort the todosArray by title
		NSSortDescriptor *titleSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:titleSortDescriptor, nil];
		[delegate.todosArray sortUsingDescriptors:sortDescriptors];
		[sortDescriptors release];
		[titleSortDescriptor release];
		
		// go back
		[self dismissModalViewControllerAnimated:YES];
	}
}

/**
 cancel button is pressed
 */
- (void)cancel:(id)sender{
	// ignore everything and go back
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}

@end
