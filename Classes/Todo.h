//
//  Todo.h
//  iTomato
//
//  Created by mac on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Todo :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * DueDate;
@property (nonatomic, retain) NSDate * DoneDate;
@property (nonatomic, retain) NSNumber * IsArchived;
@property (nonatomic, retain) NSNumber * PomsTotal;
@property (nonatomic, retain) NSNumber * PomsDone;
@property (nonatomic, retain) NSString * Title;

@end



