//
//  Company.h
//  TempName
//
//  Created by asaf ahi-mordehai on 7/30/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group, User;

@interface Company : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSSet *teams;
@property (nonatomic, retain) NSSet *users;
@end

@interface Company (CoreDataGeneratedAccessors)

- (void)addTeamsObject:(Group *)value;
- (void)removeTeamsObject:(Group *)value;
- (void)addTeams:(NSSet *)values;
- (void)removeTeams:(NSSet *)values;

- (void)addUsersObject:(User *)value;
- (void)removeUsersObject:(User *)value;
- (void)addUsers:(NSSet *)values;
- (void)removeUsers:(NSSet *)values;

@end
