//
//  FeedbackAPI.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/12/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "FeedbackAPI.h"
#import "ApplicationHelper.h"

@implementation FeedbackAPI

+ (void)reportProblem:(NSString *)area content:(NSString *)content screenshotURL:(NSString *)screenshotURL success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure
{
    NSDictionary *feedbackDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:area, @"area", content, @"report", nil],@"problem", nil];
    NSData *json = [ApplicationHelper constructJSON:feedbackDictionary];
    
    [BaseAPI putRequestWithURL:API_USER json:json success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSString *message) {
        failure(message);
    }];
    
}

@end
