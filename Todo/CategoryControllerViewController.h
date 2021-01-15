//
//  CategoryControllerViewController.h
//  Todo
//
//  Created by Filippo on 13/01/21.
//  Copyright © 2021 Filippo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface CategoryControllerViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *_categories;
    AppDelegate *_appDelegate;
    NSManagedObjectContext *_context;
}
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
- (IBAction)saveCategory:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *topCard;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *tableCard;

@end
