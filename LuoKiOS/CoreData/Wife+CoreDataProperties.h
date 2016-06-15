//
//  Wife+CoreDataProperties.h
//  LuoKiOS
//
//  Created by lkshine on 16/5/29.
//  Copyright © 2016年 lkshine. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Wife.h"

NS_ASSUME_NONNULL_BEGIN

@interface Wife (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSManagedObject *husband;

@end

NS_ASSUME_NONNULL_END
