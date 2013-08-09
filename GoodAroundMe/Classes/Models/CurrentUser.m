//
//  CurrentUser.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/21/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "CurrentUser.h"

@implementation CurrentUser

#define USER_LOGIN @"user_login"

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    _email = [dictionary objectForKey:USER_EMAIL_KEY];
    _authToken = [dictionary objectForKey:USER_AUTHENTICATION_KEY];
    _password = [dictionary objectForKey:USER_PASSWORD_KEY];
    
    return self;
}

- (NSDictionary *)toDictionary
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.email, USER_EMAIL_KEY,
                              self.password, USER_PASSWORD_KEY,
                              nil];
    return data;
}

+ (NSData *)userLoginJSONWithEmail:(NSString *)email password:(NSString *)password
{
    NSDictionary *userData = [NSDictionary dictionaryWithObjectsAndKeys:
                               email, USER_EMAIL_KEY,
                               password, USER_PASSWORD_KEY,
                               nil];
    NSDictionary *userLoginData = [NSDictionary dictionaryWithObjectsAndKeys:
                              userData, USER_LOGIN,
                              nil];
    NSData *jsonData = [CurrentUser constructJSON:userLoginData];
    return jsonData;
}



+ (NSData *)userJSONWithDictionary:(NSDictionary *)userData 
{
    NSData *jsonData = [CurrentUser constructJSON:userData];
    return jsonData;
}

+ (BOOL)validateEmail:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)validatePassword:(NSString *)password
{
    BOOL isValid = NO;
    isValid = ([password length] > 0);
    return isValid;
}

@end
