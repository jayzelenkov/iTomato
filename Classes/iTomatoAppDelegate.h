//
//  iTomatoAppDelegate.h
//  iTomato
//
//  Created by mac on 4/6/10.
//  Copyright Jevgeni Zelenkov 2010. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface iTomatoAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UITabBarController *tabBarController;
	UIWindow *window;
	
	NSMutableArray *todosArray;
	NSMutableArray *archivedArray;
	
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;

}

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) NSMutableArray *todosArray;
@property (nonatomic, retain) NSMutableArray *archivedArray;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

- (void) updateCoreData;

@end
