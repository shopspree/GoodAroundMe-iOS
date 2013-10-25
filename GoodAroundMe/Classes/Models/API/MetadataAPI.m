//
//  MetadataAPI.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 10/25/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "MetadataAPI.h"

@implementation MetadataAPI

+ (void)metadata:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure
{
    NSData *json = nil;
    
    [BaseAPI postRequestWithURL:API_METADATA json:json success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSString *message) {
        failure(message);
    }];
    
}

@end
