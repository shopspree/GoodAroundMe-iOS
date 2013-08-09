//
//  Hashtag+Create.h
//  TempName
//
//  Created by asaf ahi-mordehai on 7/10/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "Hashtag.h"

#define HASHTAG @"hashtag"
#define HASHTAG_ID @"id"
#define HASHTAG_CREATED_AT @"created_at"
#define HASHTAG_UPDATED_AT @"updated_at"
#define HASHTAG_KEY @"key"
#define HASHTAG_VALUE @"value"
#define HASHTAG_TAGS_COUNT @"tags_count"

@interface Hashtag (Create)

+ (void)hashtags:(NSManagedObjectContext *)context success:(void (^)())success failure:(void (^)(NSDictionary *errorData))failure;
+ (Hashtag *)hashtagWithDictionary:(NSDictionary *)hashtagDictionary inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)search:(NSString *)keyword managedObjectContext:(NSManagedObjectContext *)context success:(void (^)(NSArray *hashtagsArray))success failure:(void (^)(NSDictionary *errorData))failure;

@end
