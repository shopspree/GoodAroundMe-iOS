//
//  OrganizationAPI.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/10/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "BaseAPI.h"
#import "Organization+Create.h"

@interface OrganizationAPI : BaseAPI

+ (void)newsfeedForOrganization:(Organization *)organization success:(void (^)(NSDictionary *reponseDictionary))success failure:(void (^)(NSString *message))failure;
+ (void)postsForOrganization:(Organization *)organization success:(void (^)(NSDictionary *reponseDictionary))success failure:(void (^)(NSString *message))failure;
+ (void)newOrganization:(Organization *)organization success:(void (^)(NSDictionary *reponseDictionary))success failure:(void (^)(NSString *message))failure;
+ (void)updateOrganization:(Organization *)organization success:(void (^)(NSDictionary *reponseDictionary))success failure:(void (^)(NSString *message))failure;
+ (void)follow:(NSString *)organizationID success:(void (^)(NSDictionary *reponseDictionary))success
       failure:(void (^)(NSString *message))failure;
+ (void)unfollow:(NSString *)organizationID success:(void (^)(NSDictionary *reponseDictionary))success
         failure:(void (^)(NSString *message))failure;

@end
