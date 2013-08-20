//
//  Post+Create.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/25/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "Post.h"
#import "ILike.h"
#import "IJSON.h"

#define POST @"post"
#define POST_ID @"id"
#define POST_TITLE @"title"
#define POST_CAPTION @"caption"
#define POST_CREATED_AT @"created_at"
#define POST_UPDATED_AT @"created_at"
#define POST_COMMENTS_COUNT @"comments_count"
#define POST_LIKED_BY_USER @"liked_by_user"
#define POST_LIKES_COUNT @"likes_count"
#define POST_CONTRIBUTOR @"contributor"

#define POST_ORGANIZATION @"organization"
#define POST_MEDIAS @"medias"
#define MEDIA_TYPE @"type"
#define MEDIA_TYPE_PICTURE @"Picture"
#define MEDIA_TYPE_VIDEO @"Video"

@interface Post (Create) <ILike, IJSON>

+ (void)findPost:(NSString *)uid  managedObjectContext:(NSManagedObjectContext *)managedObjectContext success:(void (^)(Post *post))success failure:(void (^)(NSString *message))failure;
+ (void)newPost:(NSDictionary *)postDictionary managedObjectContext:(NSManagedObjectContext *)managedObjectContext success:(void (^)(Post *post))success failure:(void (^)(NSString *message))failure;
+ (Post *)postWithDictionary:(NSDictionary *)postDictionary  inManagedObjectContext:(NSManagedObjectContext *)context;

- (void)setWithDictionary:(NSDictionary *)postDictionary;
- (void)deletePost:(void (^)())success failure:(void (^)(NSString *message))failure;

- (void)likes:(void (^)(NSArray *likes))success failure:(void (^)(NSString *message))failure;
- (void)like:(void (^)(Like *like))success failure:(void (^)(NSString *message))failure;
- (void)unlike:(void (^)())success failure:(void (^)(NSString *message))failure;

- (void)comments:(void (^)(NSArray *comments))success failure:(void (^)(NSString *message))failure;
- (void)comment:(NSString *)content success:(void (^)())success failure:(void (^)(NSString *message))failure;
- (void)deleteComment:(Comment *)comment success:(void (^)())success failure:(void (^)(NSString *message))failure;

- (void)inappropriate:(void (^)())success failure:(void (^)(NSString *message))failure;

- (void)newsfeedForPost:(void (^)(Newsfeed *newsfeed))success failure:(void (^)(NSString *message))failure;

- (NSData *)toJSON;

@end
