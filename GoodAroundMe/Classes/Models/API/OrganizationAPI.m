//
//  OrganizationAPI.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/10/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "OrganizationAPI.h"

@implementation OrganizationAPI

+ (void)follow:(NSString *)organizationID success:(void (^)(NSDictionary *reponseDictionary))success
                         failure:(void (^)(NSDictionary *errorData))failure
{
    if (organizationID) {
        [BaseAPI postRequestWithURL:[NSString stringWithFormat:API_ORGANIZATION_FOLLOW, organizationID] json:nil success:^(NSDictionary *responseDictionary) {
            success(responseDictionary);
        } failure:^(NSDictionary *errorData) {
            failure(errorData);
        }];
    }
}

+ (void)unfollow:(NSString *)organizationID success:(void (^)(NSDictionary *reponseDictionary))success
       failure:(void (^)(NSDictionary *errorData))failure
{
    if (organizationID) {
        [BaseAPI deleteRequestWithURL:[NSString stringWithFormat:API_ORGANIZATION_UNFOLLOW, organizationID] json:nil success:^(NSDictionary *responseDictionary) {
            success(responseDictionary);
        } failure:^(NSDictionary *errorData) {
            failure(errorData);
        }];
    }
}

@end
