//
//  FeedAPI.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/24/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "BaseAPI.h"

@interface FeedAPI : BaseAPI

+ (void)postNewsfeed:(NSString *)postId success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure;
+ (void)newsfeeds:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure;
+ (void)newsfeed:(NSString *)newsfeedID success:(void (^)(NSDictionary *newsfeedDictionary))success failure:(void (^)(NSDictionary *errorData))failure;

@end



