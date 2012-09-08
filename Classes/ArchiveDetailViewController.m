//
//  ArchiveDetailViewController.m
//  iTomato
//
//  Created by mac on 4/12/10.
//  Copyright 2010 Jevgeni Zelenkov. All rights reserved.
//

#import "ArchiveDetailViewController.h"


@implementation ArchiveDetailViewController

@synthesize delegate, selectedTodo, numberFormatter, dateFormatter, todoRow;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	delegate = (iTomatoAppDelegate*) [[UIApplication sharedApplication] delegate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self setTitle:@"Archived To-Do Details"];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	delegate = nil;
	selectedTodo = nil;
	numberFormatter = nil;
	dateFormatter = nil;
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 5; // 5 cells for Todo display
	}else {
		return 1; // 1 cell for unrchive button
	}
}

/**
 Assign different cell types and cell text for cells in different sections
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellDetailId = @"DetailCell";
    static NSString *CellButtonId = @"ButtonCell";
	UITableViewCell *cell;
	
	if (indexPath.section == 0) { // To-Do Details
		cell = [tableView dequeueReusableCellWithIdentifier:CellDetailId];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellDetailId] autorelease];
		}
		
		switch (indexPath.row) {
			case 0: 
				cell.textLabel.text = @"Title";
				cell.detailTextLabel.text = selectedTodo.Title;
				break;
			case 1: 
				cell.textLabel.text = @"Due";
				cell.detailTextLabel.text = [self.dateFormatter stringFromDate:selectedTodo.DueDate];
				break;
			case 2: 
				cell.textLabel.text = @"Done";
				cell.detailTextLabel.text = [self.dateFormatter stringFromDate:selectedTodo.DoneDate];
				break;
			case 3: 
				cell.textLabel.text = @"Planned";
				NSString *tempExp = [[NSString alloc] initWithFormat:@"%@ Pomodoros", [self.numberFormatter stringFromNumber:selectedTodo.PomsTotal]];
				cell.detailTextLabel.text = tempExp;
				[tempExp release];
				break;
			case 4: 
				cell.textLabel.text = @"Completed";
				NSString *tempDone = [[NSString alloc] initWithFormat:@"%@ Pomodoros", [self.numberFormatter stringFromNumber:selectedTodo.PomsDone]];
				cell.detailTextLabel.text = tempDone;
				[tempDone release];
				break;
		}	
	}else if (indexPath.section == 1) { // Unarchive Button
		
		cell = [tableView dequeueReusableCellWithIdentifier:CellButtonId];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellButtonId] autorelease];
			[[cell textLabel] setTextAlignment:UITextAlignmentCenter];
		}
		
		cell.textLabel.text = @"Unarchive";
		
	}else {
		[NSException raise:@"Invalid section" format:@"Section %d is invalid", indexPath.section];
	}

	
    return cell;
}

/**
 Set colors for some cells
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section == 1 && indexPath.row == 0) { // unarchive button
		[cell setBackgroundColor:[UIColor colorWithRed:.9 green:1 blue:.9 alpha:1]];
	}else if (indexPath.section == 0 && indexPath.row == 4) { // poms done cell
		if (selectedTodo.PomsDone > selectedTodo.PomsTotal) {
			[cell setBackgroundColor:[UIColor colorWithRed:1 green:.7 blue:.7 alpha:1]]; // red
		}else {
			[cell setBackgroundColor:[UIColor colorWithRed:.7 green:1 blue:.7 alpha:1]]; // green
		}
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
 Action for unarchive button
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) { // Unarchive Button
		
		// set Todo-Entity as unarchived
		[selectedTodo setIsArchived:[[[NSNumber alloc] initWithInt:0] autorelease]];
				
		[delegate updateCoreData];
		
		// add to the todosArray
		[delegate.todosArray insertObject:selectedTodo atIndex:0];
		
		// remove from the archivedArray
		[delegate.archivedArray removeObjectAtIndex:todoRow];
		
		// sort the todosArray by title
		NSSortDescriptor *titleSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:titleSortDescriptor, nil];
		[delegate.todosArray sortUsingDescriptors:sortDescriptors];
		
		[sortDescriptors release];
		[titleSortDescriptor release];
		
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		[[self navigationController] popViewControllerAnimated:YES];
	}
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
	[numberFormatter release];
	[dateFormatter release];
    [super dealloc];
}

@end

