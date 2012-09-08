//
//  ArchiveViewController.h
//  iTomato
//
//  Created by mac on 4/8/10.
//  Copyright 2010 Jevgeni Zelenkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iTomatoAppDelegate.h"


@interface ArchiveTableViewController : UITableViewController {
	iTomatoAppDelegate *delegate;
	
}
@property (nonatomic, retain) iTomatoAppDelegate *delegate;

@end
