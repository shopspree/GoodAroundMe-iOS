//
//  User+Create.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/25/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "User.h"
#import "IJSON.h"

#define USER @"user"
#define USER_LOGIN @"user_login"
#define USER_EMAIL @"email"
#define USER_AUTHENTICATION @"authentication_token"
#define USER_PASSWORD @"password"
#define USER_BOOTSTRAP @"boostrap"
#define PROFILE @"profile"
#define PROFILE_EMAIL @"email"
#define PROFILE_FULL_NAME @"full_name"
#define PROFILE_FIRST_NAME @"first_name"
#define PROFILE_LAST_NAME @"last_name"
#define PROFILE_THUMBNAIL_URL @"thumbnail_url"
#define PROFILE_PICTURE_URL @"picture_url"
#define PROFILE_CREATED_AT @"created_at"
#define PROFILE_UPDATED_AT @"updated_at"
#define JOB_PROFILE @"job_profile"
#define JOB_PROFILE_ORGANIZATION @"organization"
#define JOB_PROFILE_TITLE @"title"
#define JOB_PROFILE_EMAIL @"email"
#define GROUP @"group"

@interface User (Create) <IJSON>

+ (void)fullUserProfileByEmail:(NSString *)email managedObjectContext:(NSManagedObjectContext *)managedObjectContext success:(void (^)(User *user))success failure:(void (^)(NSDictionary *errorData))failure;
+ (User *)userWithDictionary:(NSDictionary *)userDictionary inManagedObjectContext:(NSManagedObjectContext *)context;
+ (User *)curretnUser:(NSManagedObjectContext *)context;
+ (void)signUp:(NSDictionary *)userDictionary success:(void (^)())success failure:(void (^)(NSDictionary *errorData))failure;
+ (void)signIn:(NSDictionary *)userDictionary success:(void (^)())success failure:(void (^)(NSDictionary *errorData))failure;
+ (void)signOut:(void (^)())success failure:(void (^)(NSDictionary *errorData))failure;
+ (void)changePassword:(NSString *)password confirmPassword:(NSString *)passwordConfirmation currentPassword:(NSString *)currentPassword success:(void (^)())success failure:(void (^)(NSDictionary *errorData))failure;
+ (void)search:(NSString *)keyword page:(NSInteger)page success:(void (^)(NSArray *usersArray))success failure:(void (^)(NSDictionary *errorData))failure;
+ (BOOL)validateEmail:(NSString*)email;
+ (BOOL)validateName:(NSString*)name;
+ (BOOL)validatePassword:(NSString *)password;

- (void)setWithDictionary:(NSDictionary *)userDictionary;
- (void)saveUser:(NSDictionary *)userDictionary success:(void (^)(User *user))success failure:(void (^)(NSDictionary *errorData))failure;
- (void)notifications:(void (^)())success failure:(void (^)(NSDictionary *errorData))failure;
- (void)acknowledgeNotifications:(void (^)())success failure:(void (^)(NSDictionary *errorData))failure;
- (NSData *)toJSON;

@end
