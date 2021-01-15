//
//  ShowToDoViewController.m
//  Todo
//
//  Created by Filippo on 27/11/20.
//  Copyright © 2020 Filippo. All rights reserved.
//

#import "ShowToDoViewController.h"

@interface ShowToDoViewController ()

@end

@implementation ShowToDoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cardSetup];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    self.todoLabel.text = self.todo.name;
    self.categoryLabel.text = self.todo.category;
    self.dueDateLabel.text = self.todo.dueDate;
    self.creationDateLabel.text = [NSString stringWithFormat: @"Creazione: %@", self.todo.creationDate];;
    self.noteLabel.text = self.todo.note;
    if(self.todo.state) {
        [self.doneImage setHidden:NO];
        self.noteLabel.text = [NSString stringWithFormat:@"%@ \n\nCompletato: %@", self.todo.note, self.todo.doneDate];
    }
}

-(void)cardSetup
{
    [self.topCard setAlpha:1];
    self.topCard.layer.masksToBounds = true;
    self.topCard.layer.borderWidth = 0;
    self.topCard.layer.cornerRadius = 10; // if you like rounded corners
    self.topCard.layer.shadowOffset = CGSizeMake(-.2f, .2f); //%%% this shadow will hang slightly down and to the right
    self.topCard.layer.shadowRadius = 2; //%%% I prefer thinner, subtler shadows, but you can play with this
    self.topCard.layer.shadowOpacity = 1.0; //%%% same thing with this, subtle is better for me
    UIBezierPath *topPath = [UIBezierPath bezierPathWithRect:self.topCard.bounds];
    self.topCard.layer.shadowPath = topPath.CGPath;
    
    [self.bottomCard setAlpha:1];
    self.bottomCard.layer.masksToBounds = true;
    self.bottomCard.layer.borderWidth = 0;
    self.bottomCard.layer.cornerRadius = 10; // if you like rounded corners
    self.bottomCard.layer.shadowOffset = CGSizeMake(-.2f, .2f); //%%% this shadow will hang slightly down and to the right
    self.bottomCard.layer.shadowRadius = 2; //%%% I prefer thinner, subtler shadows, but you can play with this
    self.bottomCard.layer.shadowOpacity = 1.0; //%%% same thing with this, subtle is better for me
    UIBezierPath *bottomPath = [UIBezierPath bezierPathWithRect:self.bottomCard.bounds];
    self.bottomCard.layer.shadowPath = bottomPath.CGPath;
}


@end
