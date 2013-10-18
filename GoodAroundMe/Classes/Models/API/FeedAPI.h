//
//  FeedAPI.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/24/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "BaseAPI.h"

@interface FeedAPI : BaseAPI

+ (void)postNewsfeed:(NSString *)postId success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure;
+ (void)newsfeeds:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure;

@end



