//
//  SearchViewController.h
//  Todo
//
//  Created by Filippo on 26/11/20.
//  Copyright © 2020 Filippo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDFilter.h"
#import "AppDelegate.h"

@interface SearchViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    NSMutableArray *_category;
    AppDelegate *_appDelegate;
    NSManagedObjectContext *_context;
}

@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UITextField *categoryLabel;
@property (strong, nonatomic) UIDatePicker *dueDatePicker;
@property (strong, nonatomic) UIDatePicker *creationDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *creationDateLabel;
@property (weak, nonatomic) IBOutlet UITextField *dueDateLabel;
@property (strong, nonatomic) UIPickerView *categoryPicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *stateSegmentedControl;
@property (strong,nonatomic) MDFilter *filter;


- (IBAction)selectState:(id)sender;

@end
