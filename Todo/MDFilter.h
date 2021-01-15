//
//  MDFilter.h
//  Todo
//
//  Created by Filippo on 30/11/20.
//  Copyright © 2020 Filippo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDFilter : NSObject

@property (strong,nonatomic) NSString *category;
@property (strong,nonatomic) NSString *creationDate;
@property (nonatomic) int state;
@property (strong, nonatomic) NSString *dueDate;


-(id) init;
@end
