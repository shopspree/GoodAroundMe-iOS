//
//  CurrentUser.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/21/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface CurrentUser : BaseModel

#define USER_EMAIL_KEY @"email"
#define USER_AUTHENTICATION_KEY @"authentication_token"
#define USER_PASSWORD_KEY @"password"

@property (nonatomic, strong) NSString *authToken;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;

+ (NSData *)userLoginJSONWithEmail:(NSString *)email password:(NSString *)password;
+ (BOOL)validateEmail:(NSString*)email;
+ (BOOL)validatePassword:(NSString *)password;

@end
