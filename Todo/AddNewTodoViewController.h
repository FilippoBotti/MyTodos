//
//  AddNewTodoViewController.h
//  Todo
//
//  Created by Filippo on 26/11/20.
//  Copyright © 2020 Filippo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface AddNewTodoViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate> {
    NSMutableArray *_category;
    AppDelegate *_appDelegate;
    NSManagedObjectContext *_context;
    NSUserDefaults *_defaults;
    NSDate *_triggerNotificationDate;
}

@property (weak, nonatomic) IBOutlet UIScrollView *cardView;
- (IBAction)saveToDo:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *toDoLabel;
@property (weak, nonatomic) IBOutlet UITextField *categoryLabel;
@property (weak, nonatomic) IBOutlet UITextField *dueDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *noteLabel;
@property (strong, nonatomic) UIDatePicker *dueDatePicker;
@property (strong, nonatomic) UIPickerView *categoryPicker;
@end
