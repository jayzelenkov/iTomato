//
//  TodoViewController.m
//  iTomato
//
//  Created by mac on 4/6/10.
//  Copyright 2010 Jevgeni Zelenkov. All rights reserved.
//

#import "TodoTableViewController.h"
#import "TodoDetailViewController.h"
#import "AddTodoViewController.h"
#import "Todo.h"

@implementation TodoTableViewController
@synthesize delegate;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	delegate = (iTomatoAppDelegate*) [[UIApplication sharedApplication] delegate];

	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTodo)];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	// populate table with items from core data
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Todo" inManagedObjectContext:delegate.managedObjectContext];
	[request setEntity:entity];
	
	// only get non-archived items
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"IsArchived == NO"];
	[request setPredicate:predicate];
	
	// sort by title
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Title" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	NSError *error;
	NSMutableArray *mutableFetchResults = [[delegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	
	if(mutableFetchResults == nil) {
		NSLog(@"todos fetching error");
	}
	
	// assign fetch results to the todosArray of the delegate
	delegate.todosArray = mutableFetchResults;
	[mutableFetchResults release];
	[request release];
	
	// reload data
	[self.tableView reloadData];
	
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
	delegate = nil;
}

#pragma mark -
#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [delegate.todosArray count];
}

/**
 each cell's text is the todo title
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	Todo *todo = (Todo *)[delegate.todosArray objectAtIndex:indexPath.row];
	cell.textLabel.text = todo.Title;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

/**
 Shows details of selected todo
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// initialize
	TodoDetailViewController *detailView = [[TodoDetailViewController alloc] initWithNibName:@"TodoDetailView" bundle:nil];
	detailView.selectedTodo = (Todo *)[delegate.todosArray objectAtIndex:indexPath.row];
	detailView.todoRow = [indexPath row];
	
	// display todo details view
	[self.navigationController pushViewController:detailView animated:YES];
	[detailView release];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) { // delete mode is on
        // Delete todo from core data, todosArray and current table
		Todo *todo = (Todo *)[delegate.todosArray objectAtIndex:indexPath.row];
		[delegate.managedObjectContext deleteObject:todo];
		[delegate.todosArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	} 
}


#pragma mark -
#pragma mark TodoTable methods
/**
 Shows an add todo view
 */
- (void)addTodo{
	// initialize
	AddTodoViewController *addTodoVC = [[AddTodoViewController alloc] initWithNibName:@"TodoEditingView" bundle:nil];
	
	// display add todo view
	[self presentModalViewController:addTodoVC animated:YES];
	[addTodoVC release];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[super dealloc];
}

@end

