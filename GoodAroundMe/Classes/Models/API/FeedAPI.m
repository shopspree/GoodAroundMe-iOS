//
//  FeedAPI.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/24/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "FeedAPI.h"
#import "Newsfeed+Activity.h"

@implementation FeedAPI

+ (void)postNewsfeed:(NSString *)postId success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure
{
    NSData *json = nil;
    
    [BaseAPI getRequestWithURL:[NSString stringWithFormat:API_POST_ACTIVITY, postId] json:json success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSString *message) {
        failure(message);
    }];
}

+ (void)newsfeeds:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure
{
    NSData *json = nil;
    
    [BaseAPI getRequestWithURL:API_ACTIVITIES_URL json:json success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSString *message) {
        failure(message);
    }];
    
}


@end
