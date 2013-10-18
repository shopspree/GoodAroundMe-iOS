//
//  PostAPI.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/27/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "ApplicationHelper.h"
#import "PostAPI.h"
#import "Comment+Create.h"
#import "Like+Create.h"

@implementation PostAPI

+ (void)post:(NSString *)postID success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure
{
    NSData *json = nil;
    
    [BaseAPI getRequestWithURL:[NSString stringWithFormat:API_POST_SHOW, postID] json:json success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSString *message) {
        failure(message);
    }];
    
}

+ (void)newPost:(NSDictionary *)postDictionary success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure
{
    NSData *json = [PostAPI jsonRequestForPost:postDictionary];
    
    [BaseAPI postRequestWithURL:API_POST json:json success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSString *message) {
        failure(message);
    }];
}

+ (void)deletePost:(Post *)post success:(void (^)())success failure:(void (^)(NSString *message))failure
{
    NSData *json = nil;
    
    [BaseAPI deleteRequestWithURL:[NSString stringWithFormat:API_POST_DELETE, post.uid] json:json success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSString *message) {
        failure(message);
    }];
}

+ (void)likesOnPost:(Post *)post success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure
{
    NSData *json = nil;
    
    [BaseAPI getRequestWithURL:[NSString stringWithFormat:API_POST_LIKES, post.uid] json:json success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSString *message) {
        failure(message);
    }];
}

+ (void)likePost:(Post *)post success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure
{
    NSData *json = nil;
    
    [BaseAPI postRequestWithURL:[NSString stringWithFormat:API_POST_LIKE, post.uid]  json:json success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSString *message) {
        failure(message);
    }];
}

+ (void)unlike:(Like *)like post:(Post *)post success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure
{
    NSData *json = nil;
    
    [BaseAPI deleteRequestWithURL:[NSString stringWithFormat:API_POST_UNLIKE, post.uid, like.uid] json:json success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSString *message) {
        failure(message);
    }];
    
}

+ (void)commentsOnPost:(Post *)post success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure
{
    NSData *json = nil;
    
    [BaseAPI getRequestWithURL:[NSString stringWithFormat:API_POST_COMMENTS, post.uid] json:json success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSString *message) {
        failure(message);
    }];
}

+ (void)comment:(Comment *)comment onPost:(Post *)post success:(void (^)(NSDictionary *responseDictionary, Comment *comment))success failure:(void (^)(NSString *message))failure
{
    NSData *json = [PostAPI jsonRequestForComment:comment.content onPost:post];
    
    [BaseAPI postRequestWithURL:[NSString stringWithFormat:API_POST_COMMENT, post.uid] json:json success:^(NSDictionary *responseDictionary) {
        success(responseDictionary, comment);
    } failure:^(NSString *message) {
        failure(message);
    }];
}

+ (void)deleteComment:(Comment *)comment onPost:(Post *)post success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure
{
    NSData *json = nil;
    
    [BaseAPI deleteRequestWithURL:[NSString stringWithFormat:API_POST_COMMENT_DELETE, post.uid, comment.uid] json:json success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSString *message) {
        failure(message);
    }];
}

+ (void)inappropriatePost:(Post *)post success:(void (^)())success failure:(void (^)(NSString *message))failure
{
    NSData *json = nil;
    
    [BaseAPI postRequestWithURL:[NSString stringWithFormat:API_POST_INAPPROPRIATE, post.uid] json:json success:^(NSDictionary *responseDictionary) {
        success();
    } failure:^(NSString *message) {
        failure(message);
    }];
    
}

#pragma mark - private methods

+ (NSData *)jsonRequestForPost:(NSDictionary *)postDictionary
{
    NSData *jsonData = [ApplicationHelper constructJSON:postDictionary];
    return jsonData;
}

+ (NSData *)jsonRequestForComment:(NSString *)content onPost:(Post *)post
{
    NSDictionary *dataDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:post.uid, @"post_id",
                              [Comment constructJSONForContent:content], @"comment",
                              nil];
    NSData *jsonData = [ApplicationHelper constructJSON:dataDict];
    return jsonData;
}

@end
