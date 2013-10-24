//
//  OrganizationCategory.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 10/22/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Organization;

@interface OrganizationCategory : NSManagedObject

@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSSet *organizations;
@end

@interface OrganizationCategory (CoreDataGeneratedAccessors)

- (void)addOrganizationsObject:(Organization *)value;
- (void)removeOrganizationsObject:(Organization *)value;
- (void)addOrganizations:(NSSet *)values;
- (void)removeOrganizations:(NSSet *)values;

@end
