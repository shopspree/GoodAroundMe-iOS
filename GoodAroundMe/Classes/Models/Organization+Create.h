//
//  Organization+Create.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/10/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "Organization.h"

#define ORGANIZATION @"organization"
#define ORGANIZATION_ID @"id"
#define ORGANIZATION_NAME @"name"
#define ORGANIZATION_FOLLOWERS_COUNT @"followers_count"
#define ORGANIZATION_POSTS_COUNT @"posts_count"
#define ORGANIZATION_IMAGE_THUMBNAIL_URL @"image_thumbnail_url"
#define ORGANIZATION_WEBSITE_URL @"website_url"
#define ORGANIZATION_ABOUT @"about"
#define ORGANIZATION_LOCATION @"location"
#define ORGANIZATION_IS_FOLLOWED @"is_followed"


@interface Organization (Create)

+ (Organization *)organizationWithDictionary:(NSDictionary *)organizationDictionary inManagedObjectContext:(NSManagedObjectContext *)context;

- (void)create:(void (^)())success failure:(void (^)(NSString *message))failure;
- (void)update:(void (^)())success failure:(void (^)(NSString *message))failure;
- (void)newsfeedForOrganization:(void (^)())success failure:(void (^)(NSString *message))failure;
- (NSArray *)postsForOrganization:(void (^)(NSArray *posts))success failure:(void (^)(NSString *message))failure;
- (NSArray *)followersForOrganization:(void (^)(NSArray *followers))success failure:(void (^)(NSString *message))failure;
- (NSData *)toJSON;
- (NSDictionary *)toDictionary;
- (NSString *)log;

@end
