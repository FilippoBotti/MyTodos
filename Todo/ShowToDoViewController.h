//
//  ShowToDoViewController.h
//  Todo
//
//  Created by Filippo on 27/11/20.
//  Copyright © 2020 Filippo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDo+CoreDataClass.h"

@interface ShowToDoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *topCard;
@property (weak, nonatomic) IBOutlet UIView *bottomCard;
@property (weak, nonatomic) IBOutlet UILabel *todoLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITextView *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *creationDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *doneImage;
@property (strong, nonatomic) ToDo *todo;
@end
