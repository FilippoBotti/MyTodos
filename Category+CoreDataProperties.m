//
//  Category+CoreDataProperties.m
//  Todo
//
//  Created by Filippo on 13/01/21.
//  Copyright © 2021 Filippo. All rights reserved.
//
//

#import "Category+CoreDataProperties.h"

@implementation Category (CoreDataProperties)

+ (NSFetchRequest<Category *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Category"];
}

@dynamic name;

@end
