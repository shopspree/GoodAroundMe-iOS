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
#define POST_CONTENT @"content"
#define POST_CREATED_AT @"created_at"
#define POST_UPDATED_AT @"created_at"
#define POST_COMMENTS_COUNT @"comments_count"
#define POST_LIKED_BY_USER @"liked_by_user"
#define POST_LIKES_COUNT @"likes_count"
#define POST_USER @"user"
#define POST_HASHTAGS @"hashtags"
#define POST_MEDIAS @"medias"
#define MEDIA_TYPE @"type"
#define MEDIA_TYPE_PICTURE @"Picture"
#define MEDIA_TYPE_VIDEO @"Video"

@interface Post (Create) <ILike, IJSON>

+ (void)findPost:(NSString *)uid  managedObjectContext:(NSManagedObjectContext *)managedObjectContext success:(void (^)(Post *post))success failure:(void (^)(NSDictionary *errorData))failure;
+ (Post *)postWithDictionary:(NSDictionary *)postDictionary  inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)newPost:(NSDictionary *)postDictionary managedObjectContext:(NSManagedObjectContext *)managedObjectContext success:(void (^)(Post *post))success failure:(void (^)(NSDictionary *errorData))failure;
+ (void)popular:(NSManagedObjectContext *)managedObjectContext success:(void (^)(NSArray *postArray))success failure:(void (^)(NSDictionary *errorData))failure;

- (void)setWithDictionary:(NSDictionary *)postDictionary;
- (void)deletePost:(void (^)())success failure:(void (^)(NSDictionary *errorData))failure;

- (void)likes:(void (^)(NSArray *likes))success failure:(void (^)(NSDictionary *errorData))failure;
- (void)like:(void (^)(Like *like))success failure:(void (^)(NSDictionary *errorData))failure;
- (void)unlike:(void (^)())success failure:(void (^)(NSDictionary *errorData))failure;

- (void)comments:(void (^)(NSArray *comments))success failure:(void (^)(NSDictionary *errorData))failure;
- (void)comment:(NSString *)content success:(void (^)(Comment *comment))success failure:(void (^)(NSDictionary *errorData))failure;
- (void)deleteComment:(Comment *)comment success:(void (^)())success failure:(void (^)(NSDictionary *errorData))failure;

- (void)inappropriate:(void (^)())success failure:(void (^)(NSDictionary *errorData))failure;

- (void)newsfeedForPost:(void (^)(Newsfeed *newsfeed))success failure:(void (^)(NSDictionary *errorData))failure;

- (NSData *)toJSON;

@end
