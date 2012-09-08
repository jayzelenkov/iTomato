//
//  TodoDetailViewController.m
//  iTomato
//
//  Created by mac on 4/6/10.
//  Copyright 2010 Jevgeni Zelenkov. All rights reserved.
//

#import "TodoDetailViewController.h"
#import "EditTodoViewController.h"
#import "TimerViewController.h"

@implementation TodoDetailViewController

@synthesize delegate, selectedTodo, numberFormatter, dateFormatter, todoRow;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	delegate = (iTomatoAppDelegate*) [[UIApplication sharedApplication] delegate];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editTodo)];
	[self setTitle:@"To-Do Details"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
		
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	delegate = nil;
	selectedTodo = nil;
	dateFormatter = nil;
	numberFormatter = nil;
}


#pragma mark -
#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3; // todo details, archive button, pomodoro button
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
		return 4; // 4 cells for Todo details
	}else {
		return 1; // 1 cell for each archive button and pomodoro button
	}
}

/**
 Assign different cell types and cell text for cells in different sections
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellDetailId = @"DetailCell";
    static NSString *CellButtonId = @"ButtonCell";
	UITableViewCell *cell;

	
	if (indexPath.section == 0){ // To-Do Details
		
		cell = [tableView dequeueReusableCellWithIdentifier:CellDetailId];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellDetailId] autorelease];
		}
		
		switch (indexPath.row) { // text for each details cell
			case 0: 
				cell.textLabel.text = @"Title";
				cell.detailTextLabel.text = selectedTodo.Title;
				break;
			case 1: 
				cell.textLabel.text = @"Due";
				cell.detailTextLabel.text = [self.dateFormatter stringFromDate:selectedTodo.DueDate];
				break;
			case 2: 
				cell.textLabel.text = @"Planned";
				NSString *tempExp = [[NSString alloc] initWithFormat:@"%@ Pomodoros", [self.numberFormatter stringFromNumber:selectedTodo.PomsTotal]];
				cell.detailTextLabel.text = tempExp;
				[tempExp release];
				break;
			case 3: 
				cell.textLabel.text = @"Completed";
				NSString *tempDone = [[NSString alloc] initWithFormat:@"%@ Pomodoros", [self.numberFormatter stringFromNumber:selectedTodo.PomsDone]];
				cell.detailTextLabel.text = tempDone;
				[tempDone release];
				break;
		}
		
	}else if (indexPath.section == 1 ||  indexPath.section == 2) { // Archive or Pomodoro Button (they use the same cell type)
		
		cell = [tableView dequeueReusableCellWithIdentifier:CellButtonId];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellButtonId] autorelease];
			[[cell textLabel] setTextAlignment:UITextAlignmentCenter];
		}
		
		if (indexPath.section == 1) {
			cell.textLabel.text = @"Archive";
		} else {
			cell.textLabel.text = @"Do it now!";
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // to indicate navigation controller
		}
		
	}else{
		[NSException raise:@"Invalid section" format:@"Section %d is invalid", indexPath.section];
	}

		
    return cell;
}

/**
 Set colors for some cells
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section == 1 && indexPath.row == 0) { // archive button color
		[cell setBackgroundColor:[UIColor colorWithRed:1 green:.9 blue:.9 alpha:1]];
		
	} else if (indexPath.section == 2 && indexPath.row == 0) { // pomodoro button color
		[cell setBackgroundColor:[UIColor colorWithRed:.9 green:.9 blue:1 alpha:1]];
	}
}

/**
 Disable selection of cells from the details section (section = 0)
 */
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		return nil;
	}
    return indexPath;
}

/**
 Actions for archive button and pomodoro button
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1 && indexPath.row == 0) { // Archive Button pressed
		
		// set Todo-Entity as archived
		[selectedTodo setIsArchived:[[[NSNumber alloc] initWithInt:1] autorelease]];
		
		// set Todo-DoneDate
		[selectedTodo setDoneDate:[NSDate date]];
		
		// save changes in core data
		[delegate updateCoreData];
			
		// add todo to the archivedArray
		[delegate.archivedArray insertObject:selectedTodo atIndex:0];
			
		// remove todo from the todosArray
		[delegate.todosArray removeObjectAtIndex:todoRow];
			
		// sort the archivedArray by title
		NSSortDescriptor *titleSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:titleSortDescriptor, nil];
		[delegate.archivedArray sortUsingDescriptors:sortDescriptors];
		[sortDescriptors release];
		[titleSortDescriptor release];
		
		// navigate back
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		[[self navigationController] popViewControllerAnimated:YES];
		
	} else if(indexPath.section == 2 && indexPath.row == 0){ // Pomodoro Button	pressed
		// initialize
		TimerViewController *timerVC = [[TimerViewController alloc] initWithNibName:@"TimerView" bundle:nil];
		
		// set todo title, todo-pointer and navigation title
		timerVC.todoTitlePreload = selectedTodo.Title;
		timerVC.currentTodo = selectedTodo;
		timerVC.title = @"Timer";
		
		// show timer
		[self.navigationController pushViewController:timerVC animated:YES];
		[timerVC release];
	}
}

#pragma mark -
#pragma mark TodoDetail methods

/**
 Initialize and display edit view controller
 */
- (void)editTodo{
	// initialize
	EditTodoViewController *editTodoVC = [[EditTodoViewController alloc] initWithNibName:@"TodoEditingView" bundle:nil];
	editTodoVC.selectedTodo = selectedTodo;
	
	// send pointer of tableView (will need to reload detail view table data)
	editTodoVC.todoDetailVC = self;
	
	// display edit view
	[self presentModalViewController:editTodoVC animated:YES];
	[editTodoVC release];
}


#pragma mark -
#pragma mark Number Formatter

- (NSNumberFormatter *)numberFormatter {
	if (numberFormatter == nil) {
		numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[numberFormatter setMaximumFractionDigits:0];
	}
	return numberFormatter;	
}


#pragma mark -
#pragma mark Date Formatter

- (NSDateFormatter *)dateFormatter {	
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];		
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	}
	return dateFormatter;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[selectedTodo release];
	[dateFormatter release];
	[numberFormatter release];
    [super dealloc];
}


@end

