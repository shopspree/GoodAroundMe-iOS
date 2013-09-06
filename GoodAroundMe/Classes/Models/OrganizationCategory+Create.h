//
//  OrganizationCategory+Create.h
//  TempName
//
//  Created by asaf ahi-mordehai on 7/16/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "OrganizationCategory.h"

#define CATEGORY_ID @"id"
#define CATEGORY_NAME @"name"
#define CATEGORY_IMAGE_URL @"image_url"
#define CATEGORY_ORGANIZATIONS @"organizations"

@interface OrganizationCategory (Create)

+ (OrganizationCategory *)categoryWithDictionary:(NSDictionary *)categoryDictionary inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)categories:(NSManagedObjectContext *)managedObjectContext success:(void (^)(NSArray *categories))success failure:(void (^)(NSString *message))failure;

@end
