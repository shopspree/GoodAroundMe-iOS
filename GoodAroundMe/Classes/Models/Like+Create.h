//
//  Like+Create.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/25/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "Like.h"
#import "User+Create.h"
#import "Post+Create.h"

#define LIKE @"like"
#define LIKE_ID @"id"
#define LIKE_LIKEABLE_ID @"likeable_id"
#define LIKE_LIKEABLE_TYPE @"likeable_type"
#define LIKE_CREATED_AT @"created_at"
#define LIKE_UPDATED_AT @"updated_at"
#define LIKE_USER @"user"

@interface Like (Create)

+ (Like *)likeWithDictionary:(NSDictionary *)likeDictionary inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Like *)likeWithDictionary:(NSDictionary *)likeDictionary forUser:(User *)user inManagedObjectContext:(NSManagedObjectContext *)context;
+ (BOOL)post:(Post *)post likedByUser:(User *)user;
+ (Like *)user:(User *)user likeOnPost:(Post *)post;

- (void)setWithDictionary:(NSDictionary *)likeDictionary;


@end
