//
//  EditTodoViewController.m
//  iTomato
//
//  Created by mac on 4/9/10.
//  Copyright 2010 Jevgeni Zelenkov. All rights reserved.
//

#import "EditTodoViewController.h"
#import "iTomatoAppDelegate.h"

@implementation EditTodoViewController
@synthesize  todoDetailVC, selectedTodo;

#pragma mark -
#pragma mark View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// load todo's values
	[navTitle setTitle:@"Edit Todo"];
	[titleText setText:selectedTodo.Title];
	[datePicker setDate:selectedTodo.DueDate];
	[pomsSlider setValue:[selectedTodo.PomsTotal floatValue]];
	[pomsLabel setText:[selectedTodo.PomsTotal stringValue]];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
	todoDetailVC = nil;
	selectedTodo = nil;
}


#pragma mark -
#pragma mark Edit todo methods

/**
 Save button is pressed
 */
- (void)save:(id)sender{
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
		
		// update values of todo in core data
		[selectedTodo setTitle:titleText.text];
		[selectedTodo setDueDate:datePicker.date];
		[selectedTodo setIsArchived:[[[NSNumber alloc] initWithInt:0] autorelease]];
		[selectedTodo setPomsTotal:[[[NSNumber alloc] initWithInt:[pomsLabel.text intValue]] autorelease]];
		
		// update todo in core data
		[delegate updateCoreData];
		
		// replace todo in the the todosArray
		[delegate.todosArray replaceObjectAtIndex:todoDetailVC.todoRow withObject:selectedTodo];
		
		// sort the todosArray by title
		NSSortDescriptor *titleSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:titleSortDescriptor, nil];
		[delegate.todosArray sortUsingDescriptors:sortDescriptors];
		
		[sortDescriptors release];
		[titleSortDescriptor release];

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
	[todoDetailVC release];
	[selectedTodo release];
    [super dealloc];
}

@end
