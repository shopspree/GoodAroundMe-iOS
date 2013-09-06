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
#define USER_FULL_NAME @"full_name"
#define USER_FIRST_NAME @"first_name"
#define USER_LAST_NAME @"last_name"
#define USER_THUMBNAIL_URL @"thumbnail_url"
#define USER_PICTURE_URL @"picture_url"
#define USER_CREATED_AT @"created_at"
#define USER_UPDATED_AT @"updated_at"
#define USER_FOLLOWING @"following"

@interface User (Create) <IJSON>

+ (User *)userByEmail:(NSString *)email inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext success:(void (^)(User *user))success failure:(void (^)(NSString *message))failure;
+ (User *)userWithDictionary:(NSDictionary *)userDictionary inManagedObjectContext:(NSManagedObjectContext *)context;
+ (User *)currentUser:(NSManagedObjectContext *)context;

+ (void)signUp:(NSDictionary *)userDictionary success:(void (^)(User *user))success failure:(void (^)(NSString *message))failure;
+ (void)signIn:(NSDictionary *)userDictionary success:(void (^)(User *user))success failure:(void (^)(NSDictionary *errorData))failure;
+ (void)signOut:(void (^)())success failure:(void (^)(NSString *message))failure;
+ (void)search:(NSString *)keyword page:(NSInteger)page success:(void (^)(NSArray *usersArray))success failure:(void (^)(NSDictionary *errorData))failure;

+ (BOOL)validateEmail:(NSString*)email;
+ (BOOL)validateName:(NSString*)name;
+ (BOOL)validatePassword:(NSString *)password;

- (void)setWithDictionary:(NSDictionary *)userDictionary;
- (void)changePassword:(NSString *)password confirmPassword:(NSString *)passwordConfirmation currentPassword:(NSString *)currentPassword success:(void (^)())success failure:(void (^)(NSString *message))failure;
- (void)updateUser:(void (^)(User *user))success failure:(void (^)(NSString *message))failure;
- (void)follow:(Organization *)organization success:(void (^)())success failure:(void (^)(NSString *message))failure;
- (void)unfollow:(Organization *)organization success:(void (^)())success failure:(void (^)(NSString *message))failure;
- (NSData *)toJSON;
- (NSString *)getFullName;

@end
