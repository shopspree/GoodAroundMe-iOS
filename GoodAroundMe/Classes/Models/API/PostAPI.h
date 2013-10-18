//
//  PostAPI.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/27/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "BaseAPI.h"
#import "Post+Create.h"

@interface PostAPI : BaseAPI

// posts
+ (void)post:(NSString *)postID success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure;
+ (void)newPost:(NSDictionary *)postDictionary success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure;
+ (void)deletePost:(Post *)post success:(void (^)())success failure:(void (^)(NSString *message))failure;

// likes
+ (void)likesOnPost:(Post *)post success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure;
+ (void)likePost:(Post *)post success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure;
+ (void)unlike:(Like *)like post:(Post *)post success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure;

// comments
+ (void)commentsOnPost:(Post *)post success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure;
+ (void)comment:(Comment *)comment onPost:(Post *)post success:(void (^)(NSDictionary *responseDictionary, Comment *comment))success failure:(void (^)(NSString *message))failure;
+ (void)deleteComment:(Comment *)comment onPost:(Post *)post success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure;

// inappropriate reports
+ (void)inappropriatePost:(Post *)post success:(void (^)())success failure:(void (^)(NSString *message))failure;

@end
