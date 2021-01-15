//
//  CardCollectionViewCell.m
//  Todo
//
//  Created by Filippo on 08/01/21.
//  Copyright © 2021 Filippo. All rights reserved.
//

#import "CardCollectionViewCell.h"

@implementation CardCollectionViewCell


-(void)awakeFromNib
{
    [super awakeFromNib];
    [self cardSetup];
    
}


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



@end
