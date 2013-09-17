//
//  FeedbackAPI.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/12/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "BaseAPI.h"

@interface FeedbackAPI : BaseAPI

+ (void)reportProblem:(NSString *)area content:(NSString *)content screenshotURL:(NSString *)screenshotURL success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure;

@end
