//
//  TodoTableViewCell.m
//  Todo
//
//  Created by Filippo on 25/11/20.
//  Copyright © 2020 Filippo. All rights reserved.
//

#import "TodoTableViewCell.h"
#import "ShowToDoViewController.h"

@implementation TodoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self cardSetup];
    
}

/*
 Inizializziamo la vista contenente la cella per mostrarla come se fosse una card
 */

-(void)cardSetup
{
    [self.cardView setAlpha:1];
    self.cardView.layer.masksToBounds = true;
    self.cardView.layer.borderWidth = 0;
    self.cardView.layer.cornerRadius = 10; // if you like rounded corners
    self.cardView.layer.shadowOffset = CGSizeMake(-.2f, .2f); //%%% this shadow will hang slightly down and to the right
    self.cardView.layer.shadowRadius = 2; //%%% I prefer thinner, subtler shadows, but you can play with this
    self.cardView.layer.shadowOpacity = 1.0; //%%% same thing with this, subtle is better for me
    
    //%%% This is a little hard to explain, but basically, it lowers the performance required to build shadows.  If you don't use this, it will lag
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.cardView.bounds];
    self.cardView.layer.shadowPath = path.CGPath;
    
}

/*
 Definiamo i metodi della cella inerenti al pulsante di info
 */

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

- (IBAction)infoButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOnCellAtIndex:withData:)]) {
        [self.delegate didClickOnCellAtIndex:_cellIndex withData:self.todo];
    }
}

@end
