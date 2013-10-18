//
//  CategoryAPI.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/16/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "CategoryAPI.h"

@implementation CategoryAPI

+ (void)categories:(void (^)(NSDictionary *responseDictionary))success
           failure:(void (^)(NSString *message))failure
{
    [BaseAPI getRequestWithURL:API_ORGANIZATION_CATEGORIES json:nil success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSString *message) {
        failure(message);
    }];
}

@end
