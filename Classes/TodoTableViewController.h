//
//  TodoViewController.h
//  iTomato
//
//  Created by mac on 4/6/10.
//  Copyright 2010 Jevgeni Zelenkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iTomatoAppDelegate.h"


@interface TodoTableViewController : UITableViewController {
	iTomatoAppDelegate *delegate;

}
@property (nonatomic, retain) iTomatoAppDelegate *delegate;

- (void)addTodo;

@end
