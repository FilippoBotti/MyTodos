//
//  StatsViewController.h
//  Todo
//
//  Created by Filippo on 08/01/21.
//  Copyright © 2021 Filippo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface StatsViewController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    NSMutableArray *_todos;
    AppDelegate *_appDelegate;
    NSManagedObjectContext *_context;
    NSArray *nomi;
}

@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UITextView *welcomeLabel;


@end
