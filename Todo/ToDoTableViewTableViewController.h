//
//  ToDoTableViewTableViewController.h
//  MobDevMyToDoList
//
//  Created by Filippo on 25/11/20.
//  Copyright © 2020 Filippo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ToDo+CoreDataClass.h"
#import "MDFilter.h"

@interface ToDoTableViewTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *_todos;
    AppDelegate *_appDelegate;
    NSManagedObjectContext *_context;
    ToDo *_selectedToDo;
}

@property (strong, nonatomic) IBOutlet UITableView *toDoTable;
@property (strong, nonatomic) MDFilter *filter;




@end
