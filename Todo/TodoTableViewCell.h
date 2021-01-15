//
//  TodoTableViewCell.h
//  Todo
//
//  Created by Filippo on 25/11/20.
//  Copyright © 2020 Filippo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDo+CoreDataClass.h"

@protocol CellDelegate <NSObject>
- (void)didClickOnCellAtIndex:(NSInteger)cellIndex withData:(id)data;
@end

@interface TodoTableViewCell : UITableViewCell {
    
}
@property (weak, nonatomic) IBOutlet UIImageView *doneImg;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;
@property (weak, nonatomic) id<CellDelegate>delegate;
@property (assign, nonatomic) NSInteger cellIndex;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (strong, nonatomic) ToDo *todo;

- (IBAction)infoButton:(id)sender;




@property (weak, nonatomic) IBOutlet UIView *cardView;


@end
