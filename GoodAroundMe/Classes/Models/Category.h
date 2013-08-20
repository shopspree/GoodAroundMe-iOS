//
//  Category.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/15/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Organization;

@interface Category : NSManagedObject

@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSSet *organizations;
@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addOrganizationsObject:(Organization *)value;
- (void)removeOrganizationsObject:(Organization *)value;
- (void)addOrganizations:(NSSet *)values;
- (void)removeOrganizations:(NSSet *)values;

@end
