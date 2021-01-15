//
//  ToDo+CoreDataProperties.m
//  Todo
//
//  Created by Filippo on 29/11/20.
//  Copyright © 2020 Filippo. All rights reserved.
//
//

#import "ToDo+CoreDataProperties.h"

@implementation ToDo (CoreDataProperties)

+ (NSFetchRequest<ToDo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ToDo"];
}

@dynamic name;
@dynamic dueDate;
@dynamic creationDate;
@dynamic state;
@dynamic doneDate;
@dynamic category;
@dynamic note;

@end
