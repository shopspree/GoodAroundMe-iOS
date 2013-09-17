//
//  Newsfeed+Activity.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/24/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "Newsfeed.h"

#define ACTIVITY @"activity"
#define ACTIVITY_ID @"id"
#define ACTIVITY_TYPE @"type"
#define ACTIVITY_CREATED_AT @"created_at"
#define ACTIVITY_UPDATED_AT @"updated_at"
#define ACTIVITY_USER @"user"
#define ACTIVITY_POST @"post"
#define ACTIVITY_LIKE @"like"
#define ACTIVITY_COMMENT @"comment"

#define POST_ACTIVITY @"Post"
#define LIKE_ACTIVITY @"Like"
#define COMMENT_ACTIVITY @"Comment"

@interface Newsfeed (Activity)

+ (void)synchronizeInContext:(NSManagedObjectContext *)context
                     success:(void (^)())success
                     failure:(void (^)(NSString *message))failure;

+ (Newsfeed *)newsfeedWithActivity:(NSDictionary *)activityDictionary inManagedObjectContext:(NSManagedObjectContext *)context;

- (void)setWithDictionary:(NSDictionary *)activityDictionary;
- (void)updateWithDictionary:(NSDictionary *)activityDictionary;

@end
