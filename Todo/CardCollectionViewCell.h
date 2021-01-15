//
//  CardCollectionViewCell.h
//  Todo
//
//  Created by Filippo on 08/01/21.
//  Copyright © 2021 Filippo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;


@end
