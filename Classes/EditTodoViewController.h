//
//  EditTodoViewController.h
//  iTomato
//
//  Created by mac on 4/9/10.
//  Copyright 2010 Jevgeni Zelenkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoEditingViewController.h"
#import "TodoDetailViewController.h"
#import "Todo.h"


@interface EditTodoViewController : TodoEditingViewController {
	TodoDetailViewController *todoDetailVC;
	Todo *selectedTodo;
}

@property (nonatomic, retain) TodoDetailViewController *todoDetailVC;
@property (nonatomic, retain) Todo *selectedTodo;

-(IBAction) save:(id)sender;
-(void)cancel:(id)sender;

@end
