//
//  MDTodo+CoreDataProperties.m
//  Todo
//
//  Created by Filippo on 29/11/20.
//  Copyright © 2020 Filippo. All rights reserved.
//
//

#import "MDTodo+CoreDataProperties.h"

@implementation MDTodo (CoreDataProperties)

+ (NSFetchRequest<MDTodo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MDTodo"];
}

@dynamic category;
@dynamic creationDate;
@dynamic doneDate;
@dynamic dueDate;
@dynamic name;
@dynamic note;
@dynamic state;

@end
