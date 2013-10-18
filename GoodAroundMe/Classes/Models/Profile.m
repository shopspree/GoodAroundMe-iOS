//
//  Profile.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/21/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "Profile.h"

@implementation Profile

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    _firstName = [dictionary objectForKey:PROFILE_FIRST_NAME];
    _lastName = [dictionary objectForKey:PROFILE_LAST_NAME];
    _email = [dictionary objectForKey:PROFILE_EMAIL_KEY];
    
    return self;
}

- (NSDictionary *)toDictionary
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.firstName, PROFILE_FIRST_NAME,
                          self.lastName, PROFILE_LAST_NAME,
                          self.email, PROFILE_EMAIL_KEY,
                          nil];
    return data;
    
}

+ (BOOL)validateName:(NSString *)name
{
    BOOL isValid = NO;
    isValid = [name length] > 0;
    return isValid;
}

@end
