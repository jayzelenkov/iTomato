//
//  AddTodoViewController.h
//  iTomato
//
//  Created by mac on 4/9/10.
//  Copyright 2010 Jevgeni Zelenkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoEditingViewController.h"


@interface AddTodoViewController : TodoEditingViewController {

}

-(IBAction) save:(id)sender;
-(void)cancel:(id)sender;

@end
