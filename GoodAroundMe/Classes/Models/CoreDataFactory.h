//
//  CoreDataFactory.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/29/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CORE_DATA_FILE @"CoreData28"

@interface CoreDataFactory : NSObject

+ (CoreDataFactory *)getInstance;

- (void)context:(void (^)(NSManagedObjectContext *managedObjectContext))create get:(void (^)(NSManagedObjectContext *managedObjectContext))get;
- (void)context:(void (^)(NSManagedObjectContext *managedObjectContext))get;

@end
