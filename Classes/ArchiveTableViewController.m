//
//  ArchiveViewController.m
//  iTomato
//
//  Created by mac on 4/8/10.
//  Copyright 2010 Jevgeni Zelenkov. All rights reserved.
//

#import "ArchiveTableViewController.h"
#import "ArchiveDetailViewController.h"
#import "Todo.h"


@implementation ArchiveTableViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
	delegate = (iTomatoAppDelegate*) [[UIApplication sharedApplication] delegate];
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	// populate table with items from core data
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Todo" inManagedObjectContext:delegate.managedObjectContext];
	[request setEntity:entity];
	
	// only get archived items
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"IsArchived == YES"];
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
		NSLog(@"archived todos fetching error");
	}
	
	// assign fetch results to the archivedArray of the delegate
	delegate.archivedArray = mutableFetchResults;
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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [delegate.archivedArray count];
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
    
	Todo *todo = (Todo *)[delegate.archivedArray objectAtIndex:indexPath.row];
	cell.textLabel.text = todo.Title;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}


/**
 Shows details of selected todo
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArchiveDetailViewController *detailView = [[ArchiveDetailViewController alloc] initWithNibName:@"TodoDetailView" bundle:nil];
	detailView.selectedTodo = (Todo *)[delegate.archivedArray objectAtIndex:indexPath.row];
	detailView.todoRow = [indexPath row];
	
	[self.navigationController pushViewController:detailView animated:YES];
	[detailView release];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) { // delete mode is on
        // Delete todo from core data, archivedArray and current table
		Todo *todo = (Todo *)[delegate.archivedArray objectAtIndex:indexPath.row];
		[delegate.managedObjectContext deleteObject:todo];
		
		[delegate.archivedArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		
	}
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}


@end

