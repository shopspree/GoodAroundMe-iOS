//
//  OrganizationAPI.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/10/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "OrganizationAPI.h"

@implementation OrganizationAPI

+ (void)newsfeedForOrganization:(Organization *)organization success:(void (^)(NSDictionary *reponseDictionary))success
                        failure:(void (^)(NSString *message))failure
{
    NSData *json = nil;
    
    [BaseAPI getRequestWithURL:[NSString stringWithFormat:API_ORGANIZATION_NEWSFEED, organization.uid] json:json success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSString *message) {
        failure(message);
    }];
}

+ (void)follow:(NSString *)organizationID success:(void (^)(NSDictionary *reponseDictionary))success
       failure:(void (^)(NSString *message))failure
{
    if (organizationID) {
        [BaseAPI postRequestWithURL:[NSString stringWithFormat:API_ORGANIZATION_FOLLOW, organizationID] json:nil success:^(NSDictionary *responseDictionary) {
            success(responseDictionary);
        } failure:^(NSString *message) {
            failure(message);
        }];
    }
}

+ (void)unfollow:(NSString *)organizationID success:(void (^)(NSDictionary *reponseDictionary))success
         failure:(void (^)(NSString *message))failure
{
    if (organizationID) {
        [BaseAPI deleteRequestWithURL:[NSString stringWithFormat:API_ORGANIZATION_UNFOLLOW, organizationID] json:nil success:^(NSDictionary *responseDictionary) {
            success(responseDictionary);
        } failure:^(NSString *message) {
            failure(message);
        }];
    }
}

@end
