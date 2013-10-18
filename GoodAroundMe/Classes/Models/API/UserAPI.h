//
//  UserAPI.h
//  TempName
//
//  Created by asaf ahi-mordehai on 7/19/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "BaseAPI.h"
#import "User+Create.h" 

@interface UserAPI : BaseAPI

+ (void)userByEmail:(NSString *)email success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure;
+ (void)updateUser:(User *)user success:(void (^)(NSDictionary *userDictionary))success failure:(void (^)(NSString *message))failure;
+ (void)notificationsForUser:(User *)user success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure;
+ (void)acknowledgeNotificationsForUser:(User *)user success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure;

+ (void)signUp:(NSDictionary *)userDictionary success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure;
+ (void)signIn:(NSDictionary *)userDictionary success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure;
+ (void)signOut:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure;
+ (void)changePassword:(NSDictionary *)requestDictionary forEmail:(NSString *)email success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure;
+ (void)search:(NSString *)keyword page:(NSInteger)page success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure;
+ (void)followedOrganizationsByUserEmail:(NSString *)email success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure;

@end
