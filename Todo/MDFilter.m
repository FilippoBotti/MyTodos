//
//  MDFilter.m
//  Todo
//
//  Created by Filippo on 30/11/20.
//  Copyright © 2020 Filippo. All rights reserved.
//

#import "MDFilter.h"

@implementation MDFilter

@synthesize state = _state;
@synthesize category = _category;
@synthesize dueDate = _dueDate;
@synthesize creationDate = _creationDate;

-(id)init {
    self = [super init];
    _state = -1;
    _category = @"nil";
    _dueDate = @"nil";
    _creationDate = @"nil";
    return self;
}

- (NSString *) description {
    [super description];
    return [NSString stringWithFormat:@"%@ \n %@ \n %@ \n %d", _category, _dueDate, _creationDate, _state];
}

@end
