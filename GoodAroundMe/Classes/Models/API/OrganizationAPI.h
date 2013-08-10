//
//  OrganizationAPI.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/10/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "BaseAPI.h"
#import "Category+Create.h"

@interface OrganizationAPI : BaseAPI

+ (void)follow:(NSString *)organizationID success:(void (^)(NSDictionary *reponseDictionary))success
       failure:(void (^)(NSDictionary *errorData))failure;
+ (void)unfollow:(NSString *)organizationID success:(void (^)(NSDictionary *reponseDictionary))success
         failure:(void (^)(NSDictionary *errorData))failure;

@end
