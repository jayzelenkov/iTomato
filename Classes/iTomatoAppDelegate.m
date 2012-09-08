//
//  iTomatoAppDelegate.m
//  iTomato
//
//  Created by mac on 4/6/10.
//  Copyright Jevgeni Zelenkov 2010. All rights reserved.
//

#define kUsernameKey @"username"
#define kPasswordKey @"password"
#define kEnabledKey @"enabled"


#import "iTomatoAppDelegate.h"
#import "Todo.h"


@implementation iTomatoAppDelegate

@synthesize tabBarController, window, todosArray, archivedArray, managedObjectContext;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
    [window addSubview:tabBarController.view];
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"iTomato.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}

/**
 Updates core data when needed. All classes only call this method in delegate
 */
- (void) updateCoreData {
	NSError *error = nil;
	if (managedObjectContext != nil) {
		if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			NSLog(@"Error updating Core Data. %@, %@", error, [error userInfo]);
		} 
	}
	// Sync with server will be implemented here
	
	/*
	// check sync option
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *user = [defaults objectForKey:kUsernameKey];
	NSString *pass = [defaults objectForKey:kPasswordKey];
	BOOL status = [defaults boolForKey:kEnabledKey];
	
	if (status == YES) {
		NSLog (@"status enabled");
		NSLog(@"username: %@", user);
		NSLog(@"pass: %@", pass);
		
		// send request to sync server
	}else {
		NSLog (@"sync disabled");
	}
	*/
	
}


#pragma mark -
#pragma mark Application's Documents directory

- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [tabBarController release];
    [window release];
	 
	[todosArray release];
	[archivedArray release];
	
	[managedObjectContext release];
	[managedObjectModel release];
	[persistentStoreCoordinator release];
    [super dealloc];
}

@end

