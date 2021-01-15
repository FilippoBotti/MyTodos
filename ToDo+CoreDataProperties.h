//
//  ToDo+CoreDataProperties.h
//  Todo
//
//  Created by Filippo on 29/11/20.
//  Copyright © 2020 Filippo. All rights reserved.
//
//

#import "ToDo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ToDo (CoreDataProperties)

+ (NSFetchRequest<ToDo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *dueDate;
@property (nullable, nonatomic, copy) NSString *creationDate;
@property (nonatomic) BOOL state;
@property (nullable, nonatomic, copy) NSString *doneDate;
@property (nullable, nonatomic, copy) NSString *category;
@property (nullable, nonatomic, copy) NSString *note;

@end

NS_ASSUME_NONNULL_END
