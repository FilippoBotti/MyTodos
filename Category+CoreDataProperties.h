//
//  Category+CoreDataProperties.h
//  Todo
//
//  Created by Filippo on 13/01/21.
//  Copyright © 2021 Filippo. All rights reserved.
//
//

#import "Category+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Category (CoreDataProperties)

+ (NSFetchRequest<Category *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
