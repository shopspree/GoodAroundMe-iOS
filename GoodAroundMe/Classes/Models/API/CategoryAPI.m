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
           failure:(void (^)(NSDictionary *errorData))failure
{
    [BaseAPI getRequestWithURL:API_ORGANIZATION_CATEGORIES json:nil success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}

@end
